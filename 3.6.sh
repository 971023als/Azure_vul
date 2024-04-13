#!/bin/bash

# 변수 초기화
분류="가상 리소스 관리"
코드="3.6"
위험도="중요도 중"
진단_항목="방화벽 불필요 정책 관리"
대응방안='{
  "설명": "Azure Firewall은 클라우드 기반의 네트워크 보안 서비스로서 Azure Virtual Network 리소스를 보호합니다. 방화벽 정책 내에 불필요한 규칙이 존재할 경우 Azure 리소스에 대한 비정상적인 접근 또는 2차 공격의 원인이 될 수 있습니다. 따라서 설정된 정책의 출발지와 목적지 IP주소 범위, 프로토콜/Port, 허용/차단, 정책 순서를 종합적으로 검증하여 불필요한 규칙이 없도록 주기적으로 확인해야 합니다.",
  "설정방법": [
    "방화벽 메뉴에서 네트워크 규칙을 삭제할 방화벽 선택",
    "네트워크 규칙 컬렉션 선택",
    "개별 규칙 삭제 버튼 선택",
    "NAT 규칙 삭제",
    "삭제 완료 후 정상적인 삭제 유무 확인"
  ]
}'
현황=()
진단_결과=""

# 진단 시작
echo "진단 시작..."
# Azure CLI를 사용하여 Azure Firewall의 규칙을 검사
 az network firewall policy rule-collection-group list --resource-group <ResourceGroupName> --firewall-policy-name <FirewallPolicyName> --query "[].{name:name, rules:rules[].{sourceAddresses:sourceAddresses, destinationAddresses:destinationAddresses, destinationPorts:destinationPorts, protocols:protocols}}" --output json

# 임시 진단 결과 할당
진단_결과="양호" # 또는 "취약"을 할당할 수 있습니다. 규칙 검토 후 결정

# 결과 JSON 출력
echo "{
  \"분류\": \"$분류\",
  \"코드\": \"$코드\",
  \"위험도\": \"$위험도\",
  \"진단_항목\": \"$진단_항목\",
  \"대응방안\": $대응방안,
  \"현황\": $현황,
  \"진단_결과\": \"$진단_결과\"
}"
