ARG UPSTREAM_VERSION
ARG CHAIN_ID
# ======================== BUILD UIAPI ==================================
FROM node:16.0.0-alpine as build-ui

ARG CONTRACT_NAME
ARG CONTRACT_HASH
ARG NODE_URL
ARG WALLET_URL
ENV REACT_APP_CONTRACT_NAME=${CONTRACT_NAME}
ENV REACT_APP_CONTRACT_HASH=${CONTRACT_HASH}
ENV REACT_APP_NODE_URL=${NODE_URL}
ENV REACT_APP_WALLET_URL=${WALLET_URL}
ENV REACT_APP_CHAIN_ID=${CHAIN_ID}

COPY staking-ui /app/ui
WORKDIR /app/ui
RUN yarn && yarn build

COPY staking-api /app/api
WORKDIR /app/api
RUN yarn add express cors shelljs

# ======================== BUILD NEAR ==================================
FROM nearprotocol/nearcore:${UPSTREAM_VERSION}

ENV CHAIN_ID=${CHAIN_ID}

RUN apt update && apt install -y axel wget nginx supervisor

COPY start_near.sh /usr/local/bin/
COPY start_api.sh /usr/local/bin/
COPY nginx.conf /etc/nginx/
COPY supervisord.conf /etc/supervisord/
COPY --from=build-ui /app/ui/build /usr/share/nginx/html
COPY --from=build-ui /app/api /srv/api

EXPOSE 80

ENTRYPOINT ["supervisord", "-c", "/etc/supervisord/supervisord.conf"]
