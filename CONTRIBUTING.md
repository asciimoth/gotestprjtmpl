# Versioning
This project follows [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html) (MAJOR.MINOR.PATCH).  
Make breaking changes only in a MAJOR release.
Additive, backwards-compatible features go in MINOR releases.
Bugfixes and small improvements go in PATCH releases.

# Commit message style
This project use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).
We recommend using github.com/commitizen-tools/commitizen to compose commits.
  
Supported commit types:
- `feat:` a new feature
- `fix:` a bug fix
- `perf:` a change that improves performance
- `refactor:` code change that neither fixes a bug nor adds a feature
- `docs:` documentation only changes
- `style:` formatting, missing semi-colons, etc (no code change)
- `test:` adding or fixing tests
- `chore:` updates to build process or auxiliary tools
- `build:` changes that affect the build system or external dependencies
- `ci:` changes to CI configuration
- `bump:` use only when bumping version during release (this is reserved for release automation)

> Note: chore commits are intentionally ignored by the changelog generator; use them for insignificant maintenance so the changelog stays useful.

# Reuse / license headers
We follow the [REUSE](https://reuse.software/) recommendations for license headers and SPDX identifiers.
Use the [reuse-tool](https://github.com/fsfe/reuse-tool) to check and add headers.

When you add or modify files, make sure you add yourself to the license header (when appropriate) and run the reuse checks before opening a PR.

# Branching / Git flow
We follow GitHub Flow (short-lived feature branches merged into `main` via PRs). See [GitHub’s documentation](https://docs.github.com/en/get-started/using-github/github-flow) for details.

# Dev environment
## Nix flake (recommended)
We provide a Nix flake development environment.
If you have Nix set up, use the flake to get a reproducible dev environment with the right versions of tools.
[Direnv](https://direnv.net/) is optional but recommended for automatic environment activation.

## Alternative env setup (without nix)
If you don't use Nix, install the following tools locally.
Maintainers only tool are not required for everyday contributions but are needed for release workflows.

Required for contributors:
- go
- golangci-lint
- crate-ci/typos
- gomod2nix

Maintainers-only:
- git-cliff
- goreleaser
- govulncheck
- ko
- yq, jq

# How to contribute
1. Fork the repository on GitHub.
2. Clone your fork
3. Start the dev environment:
    - Using Nix: `nix develop`
    - Or install dev dependencies manually (see above).
4. Create a branch: `git checkout -b feat/meaningful-name`
5. Make your changes.
6. Add or update tests for behavior changes.
7. Update `gomod2nix` if you changed `go.mod`: run `gomod2nix generate`
8. Run the checks and fix issues (see Pre-PR checklist).
9. Commit your changes (use Conventional Commits).
10. Push your branch and open a PR on GitHub. Link related issues and provide a clear description of changes and motivation.

## Pre-PR checklist
Before opening a PR, make sure:
- `go fmt ./...` was run and changes are committed
- `go test ./...` passes
- `go mod tidy` was run if dependencies changed
- `gomod2nix generate` was run if you touch go.mod
- `golangci-lint run` reports no new issues (or justify existing ones)
- `typos` was run and no obvious typos remain
- You added/updated tests where applicable
- You added/updated license headers (REUSE)
- Commits follow Conventional Commits style

# Release process (maintainers only)
There is a helper script [ci/release](ci/release) that automates the release process; it is also available as `release` inside the Nix dev environment.  
`release.yaml` contains configuration required by the `release` script. Top-level fields map to environment variables used by the script.
The secrets section specifies variables that must be pulled from local secret storage (supported sources: `pass` and `bitwarden`).  
If `MYREPO` is set, the script will push deb and rpm packages to the repo pointed to by `MYREPO`. If unset, those steps are skipped. `MYREPO` should point to a local copy of a deb/rpm repo compatible with [asciimoth/repo](https://github.com/asciimoth/repo).

## What the release script does
The release script runs the following steps (automated):
1. `go generate ./...`
2. `go mod tidy`
3. `go test ./...`
4. `golangci-lint run ./...`
5. `govulncheck ./...` (CVE/vuln checks)
6. Generate new semantic version (using the changelog commit history)
7. Update VERSION file
8. Generate changelog and commit it
9. Add a Git tag for the new version
10. Push commits and tags to GitHub
11. Run `goreleaser`:
    - build Linux & Windows binaries for x86 and arm targets
    - build deb, rpm, and ArchLinux packages
    - build Docker image
    - sign all artifacts with the local GPG key
    - create a GitHub release and upload artifacts
12. Push deb & rpm packages to the configured package repository (if `MYREPO` is set)
13. Announce the release to the configured social channels

**Important**: release automation assumes:
- You have a GPG key available locally for signing
- You can access credentials referenced by the secrets section of `release.yaml`
- goreleaser, git-cliff, govulncheck, and other maintainer tools are available

