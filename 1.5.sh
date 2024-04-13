#!/bin/bash

{
  "분류": "계정 관리",
  "코드": "1.5",
  "위험도": "중요도 하",
  "진단_항목": "AD 암호 재설정 규칙 관리",
  "대응방안": {
    "설명": "Azure AD(Active Directory) 셀프 서비스 암호 재설정(SSPR)은 사용자가 자신의 암호를 재설정할 수 있도록 웹 기반 및 Windows 통합 환경을 제공합니다. 사용자는 모든 디바이스에서 언제 어디서나 암호를 관리할 수 있습니다. 암호 재설정의 인증 방법에는 여러 유형이 있으며, 적절한 설정이 필수적입니다.",
    "설정방법": [
      "Azure Active Directory 메뉴 내 암호 재설정 기능 선택",
      "속성 메뉴 내 셀프 서비스 암호 재설정 설정",
      "인증 방법 메뉴 내 인증 방법 설정",
      "정보 변경 시 사용자 알람 기능 설정"
    ]
  },
  "현황": [],
  "진단_결과": "양호"  // '취약'으로 업데이트 가능
}


# Log in to Azure
az login --output none

# Check Azure AD password reset policy settings
echo "Checking Azure AD Self-Service Password Reset settings..."
sspr_settings=$(az ad sp list --filter "displayName eq 'Microsoft.Azure.ActiveDirectory'" --query '[].{id:appId}' --output tsv)
if [ -z "$sspr_settings" ]; then
    echo "Failed to retrieve SSPR settings."
    exit 1
fi

# Get the specific settings for SSPR
sspr_policy=$(az rest --method get --uri "https://graph.microsoft.com/beta/policies/authenticationMethodsPolicy/authenticationMethodConfigurations" --output json)

# Check for required conditions
registration=$(echo $sspr_policy | jq '.value[] | select(.id == "passwordReset") | .settings.registration')
notifications=$(echo $sspr_policy | jq '.value[] | select(.id == "passwordReset") | .settings.notifications')
methods=$(echo $sspr_policy | jq '.value[] | select(.id == "passwordReset") | .authenticationMethods')

if [[ "$registration" == "required" && "$notifications" == "enabled" && -n "$methods" ]]; then
    echo "SSPR policy settings are compliant."
    diagnosis_result="양호"
else
    echo "SSPR policy settings are not compliant."
    diagnosis_result="취약"
fi

# Update JSON diagnosis result dynamically
sed -i "s/\"진단_결과\": \"양호\"/\"진단_결과\": \"$diagnosis_result\"/" <path_to_json_file>
