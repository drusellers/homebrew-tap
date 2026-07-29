# drusellers Homebrew Tap

Personal Homebrew tap for tools and utilities.

## Install

```sh
brew tap drusellers/tap
```

Trust this personal tap so Homebrew can load formulae from it without prompting:

```sh
brew trust --tap drusellers/tap
```

Install this tap's `dtools` formula by using the fully qualified name:

```sh
brew install drusellers/tap/dtools
```

Homebrew/core also has a `dtools` formula for the D programming language, so avoid bare `brew install dtools` unless you have verified it resolves to this tap.

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

For `dtools`, run the **Update dtools formula** workflow from the Actions tab to update `Formula/dtools.rb` and open a pull request for the latest release. You can optionally provide a specific release tag.

To update manually when cutting a new upstream release:

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
brew install drusellers/tap/dtools
brew test drusellers/tap/dtools
```
