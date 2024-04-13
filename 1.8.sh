#!/bin/bash

{
  "분류": "계정 관리",
  "코드": "1.8",
  "위험도": "중요도 중",
  "진단_항목": "MFA 계정 잠금 정책 관리",
  "대응방안": {
    "설명": "Active Directory 사용자 계정 로그인 시 Multi-Factor-Authentication 인증에 대해 연속적으로 거부된 인증 시도가 많을 경우 계정을 일시적으로 잠글 수 있도록 정책을 적용할 수 있습니다. 이는 1차 계정 인증을 통과하더라도 2차 인증을 연속으로 접근하게 될 경우를 차단하는 정책으로 계정 로그인의 보안을 강화할 수 있습니다.",
    "설정방법": [
      "Azure Active Directory 메뉴 내 보안 기능 선택",
      "다단계 인증 메뉴 선택",
      "계정 잠금 메뉴 내 값 설정 및 저장",
      "MS 계정 암호 사용기간 만기 시 자동 변경 설정 방법",
      "Microsoft 계정 메뉴 내 암호 보안 선택",
      "암호 변경 및 72일마다 암호변경 옵션 활성화 후 저장"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Log in to Azure
az login --output none

# Fetch the current MFA account lockout policy settings
echo "Fetching current MFA account lockout policy settings..."
mfa_lockout_settings=$(az rest --method get --uri "https://graph.microsoft.com/v1.0/policies/authenticationMethodsPolicy/authenticationMethodConfigurations" --query "{lockoutThreshold:lockoutThreshold, lockoutDurationInSeconds:lockoutDurationInSeconds, lockoutResetTimeInSeconds:lockoutResetTimeInSeconds}" --output json)

if [ $? -ne 0 ]; then
    echo "Failed to retrieve MFA lockout policy settings."
    exit 1
fi

echo "Current MFA Lockout Policy Settings:"
echo "$mfa_lockout_settings"

# Check compliance with predefined criteria
lockout_threshold=$(echo "$mfa_lockout_settings" | jq '.lockoutThreshold')
lockout_duration=$(echo "$mfa_lockout_settings" | jq '.lockoutDurationInSeconds')
lockout_reset=$(echo "$mfa_lockout_settings" | jq '.lockoutResetTimeInSeconds')

if [[ "$lockout_threshold" -eq 5 && "$lockout_duration" -eq 900 && "$lockout_reset" -eq 3600 ]]; then
    echo "MFA lockout settings are compliant with the policy."
    diagnosis_result="양호"
else
    echo "MFA lockout settings are not compliant with the policy."
    diagnosis_result="취약"
fi

# Update JSON diagnosis result dynamically
sed -i "s/\"진단_결과\": \"양호\"/\"진단_결과\": \"$diagnosis_result\"/" <path_to_json_file>
