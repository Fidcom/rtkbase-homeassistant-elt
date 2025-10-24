ARG BUILD_FROM
FROM ${BUILD_FROM}

ARG BUILD_VERSION
ARG BUILD_ARCH

RUN apk add --no-cache curl xz \
    && S6_ARCH="${BUILD_ARCH}" \
    && if [ "${BUILD_ARCH}" = "amd64" ]; then S6_ARCH="x86_64"; fi \
    && if [ "${BUILD_ARCH}" = "armv7" ]; then S6_ARCH="armhf"; fi \
    && curl -L -s "https://github.com/just-containers/s6-overlay/releases/download/v3.1.2.1/s6-overlay-noarch.tar.xz" | tar -C / -Jxpf - \
    && curl -L -s "https://github.com/just-containers/s6-overlay/releases/download/v3.1.2.1/s6-overlay-${S6_ARCH}.tar.xz" | tar -C / -Jxpf -

HEALTHCHECK CMD s6-overlay-suexec -g nobody -f nobody /command/s6-healthcheck -c /etc/s6-overlay/s6-rc.d -t 30000

RUN apk add --no-cache \
    git \
    build-base \
    py3-pip \
    python3-dev \
    py3-setuptools \
    py3-wheel \
    py3-serial \
    eudev-dev \
    bc \
    dos2unix \
    socat \
    zip \
    unzip \
    pkgconf \
    psmisc \
    proj \
    nftables \
    libxml2-dev \
    libxslt-dev \
    chrony \
    gpsd \
    avahi-tools \
    avahi \
    openntpd \
    wget

RUN git clone https://github.com/GNSSOEM/ELT_RTKBase.git /usr/local/rtkbase/rtkbase \
    && python3 -m venv /usr/local/rtkbase/venv \
    && /usr/local/rtkbase/venv/bin/pip install --upgrade pip setuptools wheel \
    && /usr/local/rtkbase/venv/bin/pip install -r /usr/local/rtkbase/rtkbase/web_app/requirements.txt

COPY settings.conf.default /usr/local/rtkbase/rtkbase/settings.conf

RUN wget -qO - https://github.com/rtklibexplorer/RTKLIB/archive/refs/tags/b34j.tar.gz | tar -xvz \
    && make --directory=RTKLIB-b34j/app/consapp/str2str/gcc \
    && make --directory=RTKLIB-b34j/app/consapp/str2str/gcc install \
    && make --directory=RTKLIB-b34j/app/consapp/rtkrcv/gcc \
    && make --directory=RTKLIB-b34j/app/consapp/rtkrcv/gcc install \
    && make --directory=RTKLIB-b34j/app/consapp/convbin/gcc \
    && make --directory=RTKLIB-b34j/app/consapp/convbin/gcc install \
    && rm -rf RTKLIB-b34j

COPY run.sh /
COPY s6-rc.d /etc/s6-rc.d

RUN chmod +x /run.sh \
    && chmod -R +x /etc/s6-rc.d

ENTRYPOINT [ "/init" ]
