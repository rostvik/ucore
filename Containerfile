FROM scratch AS ctx
COPY build_files /

FROM ghcr.io/ublue-os/ucore-hci:stable-zfs-20250510@sha256:f7251b717c69d93ec7a99c65544e30a01dc38c3f1c0fca3d71173172a33d1f78

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh && \
    ostree container commit

# RUN bootc container lint
