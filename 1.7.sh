#!/bin/bash

{
  "분류": "계정 관리",
  "코드": "1.7",
  "위험도": "중요도 상",
  "진단_항목": "MFA (Multi-Factor Authentication) 설정",
  "대응방안": {
    "설명": "MFA(2차 인증방식)의 보안은 계층화된 접근 방식을 기반으로 합니다. MFA는 일반 사용자에게도 사용을 통해 관리계정 보안을 향상시킬 수 있으며 특히 관리자 계정에 MFA를 설정할 경우 Azure 리소스 생성/관리보안도 함께 강화할 수 있습니다.",
    "설정방법": [
      "Azure Active Directory 메뉴 내 사용자 기능 선택",
      "모든 사용자 메뉴 내 사용자 별 MFA 선택",
      "다단계 인증 내 MFA를 사용할 사용자 선택 및 사용 버튼 클릭",
      "AD 계정으로 Azure 로그인 시도",
      "MFA에 사용될 Microsoft Authenticator 앱 시작하기",
      "모바일 앱 설치 후 QR 코드 스캔",
      "모바일 앱 인증 알림 승인 완료",
      "AD 계정으로 Azure 로그인 재 진행",
      "휴대폰으로 발송된 요청 승인 시 MFA를 통한 로그인 가능"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Log in to Azure
az login --output none

# Fetch the status of MFA settings for all users
echo "Checking MFA settings for all users..."
mfa_status=$(az ad user list --query "[].{name:displayName, mfaEnabled:signInActivity.mfaEnabled}" --output json)

if [ $? -ne 0 ]; then
    echo "Failed to retrieve MFA settings."
    exit 1
fi

echo "MFA settings for users:"
echo "$mfa_status"

# Verify MFA status for a specific user
read -p "Enter the username to check specific MFA status: " username
user_mfa_status=$(az ad user show --id "$username" --query "{name:displayName, mfaEnabled:signInActivity.mfaEnabled}" --output json)

if [[ $(echo $user_mfa_status | jq '.mfaEnabled') == "true" ]]; then
    echo "MFA is enabled for $username."
    diagnosis_result="양호"
else
    echo "MFA is not enabled for $username."
    diagnosis_result="취약"
fi

# Update JSON diagnosis result dynamically
sed -i "s/\"진단_결과\": \"양호\"/\"진단_결과\": \"$diagnosis_result\"/" <path_to_json_file>
