# syntax=docker/dockerfile-upstream:experimental

FROM phusion/baseimage:jammy-1.0.1 as build

ARG NODE_URL
ENV NEAR_WALLET_ENV=mainnet
ENV REACT_APP_NODE_URL=${NODE_URL}

RUN curl -o /tmp/node_setup.sh "https://deb.nodesource.com/setup_16.x"
RUN bash /tmp/node_setup.sh
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo 'deb https://dl.yarnpkg.com/debian/ stable main' | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y \
    nodejs \
    git
RUN npm install -g yarn

# near-wallet
WORKDIR /near-wallet
RUN git clone --branch master https://github.com/near/near-wallet.git .
RUN yarn install
RUN NEAR_WALLET_ENV=mainnet REACT_APP_NODE_URL=${NODE_URL} yarn run build

# ======================== EXECUTE ==================================
FROM nginx:1.22.0-alpine
COPY --from=build /near-wallet/packages/frontend/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
# CMD ["nginx", "-c", "/etc/nginx/nginx.conf", "-g", "daemon off;"]
CMD ["nginx", "-g", "daemon off;"]
