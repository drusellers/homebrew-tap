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

The current release installs `dnet` (macOS network helpers), `dask` (a local
browser question UI for agents), `dmail` (read-only Microsoft 365 email),
`djobs` (a `launchctl list` viewer and user interval scheduler), and `dtodo`
(read-only Things and Wrike tasks).
Homebrew installs Node.js automatically for `dask`, `dmail`, `djobs`, and `dtodo`; their launchers
use that dependency rather than whichever Node is on PATH.
The tools are licensed under Apache-2.0.

```sh
dnet --help
dask --help
dmail --help
djobs --help
dtodo --help
dask ask "$(brew --prefix drusellers/tap/dtools)/share/dtools/examples/dask/questions.json"
```

`dask` accepts a JSON file or stdin (`dask ask -`) and returns selections and
optional notes as JSON on stdout. See the upstream README for the input format.
`dmail` uses delegated Microsoft Graph `Mail.Read` with device-code sign-in:

```sh
dmail login --tenant YOUR_TENANT_ID --client YOUR_CLIENT_ID
dmail list --unread --limit 10
dmail read 'MESSAGE_ID'
```

Your company app registration must enable public client flows and have delegated
`Mail.Read` permission/consent. See the upstream README for setup and token-cache
details. Formula tests do not sign in or contact Microsoft.
Installing the formula does not enable the network guard or change networking.

`djobs` lists loaded launchd jobs (hiding `com.apple.*` and configured
exclusions) and can install user-level interval schedules:

```sh
djobs --running
djobs ignore 'com.microsoft.'
djobs schedule ./backup.sh 1h --name backup
djobs unschedule backup
```

Run it as your normal user, not with sudo. An example config is installed at
`$(brew --prefix drusellers/tap/dtools)/share/dtools/examples/djobs/config.json`.
Formula tests only run `djobs --help` and `djobs ignore` against a temporary
config; they never list, load, or unload launchd jobs.

`dtodo` reads personal tasks from Things (macOS) and work tasks from Wrike,
returning JSON without modifying or syncing tasks. Run `dtodo login` to configure
Wrike, then `dtodo list`, or select one source with `dtodo list --source things`
or `dtodo list --source wrike`. Things must be running with Automation permission.
Formula tests only run `dtodo --help`; they never access Things, Wrike, or credentials.

To install from the latest upstream commit instead of the latest release:

```sh
brew install --HEAD drusellers/tap/dtools
```

## Available formulae

| Formula | Commands | Description | Upstream |
| --- | --- | --- | --- |
| `dtools` | `dnet`, `dask`, `dmail`, `djobs`, `dtodo` | Network helpers, visual agent questions, Microsoft 365 email, launchd jobs, and Things/Wrike tasks | <https://github.com/drusellers/dtools> |

## Maintaining formulae

For `dtools`, run the **Update dtools formula** workflow from the Actions tab to update `Formula/dtools.rb` and open a pull request for the latest release. You can optionally provide a specific release tag.

To update manually when cutting a new upstream release:

```sh
TAG=v2026.10.20.102433-e42dc12
curl -L -o /tmp/dtools-${TAG}.tar.gz \
  "https://github.com/drusellers/dtools/releases/download/${TAG}/dtools-${TAG}.tar.gz"
shasum -a 256 /tmp/dtools-${TAG}.tar.gz
```

Then update `Formula/dtools.rb` with the release `url`, `version`, and `sha256`
before validating. The formula declares Apache-2.0 and a Node dependency,
installs all five helper directories, tests `dask` without opening a browser,
checks `dmail --help` without accessing a mailbox, and tests `djobs` without
touching launchd. It also checks `dtodo --help` without accessing task sources.
When upstream adds a new
command, update the install wrappers and tests as well as the release metadata.

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
