#!/bin/bash

{
  "분류": "계정 관리",
  "코드": "1.1",
  "위험도": "중요도 상",
  "진단_항목": "AD 사용자 계정 관리",
  "대응방안": {
    "설명": "Azure AD(Azure Active Directory)는 클라우드 기반 ID 및 액세스 관리 서비스입니다, Microsoft 365, Azure Portal 및 기타 SaaS 애플리케이션 접근을 제공합니다. 사용자 프로필 구성, 네이밍룰 적용, 역할 할당을 통해 효율적인 사용자 관리를 지원합니다. 관리 ID 또는 서비스 주체 사용을 권장합니다.",
    "설정방법": [
      "Azure Active Directory 메뉴 내 사용자 기능 선택",
      "모든 사용자 메뉴 내 새 사용자 버튼 클릭",
      "사용자 정보 입력 및 디렉터리 역할 선택 시 전역/제한된 관리자 선택",
      "모든 사용자 목록 내 전역/제한된 관리자 생성 여부 확인",
      "모든 사용자 부여된 역할 확인"
    ]
  },
  "현황": [],
  "진단_결과": "양호"  // '취약'으로 업데이트 가능
}


# List all users in Azure AD and their directory roles
users_output=$(az ad user list --query '[].{userPrincipalName:userPrincipalName, objectId:objectId}' --output tsv)
if [ $? -ne 0 ]; then
    echo "Failed to retrieve users."
    exit 1
fi

# Check global and limited admin roles for each user
echo "Checking user roles..."
for user in $users_output; do
    user_principal_name=$(echo $user | awk '{print $1}')
    object_id=$(echo $user | awk '{print $2}')
    roles_output=$(az role assignment list --assignee $object_id --query '[].roleDefinitionName' --output tsv)

    if [[ $roles_output == *"Global Administrator"* ]]; then
        echo "User $user_principal_name is a Global Administrator."
    elif [[ $roles_output == *"User Access Administrator"* ]]; then
        echo "User $user_principal_name is a User Access Administrator."
    else
        echo "User $user_principal_name has limited or no administrative roles."
    fi
done

# User prompt to check a specific user's roles
read -p "Enter User Principal Name to check roles: " upn
role_check_output=$(az ad user get-member-groups --upn-or-object-id $upn --security-enabled-only --query '[]' --output tsv)
if [ $? -eq 0 ]; then
    if [ -n "$role_check_output" ]; then
        echo "User '$upn' is a member of the following security groups: $role_check_output"
    else
        echo "User '$upn' does not have significant security group memberships."
    fi
else
    echo "Failed to retrieve roles for User '$upn'."
    exit 1
fi
