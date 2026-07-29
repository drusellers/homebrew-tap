# drusellers Homebrew Tap

Personal Homebrew tap for tools and utilities.

## Install

```sh
brew tap drusellers/tap
```

Install `dtools`:

```sh
brew install dtools
```

The current release installs the `dnet` command:

```sh
dnet --help
```

To install from the latest upstream commit instead of the latest release:

```sh
brew install --HEAD drusellers/tap/dtools
```

## Available formulae

| Formula | Commands | Description | Upstream |
| --- | --- | --- | --- |
| `dtools` | `dnet` | Command-line tools for managing personal machines | <https://github.com/drusellers/dtools> |

## Maintaining formulae

When cutting a new upstream release:

```sh
TAG=v2026.07.29.135058-aa28d9b
curl -L -o /tmp/dtools-${TAG}.tar.gz \
  "https://github.com/drusellers/dtools/releases/download/${TAG}/dtools-${TAG}.tar.gz"
shasum -a 256 /tmp/dtools-${TAG}.tar.gz
```

Then update `Formula/dtools.rb` with the release `url`, `version`, `sha256`, and license when available before validating:

```sh
ruby -c Formula/dtools.rb
brew tap drusellers/tap "$(pwd)" # only needed if this checkout is not already tapped
brew audit --strict --formula drusellers/tap/dtools
brew test drusellers/tap/dtools
```
