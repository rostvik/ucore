FROM scratch AS ctx
COPY build_files /

FROM ghcr.io/ublue-os/ucore-hci:stable-zfs-20250510@sha256:f7251b717c69d93ec7a99c65544e30a01dc38c3f1c0fca3d71173172a33d1f78

COPY --from=ghcr.io/moghtech/komodo-binaries:1.17.5-x86_64@sha256:bdb0b7f20de878e9a8d256e85c6a193a89ff1826452cf88590cc3b2cd3bd5d34 /periphery /usr/bin/periphery

COPY --from=ghcr.io/homebrew/core/chezmoi:2.62.4@sha256:5fb260b65b77f69956a0a85e5be44558c8c1b87b05fd4e3197bfc7fc9033ad12 /chezmoi/*/bin/* /usr/bin
COPY --from=ghcr.io/homebrew/core/chezmoi:2.62.4@sha256:5fb260b65b77f69956a0a85e5be44558c8c1b87b05fd4e3197bfc7fc9033ad12 /chezmoi/*/etc/* /etc
COPY --from=ghcr.io/homebrew/core/chezmoi:2.62.4@sha256:5fb260b65b77f69956a0a85e5be44558c8c1b87b05fd4e3197bfc7fc9033ad12 /chezmoi/*/share/* /usr/local/share/

COPY system_files /

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh && \
    ostree container commit

# RUN bootc container lint
