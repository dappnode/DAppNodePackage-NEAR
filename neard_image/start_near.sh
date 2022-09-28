#!/bin/bash

export NEAR_HOME=/srv/near
SNAPSHOT_URL="https://near-protocol-public.s3.ca-central-1.amazonaws.com/backups/$CHAIN_ID/rpc/data.tar"
FULL_ACCOUNT_ID="$ACCOUNT_ID$CONTRACT_NAME"
NEARD_FLAGS=${NEAR_HOME:+--home="$NEAR_HOME"}
mkdir -p $NEAR_HOME/data

if [ ! -f ${NEAR_HOME}/node_key.json ]; then
    echo "Initializing node, this can take a while..."
    cmd="neard $NEARD_FLAGS init ${CHAIN_ID:+--chain-id=$CHAIN_ID} ${FULL_ACCOUNT_ID:+--account-id=$FULL_ACCOUNT_ID} --download-genesis --download-config"
    $cmd
fi
if [ ! -f ${NEAR_HOME}/data/CURRENT ]; then
    echo "Downloading a snapshot, this can take a while..."
    axel $SNAPSHOT_URL -o ${NEAR_HOME}
    tar -xvf ${NEAR_HOME}/data.tar -C ${NEAR_HOME}/data
    rm ${NEAR_HOME}/data.tar
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