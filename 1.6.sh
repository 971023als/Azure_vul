#!/bin/bash

{
  "분류": "계정 관리",
  "코드": "1.6",
  "위험도": "중요도 하",
  "진단_항목": "SSH Key 접근 관리",
  "대응방안": {
    "설명": "SSH 키는 AZURE 포탈을 통해 생성 할 수 있으며 해당 키는 가상 머신에 적용하여 사용할 수 있습니다. 이에 불필요한 사용자 및 비인가된 사용자가 액세스 제어(IAM) 사용자/그룹 역할이 적용될 경우 가상머신 리소스에 접근이 가능해지는 문제가 발생할 수 있습니다.",
    "설정방법": [
      "SSH 키 추가",
      "SSH 키 정보 입력 및 만들기",
      "프라이빗 키 별도 다운로드",
      "생성된 SSH 키 확인",
      "SSH 키의 액세스 제어(IAM) 역할 할당 추가",
      "SSH 키의 액세스 제어(IAM) 리스트 확인"
    ]
  },
  "현황": [],
  "진단_결과": "양호"  // '취약'으로 업데이트 가능
}


# Log in to Azure
az login --output none

# Fetch and list all SSH keys configured within Azure VMs
echo "Fetching all Azure VMs and their associated SSH keys..."
vm_output=$(az vm list --query '[].{name:name, osProfile:osProfile.linuxConfiguration.ssh.publicKeys}' --output json)
if [ $? -ne 0 ]; then
    echo "Failed to retrieve VMs and their SSH keys."
    exit 1
fi

echo "VMs and SSH keys:"
echo "$vm_output"

# Script to check the specific SSH key for IAM role assignments
read -p "Enter the name of the VM to check SSH key and IAM roles: " vm_name
ssh_key_output=$(az vm show --name "$vm_name" --query 'osProfile.linuxConfiguration.ssh.publicKeys' --output json)

if [ -z "$ssh_key_output" ]; then
    echo "No SSH key found for VM: $vm_name"
else
    echo "SSH key for VM $vm_name: $ssh_key_output"
    # Assuming a function to check IAM roles associated with the SSH key if applicable
    # This part needs to be adjusted based on how SSH keys and IAM roles are linked within your infrastructure
fi

# Example of diagnostic criteria check
echo "Checking compliance of SSH key settings..."
# Placeholder for compliance check logic
# Replace with actual checks as per your environment requirements
if [ condition_to_check_compliance ]; then
    echo "SSH Key settings are compliant."
    diagnosis_result="양호"
else
    echo "SSH Key settings are not compliant."
    diagnosis_result="취약"
fi

# Update JSON diagnosis result dynamically
sed -i "s/\"진단_결과\": \"양호\"/\"진단_결과\": \"$diagnosis_result\"/" <path_to_json_file>
