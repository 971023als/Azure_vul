#!/bin/bash

{
  "분류": "계정 관리",
  "코드": "1.10",
  "위험도": "중요도 중",
  "진단_항목": "AKS 서비스 어카운트 관리",
  "대응방안": {
    "설명": "서비스 어카운트는 파드에 쿠버네티스 RBAC 역할을 할당할 수 있는 특수한 유형의 개체이며, Cluster 내의 각 네임스페이스에 기본 서비스 어카운트가 자동으로 생성됩니다. 특정 서비스 어카운트를 참조하지 않고 네임스페이스에 파드를 배포하면, 해당 네임스페이스의 파드에 자동으로 할당되고 서비스 어카운트의 JWT 토큰은 특정 경로의 볼륨으로 파드에 마운트됩니다.",
    "설정방법": [
      "서비스 어카운트 토큰 자동 마운트 비활성화 여부 확인: kubectl get serviceaccount default –o yaml",
      "서비스 어카운트 토큰 자동 마운트 비활성화 (false) 설정 및 확인: kubectl patch serviceaccount default -p $'automountServiceAccountToken: false'"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Ensure kubectl is configured to communicate with your AKS cluster
echo "Checking AKS Cluster configuration..."
kubectl config current-context
if [ $? -ne 0 ]; then
    echo "Failed to find a configured AKS cluster. Please configure kubectl."
    exit 1
fi

# Check the current auto-mount setting for the default service account in the default namespace
echo "Fetching current service account settings..."
service_account_settings=$(kubectl get serviceaccount default -n default -o json)
auto_mount_enabled=$(echo $service_account_settings | jq '.automountServiceAccountToken')

echo "Current auto-mount setting: $auto_mount_enabled"

# Checking compliance with policy
if [[ "$auto_mount_enabled" != "false" ]]; then
    echo "Service account settings are non-compliant with policy. Adjusting settings..."
    # Disabling auto-mount of service account tokens
    kubectl patch serviceaccount default -n default -p '{"automountServiceAccountToken":false}'
    if [ $? -eq 0 ]; then
        echo "Service account settings have been successfully updated to disable token auto-mount."
    else
        echo "Failed to update service account settings."
        exit 1
    fi
else
    echo "Service account settings are compliant with the policy."
fi
