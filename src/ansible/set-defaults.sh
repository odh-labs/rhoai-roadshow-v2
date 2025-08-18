#!/usr/bin/env bash

ENV_FILE="env.txt"

# Ensure env.txt exists
if [[ ! -f "$ENV_FILE" ]]; then
    echo "Error: $ENV_FILE not found!"
    exit 1
fi

# Function to prompt with defaults
prompt_update() {
    local key="$1"
    local current_value="$2"
    local new_value

    # Prompt user with current value as default
    read -r -p "Enter value for $key [$current_value]: " new_value
    if [[ -z "$new_value" ]]; then
        new_value="$current_value"
    fi

    # Escape slashes and ampersands for sed
    local escaped_value
    escaped_value=$(printf '%s\n' "$new_value" | sed -e 's/[\/&]/\\&/g')

    # Replace the line in the env file
    sed -i "s|^export $key=.*|export $key=$escaped_value|" "$ENV_FILE"

    # Return the new value
    echo "$new_value"
}

# Read current values from env.txt
AWS_PROFILE=$(grep '^export AWS_PROFILE=' "$ENV_FILE" | cut -d'=' -f2-)
AWS_DEFAULT_REGION=$(grep '^export AWS_DEFAULT_REGION=' "$ENV_FILE" | cut -d'=' -f2-)
AWS_DEFAULT_ZONES=$(grep '^export AWS_DEFAULT_ZONES=' "$ENV_FILE" | cut -d'=' -f2-)
AWS_ACCESS_KEY_ID=$(grep '^export AWS_ACCESS_KEY_ID=' "$ENV_FILE" | cut -d'=' -f2-)
AWS_SECRET_ACCESS_KEY=$(grep '^export AWS_SECRET_ACCESS_KEY=' "$ENV_FILE" | cut -d'=' -f2-)
CLUSTER_NAME=$(grep '^export CLUSTER_NAME=' "$ENV_FILE" | cut -d'=' -f2-)
BASE_DOMAIN=$(grep '^export BASE_DOMAIN=' "$ENV_FILE" | cut -d'=' -f2-)
PULL_SECRET=$(grep '^export PULL_SECRET=' "$ENV_FILE" | cut -d'=' -f2-)
SSH_KEY=$(grep '^export SSH_KEY=' "$ENV_FILE" | cut -d'=' -f2-)
OPENSHIFT_VERSION=$(grep '^export OPENSHIFT_VERSION=' "$ENV_FILE" | cut -d'=' -f2-)
ADMIN_PASSWORD=$(grep '^export ADMIN_PASSWORD=' "$ENV_FILE" | cut -d'=' -f2-)
EMAIL=$(grep '^export EMAIL=' "$ENV_FILE" | cut -d'=' -f2-)

# Prompt user for updates (capture new values back)
AWS_PROFILE=$(prompt_update "AWS_PROFILE" "$AWS_PROFILE")
AWS_DEFAULT_REGION=$(prompt_update "AWS_DEFAULT_REGION" "$AWS_DEFAULT_REGION")
AWS_DEFAULT_ZONES=$(prompt_update "AWS_DEFAULT_ZONES" "$AWS_DEFAULT_ZONES")
AWS_ACCESS_KEY_ID=$(prompt_update "AWS_ACCESS_KEY_ID" "$AWS_ACCESS_KEY_ID")
AWS_SECRET_ACCESS_KEY=$(prompt_update "AWS_SECRET_ACCESS_KEY" "$AWS_SECRET_ACCESS_KEY")
CLUSTER_NAME=$(prompt_update "CLUSTER_NAME" "$CLUSTER_NAME")
BASE_DOMAIN=$(prompt_update "BASE_DOMAIN" "$BASE_DOMAIN")
PULL_SECRET=$(prompt_update "PULL_SECRET" "$PULL_SECRET")
SSH_KEY=$(prompt_update "SSH_KEY" "$SSH_KEY")
OPENSHIFT_VERSION=$(prompt_update "OPENSHIFT_VERSION" "$OPENSHIFT_VERSION")
ADMIN_PASSWORD=$(prompt_update "ADMIN_PASSWORD" "$ADMIN_PASSWORD")
EMAIL=$(prompt_update "EMAIL" "$EMAIL")

echo "✅ env.txt updated successfully."

# --- Sync to AWS CLI profile ---
if command -v aws >/dev/null 2>&1; then
    aws configure set aws_access_key_id     "$AWS_ACCESS_KEY_ID"     --profile "$AWS_PROFILE"
    aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY" --profile "$AWS_PROFILE"
    aws configure set region                "$AWS_DEFAULT_REGION"    --profile "$AWS_PROFILE"
    echo "✅ AWS CLI profile \"$AWS_PROFILE\" updated (region: $AWS_DEFAULT_REGION)."
else
    echo "⚠️  AWS CLI not found. Skipped updating AWS profile."
fi

