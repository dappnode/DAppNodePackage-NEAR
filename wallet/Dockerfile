# syntax=docker/dockerfile-upstream:experimental

FROM phusion/baseimage:jammy-1.0.1 as build

ARG NODE_URL
ENV NEAR_WALLET_ENV=mainnet
ENV REACT_APP_NODE_URL=${NODE_URL}
ENV NODE_MAJOR=16
## Test new install method for NodeJS from nodesource
#RUN apt-get update
#RUN apt-get install -y ca-certificates curl gnupg
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
 
##
RUN curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor -o /etc/apt/keyrings/yarn/pubkey.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/yarn/pubkey.gpg] https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

#RUN curl -o /tmp/node_setup.sh "https://deb.nodesource.com/setup_16.x"
#RUN bash /tmp/node_setup.sh

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
