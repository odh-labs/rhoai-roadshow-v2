#!/usr/bin/env bash

ENV_FILE="env.txt"

# Create env.txt if missing, with required defaults
if [[ ! -f "$ENV_FILE" ]]; then
    cat > "$ENV_FILE" <<'EOF'
export AWS_PROFILE=sno-test
export AWS_DEFAULT_REGION=us-east-2
export AWS_DEFAULT_ZONES=["us-east-2a"]
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
export CLUSTER_NAME=sno
export BASE_DOMAIN=sandbox3000.opentlc.com
export PULL_SECRET=~/tmp/pull-secret
export SSH_KEY=$(cat ~/.ssh/id_rsa.pub)
export OPENSHIFT_VERSION=4.19.11
export ADMIN_PASSWORD=your-password
export EMAIL=your@email.com

# Defaults (not prompted)
export INSTANCE_TYPE=g6.8xlarge   # 24GB L4 Nvidia, 32 vCPUs, 128 GiB of memory and 25 Gibps of bandwidth ~$2 per hour
export ROOT_VOLUME_SIZE=400       # can be anything, but leave as is unless you need to change it
export ANSIBLE_VAULT_SECRET=<ansible-vault-secret>   # change this to the ansible secret for vault-sno
EOF
    echo "✅ Created $ENV_FILE with default values."
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
ANSIBLE_VAULT_SECRET=$(grep '^export ANSIBLE_VAULT_SECRET=' "$ENV_FILE" | cut -d'=' -f2-)

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
ANSIBLE_VAULT_SECRET=$(prompt_update "ANSIBLE_VAULT_SECRET" "$ANSIBLE_VAULT_SECRET")

echo "✅ env.txt updated successfully."

# Must look like ["zone1","zone2",...]
if [[ ! "$AWS_DEFAULT_ZONES" =~ ^\[[[:space:]]*\"[^\"[:cntrl:]]+\"([[:space:]]*,[[:space:]]*\"[^\"[:cntrl:]]+\")*[[:space:]]*\]$ ]]; then
    echo "❌ AWS_DEFAULT is not properly formatted: $AWS_DEFAULT_ZONES"
    echo "   Please ensure the format is a json array. E.g. [\"us-east-2a\"] in $ENV_FILE."
    exit 1
else
    echo "✅ AWS_DEFAULT_ZONES is correctly formatted: $AWS_DEFAULT_ZONES"
fi

# --- Validate Pull Secret ---
PULL_SECRET_EXPANDED=$(eval echo "$PULL_SECRET")
if [[ ! -f "$PULL_SECRET_EXPANDED" ]]; then
    echo "❌ Pull secret not found at: $PULL_SECRET_EXPANDED"
    echo "   Please ensure the path is correct in $ENV_FILE."
    exit 1
else
    echo "✅ Pull secret exists at: $PULL_SECRET_EXPANDED"
fi

# --- Sync to AWS CLI profile ---
if command -v aws >/dev/null 2>&1; then
    aws configure set aws_access_key_id     "$AWS_ACCESS_KEY_ID"     --profile "$AWS_PROFILE"
    aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY" --profile "$AWS_PROFILE"
    aws configure set region                "$AWS_DEFAULT_REGION"    --profile "$AWS_PROFILE"
    aws configure set output                "json"                   --profile "$AWS_PROFILE"

    echo "✅ AWS CLI profile \"$AWS_PROFILE\" updated (region: $AWS_DEFAULT_REGION)."
else
    echo "⚠️  AWS CLI not found. Skipped updating AWS profile."
fi

