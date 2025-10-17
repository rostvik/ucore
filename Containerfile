FROM scratch AS ctx
COPY build_files /

FROM ghcr.io/moghtech/komodo-binaries:1.17.5-x86_64@sha256:bdb0b7f20de878e9a8d256e85c6a193a89ff1826452cf88590cc3b2cd3bd5d34 AS komodo

FROM ghcr.io/homebrew/core/chezmoi:2.62.4@sha256:5fb260b65b77f69956a0a85e5be44558c8c1b87b05fd4e3197bfc7fc9033ad12 AS chezmoi
FROM ghcr.io/homebrew/core/eza:0.21.3@sha256:8cc9e4eadb3a66c8b6e1eb1103d4af809001080c5d877d1ea0e7149b824dc437 AS eza
FROM ghcr.io/homebrew/core/fzf:0.62.0@sha256:cbda5425eb8c4e19eaa82f64f82264fae2d078f4ebe24eecdccbc78e449d6757 AS fzf
FROM ghcr.io/homebrew/core/hishtory:0.335@sha256:0d727ca130f82f59a9a014024dee75bc5ef64f315f2692604ba68952491c9194 AS hishtory
FROM ghcr.io/homebrew/core/oh-my-posh:25.23.0@sha256:70c09a6543a10d48404843e7d3d80473dd46e62e4a899cca24a4b2cffa92c52e AS omp


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
