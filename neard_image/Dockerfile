ARG UPSTREAM_VERSION
# ======================== BUILD UIAPI ==================================
FROM node:16.0.0-alpine as build-ui

COPY staking-ui /app/ui
WORKDIR /app/ui
RUN yarn && yarn build

COPY staking-api /app/api
WORKDIR /app/api
RUN yarn add express cors shelljs

# ======================== BUILD NEAR ==================================
FROM nearprotocol/nearcore:${UPSTREAM_VERSION}

RUN apt-get update && DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true apt-get install -y nginx supervisor curl unzip jq
RUN curl https://rclone.org/install.sh | bash

COPY start_near.sh /usr/local/bin/
# COPY start_api.sh /usr/local/bin/
# COPY nginx.conf /etc/nginx/
COPY supervisord.conf /etc/supervisord/
# COPY --from=build-ui /app/ui/build /usr/share/nginx/html
# COPY --from=build-ui /app/api /srv/api

EXPOSE 80

ENTRYPOINT ["supervisord", "-c", "/etc/supervisord/supervisord.conf"]
