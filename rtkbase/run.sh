#!/command/with-contenv bashio

SETTINGS_FILE="/usr/local/rtkbase/rtkbase/settings.conf"

# Read configuration from Home Assistant options
GNSS_TCP_HOST=$(bashio::config 'gnss_tcp_host')
GNSS_TCP_PORT=$(bashio::config 'gnss_tcp_port')
CASTER_MOUNTPOINT=$(bashio::config 'caster_mountpoint')
CASTER_USER=$(bashio::config 'caster_user')
CASTER_PASSWORD=$(bashio::config 'caster_password')

# Update settings.conf with the provided configuration
sed -i "s/^tcp_client_host=.*/tcp_client_host='${GNSS_TCP_HOST}'/" "${SETTINGS_FILE}"
sed -i "s/^tcp_client_port=.*/tcp_client_port='${GNSS_TCP_PORT}'/" "${SETTINGS_FILE}"
sed -i "s/^local_ntripc_mnt_name=.*/local_ntripc_mnt_name='${CASTER_MOUNTPOINT}'/" "${SETTINGS_FILE}"
sed -i "s/^local_ntripc_user=.*/local_ntripc_user='${CASTER_USER}'/" "${SETTINGS_FILE}"
sed -i "s/^local_ntripc_pwd=.*/local_ntripc_pwd='${CASTER_PASSWORD}'/" "${SETTINGS_FILE}"

# Start s6-overlay services
exec /init
