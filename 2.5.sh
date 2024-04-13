#!/bin/bash

{
  "분류": "권한 관리",
  "코드": "2.5",
  "위험도": "중요도 상",
  "진단_항목": "네트워크 서비스 액세스 정책 관리",
  "대응방안": {
    "설명": "Azure RBAC을 활용하여 네트워크 서비스에 대한 접근 권한을 역할에 따라 제한함으로써 보안을 강화하고, 필요한 사용자만이 필요한 작업을 수행할 수 있도록 합니다. 이는 가상 네트워크, Front Door, CDN 프로필 등 다양한 네트워크 서비스에 적용됩니다.",
    "설정방법": [
      "Azure Portal 접속 후 네트워크 서비스 선택",
      "IAM 설정을 통한 역할 할당",
      "역할 별 접근 권한을 확인하고, 필요에 따라 조정",
      "액세스 정책 변경 사항 검토 및 적용"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}

# Ensure Azure CLI is logged in
az login --output none

# List available network services and their current access policies
echo "Listing available network services and their current access policies..."
az network vnet list --output table
az network dns zone list --output table

# Assign a role to a specific network service
read -p "Enter the network service resource ID to modify roles: " resource_id
read -p "Enter the role to assign (e.g., 'Network Contributor'): " role_name
read -p "Enter the user's email or principal ID: " user_id
echo "Assigning role '$role_name' to user '$user_id' for resource '$resource_id'..."
az role assignment create --assignee "$user_id" --role "$role_name" --scope "$resource_id"

# Confirm role assignment
echo "Confirming role assignment..."
assigned_roles=$(az role assignment list --assignee "$user_id" --query "[].roleDefinitionName" --output tsv)
echo "Roles assigned to $user_id: $assigned_roles"

# Optional: Review or adjust role permissions based on operational requirements
# This may involve reviewing detailed policies and permissions through the Azure portal or additional Azure CLI commands

echo "Script execution completed."