#!/bin/bash

{
  "분류": "계정 관리",
  "코드": "1.2",
  "위험도": "중요도 중",
  "진단_항목": "AD 사용자 프로필 및 디렉터리 식별 관리",
  "대응방안": {
    "설명": "생성된 Active Directory 사용자에 대한 정보를 프로필 가능을 통해 추가, 수정할 수 있습니다. 사용자 계정에 대한 프로필 정보는 서비스 사용에 대한 식별/감사/추적 등을 명확하게 할 수 있기 때문에 정확한 정보를 기입하는 것이 필요합니다.",
    "설정방법": [
      "Active Directory의 사용자 리스트 내 개별 사용자 클릭",
      "사용자 메뉴의 속성 편집 버튼 클릭",
      "속성 정보 확인 및 수정(ID)",
      "속성 정보 수정(연락처)",
      "속성 정보 수정(작업 정보) 후 저장 클릭"
    ]
  },
  "현황": [],
  "진단_결과": "양호"  // '취약'으로 업데이트 가능
}


# Login to Azure if not already logged in
az login --output none

# Get all Azure AD users and check required profile information
users_output=$(az ad user list --query '[].{userPrincipalName:userPrincipalName, objectId:objectId}' --output tsv)
if [ $? -ne 0 ]; then
    echo "Failed to retrieve users."
    exit 1
fi

# Iterate over users to check detailed profile info
echo "Checking user profiles..."
for user in $users_output; do
    user_principal_name=$(echo $user | awk '{print $1}')
    object_id=$(echo $user | awk '{print $2}')

    # Fetch detailed profile information
    profile_info=$(az ad user show --id $object_id --query '{DisplayName:displayName, Department:department, JobTitle:jobTitle, Email:mail}' --output json)
    if [ $? -eq 0 ]; then
        echo "Profile information for $user_principal_name: $profile_info"
        # Example check for missing information
        if [[ $(echo $profile_info | jq '.DisplayName') == "null" || $(echo $profile_info | jq '.Department') == "null" || $(echo $profile_info | jq '.JobTitle') == "null" ]]; then
            echo "User $user_principal_name profile is incomplete."
        else
            echo "User $user_principal_name profile is complete."
        fi
    else
        echo "Failed to retrieve profile for User '$user_principal_name'."
    fi
done
