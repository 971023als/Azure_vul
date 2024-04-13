#!/bin/bash

{
  "분류": "권한 관리",
  "코드": "2.2",
  "위험도": "중요도 상",
  "진단_항목": "리소스 그룹 액세스 제어(IAM) 역할 할당",
  "대응방안": {
    "설명": "Azure 리소스 그룹을 효과적으로 관리하기 위해 적절한 IAM 역할 할당이 필요합니다. 이는 리소스 그룹에 리소스를 적절하게 할당하고, 관련 리소스에 대한 접근을 관리하는 데 중요한 역할을 합니다. ‘소유자’, ‘기여자’, ‘사용자 액세스 관리자’, ‘독자’ 등의 역할을 통해 리소스 그룹에 대한 접근을 세분화하여 관리할 수 있습니다.",
    "설정방법": [
      "Azure 포털 로그인 후 리소스 그룹 섹션으로 이동",
      "리소스 그룹 생성 후, 필요에 따라 IAM 역할 할당",
      "역할 할당을 위해 '역할 할당 추가' 버튼 클릭",
      "적절한 역할과 사용자 혹은 그룹 선택 후 할당"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Ensure Azure CLI is logged in
az login --output none

# Set the resource group name and subscription ID
resource_group="your-resource-group-name"
subscription_id="your-subscription-id"
az account set --subscription "$subscription_id"

# Create a new resource group if necessary
echo "Creating a new resource group..."
az group create --name "$resource_group" --location "East US"  # Change location as needed

# List current role assignments for the resource group
echo "Current IAM role assignments for the resource group:"
az role assignment list --resource-group "$resource_group"

# Adding a new role assignment to the resource group
echo "Adding a new role assignment..."
role="Contributor"  # Example role, change as needed
assignee="user-or-service-principal-id"  # Change as needed

# Assign role to the resource group
az role assignment create --assignee "$assignee" --role "$role" --resource-group "$resource_group"
echo "Role assigned successfully to the resource group."

# List updated role assignments for the resource group
echo "Updated IAM role assignments for the resource group:"
az role assignment list --resource-group "$resource_group"
