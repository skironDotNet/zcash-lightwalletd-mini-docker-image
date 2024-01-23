FROM ubuntu:20.04 AS base

RUN apt update && apt install -y ca-certificates 

# build in separate temporary container
FROM base AS build

ARG GIT_TAG
WORKDIR /
# install needed tools
RUN apt-get install -y wget git make jq curl binutils

#download and install GO
RUN wget https://go.dev/dl/go1.20.6.linux-amd64.tar.gz
RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go1.20.6.linux-amd64.tar.gz
ENV PATH="${PATH}:/usr/local/go/bin"

RUN git clone --progress https://github.com/zcash/lightwalletd.git

# checkout previously discovered latest tag and use that source code
WORKDIR /lightwalletd
RUN git checkout -b buildtag $GIT_TAG && make

#minimize binary size by removing debug info
RUN strip lightwalletd

# build final minimal docker image
FROM base AS final

RUN apt clean command

ARG LWD_USER=lightwalletd
ARG LWD_UID=2002

RUN mkdir -p /var/lib/lightwalletd/db && chown $LWD_UID:$LWD_UID /var/lib/lightwalletd/db

RUN useradd --home-dir /srv/$LWD_USER \
            --shell /bin/bash \
            --create-home \
            --uid $LWD_UID\
            $LWD_USER
USER $LWD_USER

WORKDIR /srv/$LWD_USER
COPY --from=build /lightwalletd/lightwalletd /usr/local/bin/

ENTRYPOINT ["lightwalletd"]
CMD ["--help"]
