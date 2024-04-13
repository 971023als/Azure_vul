#!/bin/bash

{
  "분류": "계정 관리",
  "코드": "1.9",
  "위험도": "중요도 중",
  "진단_항목": "Azure 패스워드 정책 관리",
  "대응방안": {
    "설명": "Azure AD에서 제공하는 인증방법을 통해 인증 정책을 설정하거나, 암호보호 정책을 설정할 수 있습니다. 이 정책들은 전체 또는 일부 사용자에게 암호가 아닌 다른 방식의 인증을 사용하도록 설정하며, 조직의 암호 정책을 강화할 수 있습니다.",
    "설정방법": [
      "Azure Active Directory 메뉴 내 보안 기능 선택",
      "인증 방법 메뉴 선택",
      "인증 정책 중 Microsoft Authenticator 설정 활성화",
      "암호 보호 메뉴 내 사용자 지정 스마트 잠금 설정"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Log in to Azure
az login --output none

# Fetch the current password protection policy settings
echo "Fetching current password protection policy settings..."
password_policy_settings=$(az ad sp list --query "[].{name:displayName, lockoutThreshold:lockoutThreshold, lockoutDurationInSeconds:lockoutDurationInSeconds, customBannedPasswords:customBannedPasswords}" --output json)

if [ $? -ne 0 ]; then
    echo "Failed to retrieve password protection policy settings."
    exit 1
fi

echo "Current Password Protection Policy Settings:"
echo "$password_policy_settings"

# Extract necessary fields to check compliance
lockout_threshold=$(echo "$password_policy_settings" | jq '.[].lockoutThreshold')
lockout_duration=$(echo "$password_policy_settings" | jq '.[].lockoutDurationInSeconds')

# Example condition to check
if [[ "$lockout_threshold" -le 5 && "$lockout_duration" -ge 3600 ]]; then
    echo "Password protection settings are compliant with the policy."
else
    echo "Password protection settings are not compliant. Adjusting settings..."
    # Command to adjust settings; this is pseudo-code
    az ad sp update --set lockoutThreshold=5 lockoutDurationInSeconds=3600
    if [ $? -eq 0 ]; then
        echo "Password protection settings have been successfully updated."
    else
        echo "Failed to update password protection settings."
    fi
fi
