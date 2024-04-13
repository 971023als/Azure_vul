#!/bin/bash

{
  "분류": "계정 관리",
  "코드": "1.11",
  "위험도": "중요도 상",
  "진단_항목": "AKS 불필요한 익명 접근 관리",
  "대응방안": {
    "설명": "클라우드 환경에서는 API 및 리소스 작업 시 익명 사용자의 접근을 비활성화해야 합니다. 쿠버네티스는 기본적으로 system:anonymous 사용자에 대한 권한을 부여할 수 있는데, 이러한 권한은 매우 제한적이어야 하며, 필요한 경우만 익명 액세스를 허용해야 합니다.",
    "설정방법": [
      "kubectl 명령을 통한 불필요 익명 사용자 조회: kubectl get clusterrolebindings,rolebindings --all-namespaces -o=jsonpath='{.items[?(@.subjects[*].name==\"system:anonymous\")].metadata.name}'",
      "불필요한 익명 접근 삭제: kubectl delete clusterrolebinding,rolebinding [name]",
      "정책 삭제 결과 확인: kubectl get clusterrolebindings,rolebindings --all-namespaces"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Ensure Azure CLI and kubectl are installed and you are logged into Azure
az login --output none
az aks get-credentials --resource-group YourResourceGroup --name YourClusterName

# Check for any roles or bindings allowing anonymous access
echo "Checking for unnecessary anonymous access in AKS..."
anonymous_access=$(kubectl get clusterrolebindings,rolebindings --all-namespaces -o=jsonpath='{.items[?(@.subjects[*].name=="system:anonymous")].metadata.name}')

if [ ! -z "$anonymous_access" ]; then
    echo "Found unnecessary anonymous access roles or bindings:"
    echo "$anonymous_access"
    echo "Removing them..."
    for role in $anonymous_access; do
        kubectl delete clusterrolebinding,rolebinding $role
        echo "Removed $role"
    done
else
    echo "No unnecessary anonymous access found."
fi

# Verify removal
echo "Verifying removal of unnecessary anonymous access..."
new_check=$(kubectl get clusterrolebindings,rolebindings --all-namespaces -o=jsonpath='{.items[?(@.subjects[*].name=="system:anonymous")].metadata.name}')
if [ -z "$new_check" ]; then
    echo "All unnecessary anonymous accesses have been successfully removed."
else
    echo "Failed to remove all unnecessary anonymous accesses:"
    echo "$new_check"
fi
