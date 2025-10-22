# Use the official Home Assistant base image
ARG BUILD_FROM
FROM $BUILD_FROM

# Set up environment variables
ENV LANG=C.UTF-8
ENV RTKBASE_USER=rtkbase
ENV RTKBASE_PATH=/usr/local/${RTKBASE_USER}
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2
ARG S6_OVERLAY_VERSION=v3.1.6.0

# Install dependencies
RUN apk add --no-cache \
    avahi-tools \
    avahi \
    util-linux \
    openntpd \
    curl \
    wget \
    tar \
    build-base \
    git \
    patch \
    python3 \
    py3-pip \
    xz

# Add s6-overlay
ARG BUILD_ARCH
RUN \
    s6_arch=$(case "${BUILD_ARCH}" in \
        "aarch64") echo "aarch64";; \
        "amd64") echo "x86_64";; \
        "armv7") echo "armhf";; \
        *) echo "unsupported_arch";; \
    esac) && \
    wget -O /tmp/s6-overlay-noarch.tar.xz "https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz" && \
    wget -O /tmp/s6-overlay.tar.xz "https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-${s6_arch}.tar.xz" && \
    tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz && \
    tar -C / -Jxpf /tmp/s6-overlay.tar.xz

# Copy the application code
COPY ELT_RTKBase /${RTKBASE_PATH}/rtkbase

# Set up the application
RUN adduser -D -h ${RTKBASE_PATH} -s /sbin/nologin ${RTKBASE_USER} && \
    mkdir -p ${RTKBASE_PATH} && \
    chown -R ${RTKBASE_USER}:${RTKBASE_USER} ${RTKBASE_PATH} && \
    cd /${RTKBASE_PATH}/rtkbase/Install && \
    sed -i 's/python3 -m venv/python3 -m venv --without-pip/' /${RTKBASE_PATH}/rtkbase/scripts/install.sh && \
    sh ./install_script.sh -1 && \
    python3 -m venv /${RTKBASE_PATH}/venv && \
    /${RTKBASE_PATH}/venv/bin/pip install -r /${RTKBASE_PATH}/rtkbase/web_app/requirements.txt && \
    # Clean up
    rm -rf /tmp/*

# Copy the rootfs
COPY rootfs /

# Set permissions
RUN chmod +x /etc/cont-init.d/01-config && \
    chmod +x /etc/services.d/rtkbase/run && \
    chmod +x /etc/services.d/rtkbase/finish && \
    chmod +x /etc/services.d/rtkbase/log/run && \
    chmod +x /etc/services.d/ntrip_caster/run && \
    chmod +x /etc/services.d/ntrip_caster/finish && \
    chmod +x /etc/services.d/ntrip_caster/log/run

# Set the entrypoint
ENTRYPOINT ["/init"]
