# AGENTS.md

Guidance for coding agents working in this Homebrew tap.

## Repository purpose

This repository is a personal Homebrew tap. Formulae live in `Formula/*.rb` and should install command-line tools from upstream projects.

## Conventions

- Keep formula class names in Homebrew style, e.g. `Formula/dtools.rb` defines `class Dtools < Formula`.
- Use fully qualified formula names in docs and commands, e.g. `drusellers/tap/dtools`, because Homebrew/core also has a `dtools` formula for the D programming language.
- Prefer tagged release archives with fixed `sha256` values for stable installs.
- Include a `head` stanza for personal tools when useful for pre-release testing.
- Do not invent checksums, versions, or licenses. If an upstream release does not exist yet, keep the formula HEAD-only and document the release follow-up.
- Formula tests should exercise the installed executable without mutating the developer machine.
- Avoid committing generated bottles, caches, or temporary release tarballs.

## Validation commands

Run these after changing a formula when Homebrew is available:

```sh
ruby -c Formula/<name>.rb
brew tap drusellers/tap "$(pwd)" # only needed if this checkout is not already tapped
brew audit --strict --formula drusellers/tap/<name>
brew test drusellers/tap/<name>
```

For local HEAD testing:

```sh
brew install --HEAD drusellers/tap/<name>
brew uninstall <name>
```

## `dtools` release checklist

`dtools` is released from <https://github.com/drusellers/dtools>. The formula installs `dnet` and `dask` and keeps a `head` stanza for pre-release testing. `dask` uses the declared Homebrew Node dependency through an installed wrapper. Keep `libexec/dask` and its browser assets together; tests must use `--no-open` and a bounded timeout.

When a new release is available, prefer running the manual **Update dtools formula** GitHub Actions workflow. It resolves the latest release, verifies the release checksum, updates `Formula/dtools.rb`, validates the formula, and opens a pull request.

For a manual update:

1. Confirm the upstream tag name, executable layout, and license.
2. Download the release archive and compute its checksum:

   ```sh
   TAG=v2026.10.08.192947-1a713b0
   curl -L -o /tmp/dtools-${TAG}.tar.gz \
     "https://github.com/drusellers/dtools/releases/download/${TAG}/dtools-${TAG}.tar.gz"
   shasum -a 256 /tmp/dtools-${TAG}.tar.gz
   ```

3. Update the stable `url`, `version`, and `sha256` stanzas in `Formula/dtools.rb`; add `license` only after confirming it upstream.
4. Update the `install` method if the upstream archive layout changes from `bin/` + `libexec/`.
5. Keep formula tests safe and non-mutating; `dnet --version`, `dask --help`, and `dask ask ... --no-open --timeout 1` are safe. Never open a browser or toggle networking in tests.
6. Run the validation commands above.
