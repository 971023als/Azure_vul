#!/bin/bash

{
  "분류": "권한 관리",
  "코드": "2.1",
  "위험도": "중요도 상",
  "진단_항목": "구독 액세스 제어(IAM) 역할 관리",
  "대응방안": {
    "설명": "Azure에서 리소스를 관리하는 데 사용되는 IAM 역할은 조직의 보안과 리소스 관리를 위해 중요합니다. '소유자', '기여자', '사용자 액세스 관리자', '독자'와 같은 역할은 특정 사용자에게 리소스에 대한 권한을 부여하는데 사용됩니다. 이 역할들은 적절하게 관리되어야 하며, 불필요하게 높은 권한이 부여되지 않도록 주의가 필요합니다.",
    "설정방법": [
      "Azure 포털에 로그인 후, Azure Active Directory에서 '역할 및 관리자' 섹션에 접근",
      "역할 할당 추가를 위해 '역할 할당 추가' 버튼 클릭",
      "역할 할당을 위한 사용자나 그룹 선택",
      "적절한 역할 선택 후 할당"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Ensure you're logged in to Azure
az login --output none

# Set the subscription ID for the subscription you want to manage
subscription_id="your-subscription-id"
az account set --subscription "$subscription_id"

# List current role assignments
echo "Current IAM role assignments:"
az role assignment list --subscription "$subscription_id"

# Optionally, add a new role assignment
echo "Adding a new role assignment..."
# Define the role, assignee, and scope
role="Contributor"  # Change as needed
assignee="user-or-service-principal-id"  # Change as needed
scope="/subscriptions/$subscription_id"  # Change as needed for more specific scopes

# Create the role assignment
az role assignment create --assignee "$assignee" --role "$role" --scope "$scope"
echo "Role assigned successfully."

# List updated role assignments
echo "Updated IAM role assignments:"
az role assignment list --subscription "$subscription_id"
