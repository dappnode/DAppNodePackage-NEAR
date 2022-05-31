ARG UPSTREAM_VERSION

FROM nearprotocol/nearcore:${UPSTREAM_VERSION}

RUN apt update && apt install -y axel wget

COPY entrypoint.sh /usr/local/bin/

CMD ["entrypoint.sh"]