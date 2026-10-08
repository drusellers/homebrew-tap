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

The current release installs `dnet` (macOS network helpers) and `dask` (a local
browser question UI for agents). Homebrew installs Node.js automatically for
`dask`; the launcher uses that dependency rather than whichever Node is on PATH.
The tools are licensed under Apache-2.0.

```sh
dnet --help
dask --help
dask ask "$(brew --prefix drusellers/tap/dtools)/share/dtools/examples/dask/questions.json"
```

`dask` accepts a JSON file or stdin (`dask ask -`) and returns selections and
optional notes as JSON on stdout. See the upstream README for the input format.
Installing the formula does not enable the network guard or change networking.

To install from the latest upstream commit instead of the latest release:

```sh
brew install --HEAD drusellers/tap/dtools
```

## Available formulae

| Formula | Commands | Description | Upstream |
| --- | --- | --- | --- |
| `dtools` | `dnet`, `dask` | Network helpers and visual agent questions | <https://github.com/drusellers/dtools> |

## Maintaining formulae

For `dtools`, run the **Update dtools formula** workflow from the Actions tab to update `Formula/dtools.rb` and open a pull request for the latest release. You can optionally provide a specific release tag.

To update manually when cutting a new upstream release:

```sh
TAG=v2026.10.08.192947-1a713b0
curl -L -o /tmp/dtools-${TAG}.tar.gz \
  "https://github.com/drusellers/dtools/releases/download/${TAG}/dtools-${TAG}.tar.gz"
shasum -a 256 /tmp/dtools-${TAG}.tar.gz
```

Then update `Formula/dtools.rb` with the release `url`, `version`, and `sha256`
before validating. The formula declares Apache-2.0 and a Node dependency,
installs both helper directories, and tests `dask` without opening a browser.

Your development checkout may differ from Homebrew's installed tap checkout.
Check `brew --repo drusellers/tap`: commands using the formula name below operate
on that checkout, not necessarily the current directory. After pushing changes,
`brew update` syncs the installed tap. The update workflow validates its own
checkout automatically.

```sh
ruby -c Formula/dtools.rb
brew style Formula/dtools.rb
```

Once the installed tap is synced:

```sh
brew audit --strict --formula drusellers/tap/dtools
brew install drusellers/tap/dtools # use brew upgrade if already installed
brew test drusellers/tap/dtools
```
