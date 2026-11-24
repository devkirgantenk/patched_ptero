# syntax=docker/dockerfile:1
ARG BASE_IMAGE
FROM ${BASE_IMAGE}

LABEL org.opencontainers.image.title="patched_ptero" \
      org.opencontainers.image.description="Patched Java image for Pterodactyl Panel (CVE-2026-114938 / Java4Shell mitigation)" \
      org.opencontainers.image.source="https://github.com/devkirgantenk/patched_ptero" \
      org.opencontainers.image.licenses="MIT"

# Base images (notably mcr.microsoft.com/openjdk/jdk:*) run as root and do not
# ship a dedicated user, so make sure the non-root 'container' user (UID 1000)
# exists. Skip creation if the base image already provides it.
RUN if ! getent passwd container >/dev/null 2>&1; then \
        useradd --uid 1000 --user-group --create-home --shell /bin/bash container; \
    fi

ENV USER=container \
    HOME=/home/container

WORKDIR /home/container

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && \
    chown container:container /home/container

USER container

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
