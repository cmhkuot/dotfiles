# My personal dotfiles

<!-- ![screenshot](https://cmhkuot.github.io/dotfiles/screenshot.png) -->

My personal dotfiles.
It contains the installation of some basic tools, some handy aliases and functions.

You can install them by cloning the repository as `.dotfiles` in your home directory and running the bootstrap script.

```zsh
git clone git@github.com:cmhkuot/dotfiles.git .dotfiles && cd .dotfiles && ./bootstrap.sh
```

The bootstrap script can be run by cd-ing into the `.dotfiles` directory and performing this command:

```zsh
./bootstrap.sh
```

## Playwright CLI

The canonical Playwright CLI config lives at `config/playwright/cli.config.json` and `fresh.sh` symlinks it to `~/.playwright/cli.config.json` as the native global default.

It uses Helium at `/Applications/Helium.app/Contents/MacOS/Helium` in headless mode with an in-memory profile and a 1440x900 viewport, so a separate Playwright Chromium download is not required. Helium must be installed. Compatibility with custom Chromium browsers is not guaranteed by Playwright.

Use the CLI normally:

```zsh
playwright-cli open https://example.com
```

Project-level `.playwright/cli.config.json` overrides matching global settings, and changing either file only affects newly opened sessions, so close and reopen the target session after an update.

Logs and screenshots may contain sensitive page or session data. Review them before sharing or committing. This repo does not globally ignore `.playwright`, so project overrides can stay versioned.

---

## Thanks to

- [driesvints](https://github.com/driesvints) and his [dotfiles](https://github.com/driesvints/dotfiles)
- [freekmurze](https://github.com/freekmurze) and his [dotfiles](https://github.com/freekmurze/dotfiles)
