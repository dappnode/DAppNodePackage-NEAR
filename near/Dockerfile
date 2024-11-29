ARG UPSTREAM_VERSION

FROM nearprotocol/nearcore:${UPSTREAM_VERSION}

RUN apt-get update && DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true apt-get install -y nginx supervisor wget awscli

COPY entrypoint.sh /usr/local/bin/

EXPOSE 3030 25467

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
