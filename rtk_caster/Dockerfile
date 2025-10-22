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
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    avahi-utils \
    avahi-daemon \
    uuid \
    ntpdate \
    curl \
    wget \
    tar \
    build-essential \
    git \
    patch \
    python3-pip \
    python3-venv \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Add s6-overlay
ARG BUILD_ARCH
ADD "https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz" /tmp/
ADD "https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-${BUILD_ARCH}.tar.xz" /tmp/
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz && \
    tar -C / -Jxpf /tmp/s6-overlay-${BUILD_ARCH}.tar.xz

# Copy the application code
COPY ELT_RTKBase /${RTKBASE_PATH}/ELT_RTKBase

# Set up the application
RUN adduser --gecos "RTKBase user" --disabled-password --home ${RTKBASE_PATH} --shell /usr/sbin/nologin ${RTKBASE_USER} && \
    mkdir -p ${RTKBASE_PATH} && \
    chown -R ${RTKBASE_USER}:${RTKBASE_USER} ${RTKBASE_PATH} && \
    cd /${RTKBASE_PATH}/ELT_RTKBase/Install && \
    ./install_script.sh -1 && \
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
