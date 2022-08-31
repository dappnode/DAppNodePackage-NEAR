# ======================== BUILD ==================================
FROM node:16.0.0-alpine as build-ui
ARG CONTRACT_NAME
ARG CONTRACT_HASH
ARG NODE_URL
ARG WALLET_URL
ARG CHAIN_ID
ENV REACT_APP_CONTRACT_NAME=${CONTRACT_NAME}
ENV REACT_APP_CONTRACT_HASH=${CONTRACT_HASH}
ENV REACT_APP_NODE_URL=${NODE_URL}
ENV REACT_APP_WALLET_URL=${WALLET_URL}
ENV REACT_APP_CHAIN_ID=${CHAIN_ID}
WORKDIR /app
COPY staking-pool-factory /app/ui
WORKDIR /app/ui
RUN yarn && yarn build

# ======================== EXECUTE ==================================
FROM nginx:1.22.0-alpine
COPY --from=build-ui /app/ui/build /usr/share/nginx/html

EXPOSE 80
# CMD ["nginx", "-c", "/etc/nginx/nginx.conf", "-g", "daemon off;"]
CMD ["nginx", "-g", "daemon off;"]
