#!/bin/bash

export NEAR_HOME=/srv/near

FULL_ACCOUNT_ID="$ACCOUNT_ID.$STAKING_CONTRACT_NAME"
NEARD_FLAGS=${NEAR_HOME:+--home="$NEAR_HOME"}
mkdir -p $NEAR_HOME/data

if [ ! -f ${NEAR_HOME}/node_key.json ]; then
    echo "Initializing node, this can take a while..."
    cmd="neard $NEARD_FLAGS init --chain-id=${CHAIN_ID} ${FULL_ACCOUNT_ID:+--account-id=$FULL_ACCOUNT_ID} --download-genesis --download-config"
    $cmd
fi
if [ "$DOWNLOAD_SNAPSHOT" = "true" ] && [ ! -f "${NEAR_HOME}/data/CURRENT" ]; then
    curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/fastnear/static/refs/heads/main/down_rclone.sh \
         | THREADS=16 DATA_PATH="$NEAR_HOME/data" CHAIN_ID="$CHAIN_ID" RPC_TYPE="fast-rpc" bash
fi

if [ -n "$ACCOUNT_ID" ] && [ -n "$VALIDATOR_PUBLIC_KEY" ] && [ -n "$VALIDATOR_SECRET_KEY" ]
then
    echo "Configure custom validator_key.json"
    cat << EOF > "$NEAR_HOME/validator_key.json"
{"account_id": "$FULL_ACCOUNT_ID", "public_key": "$VALIDATOR_PUBLIC_KEY", "secret_key": "$VALIDATOR_SECRET_KEY"}
EOF
fi

ulimit -c unlimited

# Both environment variables are not necessary since both values are into config.json
echo "Telemetry: ${TELEMETRY_URL}"
echo "Bootnodes: ${BOOT_NODES}"

exec neard "$NEARD_FLAGS" run ${TELEMETRY_URL:+--telemetry-url="$TELEMETRY_URL"} ${BOOT_NODES:+--boot-nodes="$BOOT_NODES"} "$@"