FROM debian:bookworm-slim

LABEL maintainer="mySociety <sysadmin@mysociety.org>"

RUN apt-get update -qq \
      && apt-get install -qq --no-install-recommends \
           git \
           openssh-client \
      && rm -fr /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
