FROM launcher.gcr.io/google/debian9
LABEL maintainer="Thanatat Tamtan <acoshift@gmail.com>"

ENV GOLANG_VERSION 1.11
ENV NODE_VERSION v8.11.4

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y -q \
        curl \
        wget \
        git \
        python \
        python2.7 \
        python-dev \
        python-setuptools \
        # python-software-properties \
        software-properties-common \
        build-essential \
        ca-certificates \
        libkrb5-dev \
        imagemagick \
        apt-transport-https \
        mercurial \
        subversion \
        gnupg

RUN mkdir -p /usr/local/go /usr/local/node /usr/local/gcloud

RUN curl -sSL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz | tar zvxf - -C /usr/local/go --strip-components=1
RUN curl -sSL https://nodejs.org/dist/$NODE_VERSION/node-$NODE_VERSION-linux-x64.tar.gz | tar xvzf - -C /usr/local/node --strip-components=1
RUN curl -sSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y yarn
RUN curl -sSL https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz | tar zxv -C /usr/local/gcloud --strip-components=1 && \
    CLOUDSDK_PYTHON="python2.7" /usr/local/gcloud/install.sh \
        --usage-reporting=false \
        --bash-completion=false \
        --disable-installation-options \
        && \
    /usr/local/gcloud/bin/gcloud -q components install \
        alpha \
        beta \
        app-engine-go \
        container-builder-local \
        docker-credential-gcr \
        kubectl \
        && \
    /usr/local/gcloud/bin/gcloud -q components update && \
    /usr/local/gcloud/bin/gcloud components list && \
    # easy_install -U pip && \
    # pip install -U crcmod && \
    rm -rf ~/.config/gcloud

RUN apt-get clean && \
    rm /var/lib/apt/lists/*_*

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:/usr/local/node/bin:/usr/local/gcloud/bin:$PATH

RUN go version
RUN node --version

ENTRYPOINT ["make"]
