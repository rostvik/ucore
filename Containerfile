FROM scratch AS ctx
COPY build_files /

FROM ghcr.io/moghtech/komodo-binaries:1.19.5-x86_64@sha256:b2ee71bdf0fe51fc9d1195a4c88e2e1dafbe6bf3388c448d73e829191aecdd54 AS komodo

FROM ghcr.io/homebrew/core/chezmoi:2.62.4@sha256:5fb260b65b77f69956a0a85e5be44558c8c1b87b05fd4e3197bfc7fc9033ad12 AS chezmoi
FROM ghcr.io/homebrew/core/eza:0.23.4@sha256:5cfca0bef2c6218ca1901e8b7f85e316799e12ae29d37391de1708e52658f943 AS eza
FROM ghcr.io/homebrew/core/fzf:0.67.0@sha256:8f4784390b50c25b7450e0630d256e035085b08cf99fa4254b17eb822826873f AS fzf
FROM ghcr.io/homebrew/core/hishtory:0.335@sha256:a33766673e5b3eee8902ab6541736511bdffc5c05acdd060736d649c3c09243f AS hishtory
FROM ghcr.io/homebrew/core/oh-my-posh:28.10.0@sha256:55ede9732246d442b5cac0fb9c89583354117d192fad723ce83fd6c0fddf249c AS omp


FROM ghcr.io/ublue-os/ucore-hci:stable-20251017@sha256:db07025b630bfca55f4883111932aaf1ce8a33fe1c91f2e5fd4f083837d606a7

COPY --from=komodo /periphery /usr/bin/periphery

COPY --from=chezmoi /chezmoi/*/bin/* /usr/bin
COPY --from=chezmoi /chezmoi/*/etc/* /etc
COPY --from=chezmoi /chezmoi/*/share/* /usr/local/share/

COPY --from=eza /eza/*/bin/* /usr/bin
COPY --from=eza /eza/*/etc/* /etc
COPY --from=eza /eza/*/share/* /usr/local/share/

COPY --from=fzf /fzf/*/bin/* /usr/bin
COPY --from=fzf /fzf/*/share/* /usr/local/share/

COPY --from=hishtory /hishtory/*/bin/* /usr/bin
COPY --from=hishtory /hishtory/*/etc/* /etc
COPY --from=hishtory /hishtory/*/share/* /usr/local/share/

COPY --from=omp /oh-my-posh/*/bin/* /usr/bin


COPY system_files /

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh && \
    ostree container commit

RUN ["bootc", "container", "lint"]
