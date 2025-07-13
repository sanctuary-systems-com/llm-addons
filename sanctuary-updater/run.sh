#!/usr/bin/with-contenv bashio

OS_VERSION="$(bashio::os.version)"
ADDON_VERSION="$(bashio::addon.version)"
OTA_URL="http://pkg.sanctuary-systems.com/hassos/haos_rpi5-64-${ADDON_VERSION}.raucb"

verlte() {
    printf '%s\n' "$1" "$2" | sort -c -V
}

echo "URL: ${OTA_URL}"
echo "OS version: ${OS_VERSION}"
echo "Addon version: ${ADDON_VERSION}"
if bashio::config.has_value 'force'; then
    echo "Force update: $(bashio::config 'force')"
fi

if bashio::config.true 'force' || ! verlte "${ADDON_VERSION}" "${OS_VERSION}"; then
    if bashio::config.true 'force'; then
        echo "Forcing update as requested."
    else
        echo "Addon version (${ADDON_VERSION}) is newer than OS version (${OS_VERSION})."
    fi
    curl -L -o /share/update.raucb "$OTA_URL"
    busctl call de.pengutronix.rauc / de.pengutronix.rauc.Installer InstallBundle sa{sv} "/mnt/data/supervisor/share/update.raucb" 0
    while true; do
        busctl get-property de.pengutronix.rauc / de.pengutronix.rauc.Installer Progress
        OPERATION=$(busctl get-property de.pengutronix.rauc / de.pengutronix.rauc.Installer Operation | awk '{print $2}' | tr -d '"')
        ERROR=$(busctl get-property de.pengutronix.rauc / de.pengutronix.rauc.Installer LastError | awk '{print $2}' | tr -d '"')

        if [ "$OPERATION" = "idle" ]; then
            if [ -n "$ERROR" ]; then
                echo "Error during installation: $ERROR"
                exit 1
            fi
            break
        fi
        sleep 1
    done
    rm /share/update.raucb
    bashio::host.reboot
else
    echo "Addon version (${ADDON_VERSION}) is not newer than OS version (${OS_VERSION}). No update needed."
fi
