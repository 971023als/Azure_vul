#!/bin/bash

{
  "분류": "계정 관리",
  "코드": "1.4",
  "위험도": "중요도 상",
  "진단_항목": "AD 게스트 사용자",
  "대응방안": {
    "설명": "조직과 공동 작업하는 모든 사용자를 Azure AD(Active Directory)의 게스트 사용자로 추가하여 초대할 수 있습니다. 게스트 사용자는 기본적으로 제한적인 권한을 갖고 있지만, 필요에 따라 AD 게스트 사용자에게 구성원 사용자와 동일한 권한을 부여할 수 있습니다.",
    "설정방법": [
      "Azure Active Directory 메뉴 내 사용자 기능 선택",
      "모든 사용자 메뉴 내 외부 사용자 초대 클릭",
      "초대할 게스트 사용자의 E-mail 주소 입력 및 초대",
      "모든 사용자 목록 내 게스트 사용자 초대 정상 여부 확인",
      "게스트 사용자 초대 메일 수신 (초대받은 게스트 사용자 시점)",
      "메일 내용 내 시작 버튼 클릭",
      "Azure 정상 로그인 여부 확인"
    ]
  },
  "현황": [],
  "진단_결과": "양호"  // '취약'으로 업데이트 가능
}


# Log in to Azure
az login --output none

# Fetch all users in Azure AD including guest users
echo "Fetching all Azure AD users..."
users_output=$(az ad user list --query "[?userType=='Guest'].{Name:displayName, Email:mail, UserType:userType}" --output json)
if [ $? -ne 0 ]; then
    echo "Failed to retrieve Azure AD users."
    exit 1
fi

echo "List of guest users:"
echo "$users_output"

# Check for specific guest user status
read -p "Enter the email address of the guest user to check: " guest_email
guest_user_details=$(az ad user list --query "[?mail=='$guest_email'].{Name:displayName, Email:mail, UserType:userType}" --output json)

if [[ -n "$guest_user_details" && "$guest_user_details" != "[]" ]]; then
    echo "Details of the guest user ($guest_email):"
    echo "$guest_user_details"
else
    echo "No guest user found with the email $guest_email."
fi

# Diagnostic to determine if there are unnecessary guest accounts
unnecessary_accounts=$(az ad user list --query "[?userType=='Guest' && accountEnabled==false].mail" --output tsv)
if [[ -n "$unnecessary_accounts" ]]; then
    echo "Unnecessary guest accounts detected:"
    echo "$unnecessary_accounts"
    diagnosis_result="취약"
else
    echo "No unnecessary guest accounts detected."
    diagnosis_result="양호"
fi

# Update JSON diagnosis result dynamically
sed -i "s/\"진단_결과\": \"양호\"/\"진단_결과\": \"$diagnosis_result\"/" <path_to_json_file>
