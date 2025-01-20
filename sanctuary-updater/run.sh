#!/usr/bin/with-contenv bashio

OTA_URL="$(bashio::config 'ota_url')"
OS_VERSION="$(bashio::os.version)"
ADDON_VERSION="$(bashio::addon.version)"

verlte() {
    printf '%s\n' "$1" "$2" | sort -c -V
}

echo "URL" $OTA_URL
echo "OS" $OS_VERSION
echo "ADDON" $ADDON_VERSION

if ! verlte "${ADDON_VERSION}" "${OS_VERSION}"; then
    echo "Addon version (${ADDON_VERSION}) > OS version (${OS_VERSION})"
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
else
    echo "Addon version (${ADDON_VERSION}) <= OS version (${OS_VERSION})"
fi
