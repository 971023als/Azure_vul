#!/bin/bash

# 변수 초기화
분류="가상 리소스 관리"
코드="3.4"
위험도="중요도 중"
진단_항목="보안그룹 인/아웃바운드 불필요 정책 관리"
대응방안='{
  "설명": "네트워크 보안 그룹은 네트워크 규칙(Source, Destination)을 추가하거나 제거가 가능하며, 인바운드 및 아웃바운드 트래픽에 적용됩니다. 불필요한 정책이 존재할 경우 Azure 리소스에 비정상적인 접근 또는 2차 공격에 활용될 수 있습니다.",
  "설정방법": [
    "네트워크 보안 그룹 선택",
    "서비스에 필요한 인바운드 보안 규칙(IP Address) 추가",
    "필요하지 않은 규칙 확인 및 제거"
  ]
}'
현황=()
진단_결과=""

# 진단 시작
echo "진단 시작..."
# Azure CLI를 사용하여 네트워크 보안 그룹의 현재 설정을 검사
# 예시: az network nsg rule list --nsg-name <NameOfSecurityGroup> --resource-group <NameOfResourceGroup> --query "[].{name:name, sourceAddressPrefix:sourceAddressPrefix, destinationAddressPrefix:destinationAddressPrefix, access:access, direction:direction}" --output json

# 임시 진단 결과 할당
진단_결과="양호" # 또는 "취약"을 할당할 수 있습니다. 기준에 따라 검사 후 결정

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
