#!/bin/bash

{
  "분류": "계정 관리",
  "코드": "1.3",
  "위험도": "중요도 중",
  "진단_항목": "AD 그룹 소유자 및 구성원 관리",
  "대응방안": {
    "설명": "Azure AD를 사용 시 그룹을 통해 권한을 할당하거나 리소스에 대한 액세스 권한을 부여할 수 있으며, 해당 그룹 구성원인 사용자는 그룹의 액세스 권한을 상속받게 됩니다. 그룹은 소유자를 지정하여 그룹 및 그룹 구성원을 관리할 수 있습니다.",
    "설정방법": [
      "Azure AD 메뉴 내 그룹 기능 선택",
      "그룹메뉴 내 새 그룹 버튼 클릭",
      "그룹 관련 내용 설정 및 만들기(소유자 추가 설정 필요)",
      "모든 그룹 목록 내 정상 생성 여부 확인",
      "소유자/구성원을 추가할 그룹 선택",
      "구성원 기능 선택 후 구성원 추가 버튼 클릭 및 추가할 구성원 검색 (소유자 설정 방식 동일)",
      "구성원 목록 내 정상 생성 여부 확인"
    ]
  },
  "현황": [],
  "진단_결과": "양호"  // '취약'으로 업데이트 가능
}


# Log in to Azure
az login --output none

# Fetch and list all groups in Azure AD
groups_output=$(az ad group list --query '[].{name:displayName, id:objectId}' --output tsv)
if [ $? -ne 0 ]; then
    echo "Failed to retrieve Azure AD groups."
    exit 1
fi

echo "Retrieved Azure AD groups:"
echo "$groups_output"

# User prompt to check a specific group for ownership and membership details
read -p "Enter the Azure AD Group name to check: " group_name
group_id=$(az ad group show --group "$group_name" --query 'objectId' --output tsv)

if [ -z "$group_id" ]; then
    echo "Group not found."
    exit 1
fi

# Checking ownership and membership of the specific group
owners_output=$(az ad group owner list --id "$group_id" --query '[].displayName' --output tsv)
members_output=$(az ad group member list --group "$group_id" --query '[].displayName' --output tsv)

echo "Owners of the group '$group_name': $owners_output"
echo "Members of the group '$group_name': $members_output"

# Diagnose the criteria
if [[ -n "$owners_output" && -n "$members_output" ]]; then
    echo "The group '$group_name' meets the standards: Has both owners and members assigned."
    diagnosis_result="양호"
else
    echo "The group '$group_name' does not meet the standards: Missing owners or members."
    diagnosis_result="취약"
fi

# Update JSON diagnosis result dynamically
sed -i "s/\"진단_결과\": \"양호\"/\"진단_결과\": \"$diagnosis_result\"/" <path_to_json_file>
