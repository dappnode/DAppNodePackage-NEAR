#!/bin/bash

export NEAR_HOME=/srv/near
SNAPSHOT_URL="https://near-protocol-public.s3.ca-central-1.amazonaws.com/backups/$CHAIN_ID/rpc/data.tar"

NEARD_FLAGS=${NEAR_HOME:+--home="$NEAR_HOME"}
mkdir -p $NEAR_HOME/data

if [ ! -f ${NEAR_HOME}/node_key.json ]; then
    cmd="neard $NEARD_FLAGS init ${CHAIN_ID:+--chain-id=$CHAIN_ID} ${ACCOUNT_ID:+--account-id=$ACCOUNT_ID} --download-genesis --download-config"
    $cmd
fi
echo "Downloading a snapshot, this can take a while..."
if [ ! -f ${NEAR_HOME}/data/CURRENT ]; then
    axel $SNAPSHOT_URL -o ${NEAR_HOME}
    tar -xvf ${NEAR_HOME}/data.tar -C ${NEAR_HOME}/data
    rm ${NEAR_HOME}/data.tar
fi

if [ -n "$NODE_KEY" ]
then
    cat << EOF > "$NEAR_HOME/node_key.json"
{"account_id": "", "public_key": "", "secret_key": "$NODE_KEY"}
EOF
fi

ulimit -c unlimited

echo "Telemetry: ${TELEMETRY_URL}"
echo "Bootnodes: ${BOOT_NODES}"

exec neard "$NEARD_FLAGS" run ${TELEMETRY_URL:+--telemetry-url="$TELEMETRY_URL"} ${BOOT_NODES:+--boot-nodes="$BOOT_NODES"} "$@"