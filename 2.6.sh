#!/bin/bash

{
  "분류": "권한 관리",
  "코드": "2.3",
  "위험도": "중요도 상",
  "진단_항목": "AD 사용자 역할 권한 관리",
  "대응방안": {
    "설명": "Azure AD는 다양한 관리자 역할을 제공하여 클라우드 리소스 및 서비스 접근을 세분화하게 관리할 수 있습니다. 역할에 따라 리소스 관리, 인증 방법 설정, 애플리케이션 및 데이터 보안 관리 등의 권한을 부여받습니다. 이는 조직의 보안 및 운영 효율성을 높이는 데 중요합니다.",
    "설정방법": [
      "Azure 포털에 로그인",
      "Azure Active Directory 서비스로 이동",
      "사용자 관리 영역에서 새 사용자 추가 또는 기존 사용자 역할 수정",
      "역할에 맞는 권한 할당 및 역할 확인"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Ensure Azure CLI is logged in
az login --output none

# Set Azure AD variables
aad_domain_name="your-aad-domain.onmicrosoft.com"

# List all users in Azure Active Directory
echo "Listing all users in Azure AD..."
az ad user list --query [].{UserPrincipalName:userPrincipalName,DisplayName:displayName}

# Create a new user (optional)
echo "Creating a new user in Azure AD..."
user_principal_name="new_user@$aad_domain_name"
display_name="New User"
password="YourSecurePassword" # Change this to a secure value or method
az ad user create --user-principal-name "$user_principal_name" --display-name "$display_name" --password "$password"

# Assign role to user
echo "Assigning role to the user..."
role="User Administrator"  # Example role, change as needed
az role assignment create --assignee "$user_principal_name" --role "$role"

# Confirm role assignment
echo "Confirming role assignment for the user..."
az ad user get-member-groups --upn-or-object-id "$user_principal_name" --query []

# Optional: Manage role-specific properties or constraints
# This is more complex and often requires additional scripting or manual setup within the Azure portal

echo "Script execution completed."
