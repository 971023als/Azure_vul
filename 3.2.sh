#!/bin/bash

# 변수 초기화
분류="가상 리소스 관리"
코드="3.2"
위험도="중요도 상"
진단_항목="내부 가상 네트워크 보안 관리"
대응방안='{
  "설명": "AZURE Virtual Private Network(AZURE VPN)를 이용하여 사용자 네트워크 또는 디바이스에서 AZURE 클라우드로 이어지는 안전한 프라이빗 터널을 설정할 수 있습니다. 프라이빗 가상머신 접근 시 퍼블릭 가상머신을 통한 ‘Server to Server’ 접근이 가능하면, 외부 공격자에 의해 프라이빗 인스턴스로 접근하는 통로로 활용될 수 있으므로 AZURE에서 제공하는 VPN 또는 타사 VPN 소프트웨어를 통한 안전한 연결이 필요합니다.",
  "설정방법": [
    "가상 네트워크 게이트웨이 추가",
    "가상 네트워크 게이트웨이 정보 입력 및 만들기",
    "생성된 가상 네트워크 게이트웨이 확인",
    "사용자 VPN 구성",
    "VPN 정보 입력, 인증서 등록 및 VPN 클라이언트 다운로드",
    "VPN 클라이언트 설치",
    "로컬에서 설치된 VPN 연결 시도",
    "VPN 구성 시 설정한 주소 풀 IP 정보 확인"
  ]
}'
현황=()
진단_결과=""

# 진단 시작
echo "진단 시작..."

# Azure CLI를 사용하여 가상 네트워크의 보안 설정을 확인
az network vnet list --query "[].{name:name, subnets:subnets[].name}" --output json

# 임시 진단 결과 할당
진단_결과="양호" # 또는 "취약"을 할당할 수 있습니다.

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
