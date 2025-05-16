# Shell

This image installs ZSH

## Dotfiles

This image has Chezmoi, as well as any binaries [Roxedus/dotfiles](https://github.com/Roxedus/dotfiles) would usually place in `~/.local/bin`.

This is a minimal, recommended chezmoi config to prevent Chezmoi to manage these binaries.

```yml title=".config/chezmoi/chezmoi.yml"
data:
  integration:
    bitwarden:
      enabled: false
    eza:
      managed: false
    hishtory:
      managed: false
    oh_my_posh:
      managed: false
```
