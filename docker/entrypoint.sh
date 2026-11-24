#!/bin/bash

# Standard Pterodactyl entrypoint.
# https://github.com/devkirgantenk/patched_ptero

cd /home/container || exit 1

# Print the Java version running inside this container.
java -version 2>&1 | head -1 | awk -F '"' '/version/ {print "JAVA_VERSION: "$2}'

# Make the internal Docker IP available to the server process.
if command -v ip >/dev/null 2>&1; then
    INTERNAL_IP="$(ip route get 1 | awk '{print $NF; exit}')"
else
    # Fallback for base images without iproute2.
    INTERNAL_IP="$(hostname -i | awk '{print $1}')"
fi
export INTERNAL_IP

# Convert every "{{VARIABLE}}" placeholder in the STARTUP command into
# proper shell parameter expansion, then execute it.
MODIFIED_STARTUP="$(echo "${STARTUP}" | sed -re 's/\{\{([A-Za-z0-9_]+)\}\}/\$\{\1\}/g')"

printf "\ncontainer@pterodactyl~ %s\n\n" "${MODIFIED_STARTUP}"

# shellcheck disable=SC2086
eval "${MODIFIED_STARTUP}"
