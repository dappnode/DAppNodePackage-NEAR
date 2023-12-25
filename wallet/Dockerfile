# syntax=docker/dockerfile-upstream:experimental

FROM phusion/baseimage:jammy-1.0.1 as build

ARG NODE_URL

ENV NEAR_WALLET_ENV=mainnet
ENV REACT_APP_NODE_URL=${NODE_URL}
ENV NODE_MAJOR=16

## Removed deprecated Node install script replaced with current install instructions, and allows for Changing NodeJS Major Version between 16.x,18.x, 20.x, and 21.x by editing the above ENV variable NODE_MAJOR to the major version desired, 16, 18, 20, and 21.  Note: Versions 18.x and up are only available on Jammy and Focal based phusion/baseimage's; if reverting to Bionic 18.04 and earlier, Node version 16.x is the only compatible version. 
# Download and install NodeJS GPG keys
RUN mkdir -p /etc/apt/keyrings/yarn
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
 
## Upgrade Deprecated `apt-key` method of adding GPG keys
# Download and install Yarn Package GPG keys
RUN curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor -o /etc/apt/keyrings/yarn/pubkey.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/yarn/pubkey.gpg] https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Update with newly added sources for Yarn and NodeJS, install Git, Chosen NodeJS version and Yarn
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
FROM nginx:1.25.3-alpine
COPY --from=build /near-wallet/packages/frontend/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
# CMD ["nginx", "-c", "/etc/nginx/nginx.conf", "-g", "daemon off;"]
CMD ["nginx", "-g", "daemon off;"]
