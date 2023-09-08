FROM ubuntu:20.04

RUN apt update && apt install -y ca-certificates && apt clean command

ADD output/lightwalletd /usr/local/bin/

RUN mkdir -p /var/lib/lightwalletd/db \
  && chown 2002:2002 /var/lib/lightwalletd/db

ARG LWD_USER=lightwalletd
ARG LWD_UID=2002

RUN useradd --home-dir /srv/$LWD_USER \
            --shell /bin/bash \
            --create-home \
            --uid $LWD_UID\
            $LWD_USER
USER $LWD_USER
WORKDIR /srv/$LWD_USER

ENTRYPOINT ["lightwalletd"]
CMD ["--help"]
