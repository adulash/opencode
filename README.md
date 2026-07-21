<p align="center">
  <a href="https://opencode.ai">
    <picture>
      <source srcset="packages/console/app/src/asset/logo-ornate-dark.svg" media="(prefers-color-scheme: dark)">
      <source srcset="packages/console/app/src/asset/logo-ornate-light.svg" media="(prefers-color-scheme: light)">
      <img src="packages/console/app/src/asset/logo-ornate-light.svg" alt="OpenCode logo">
    </picture>
  </a>
</p>
<p align="center">The open source AI coding agent.</p>
<p align="center">
  <a href="https://github.com/adulash/opencode"><img alt="GitHub" src="https://img.shields.io/badge/GitHub-adulash%2Fopencode-181717?style=flat-square&logo=github" /></a>
  <a href="mailto:adula.dev@gmail.com"><img alt="Email" src="https://img.shields.io/badge/email-adula.dev%40gmail.com-blue?style=flat-square" /></a>
  <a href="https://github.com/adulash/opencode/releases/latest"><img alt="Latest release" src="https://img.shields.io/github/v/release/adulash/opencode?style=flat-square" /></a>
</p>

<p align="center">
  <a href="README.md">English</a> |
  <a href="README.ar.md">العربية</a>
</p>

[![OpenCode Terminal UI](packages/web/src/assets/lander/screenshot.png)](https://opencode.ai)

---

### Installation

```bash
# Linux and macOS
curl -fsSL https://raw.githubusercontent.com/adulash/opencode/dev/install | bash
```

```powershell
# Windows
irm https://raw.githubusercontent.com/adulash/opencode/dev/install.ps1 | iex
```

You can also grab a binary directly from the [releases page](https://github.com/adulash/opencode/releases).

> [!NOTE]
> This fork ships its own GitHub releases. It is **not** published to npm, Homebrew, Scoop, Chocolatey, the AUR or nixpkgs — those packages install the original English OpenCode instead. Use the commands above to get the Arabic build.

> [!TIP]
> Remove versions older than 0.1.x before installing.

### Desktop App (BETA)

OpenCode is also available as a desktop application. Download it from this fork's [releases page](https://github.com/adulash/opencode/releases).

| Platform | Download                      |
| -------- | ----------------------------- |
| Windows  | `opencode-desktop-win-x64.exe` |

> [!NOTE]
> This fork currently builds the desktop app for Windows only; the installer is unsigned, so Windows SmartScreen may warn on first run. On macOS and Linux, use the CLI install command above. The app updates itself from this repository's releases.

#### Installation Directory

The install script respects the following priority order for the installation path:

1. `$OPENCODE_INSTALL_DIR` - Custom installation directory
2. `$XDG_BIN_DIR` - XDG Base Directory Specification compliant path
3. `$HOME/bin` - Standard user binary directory (if it exists or can be created)
4. `$HOME/.opencode/bin` - Default fallback

```bash
# Examples
OPENCODE_INSTALL_DIR=/usr/local/bin curl -fsSL https://raw.githubusercontent.com/adulash/opencode/dev/install | bash
XDG_BIN_DIR=$HOME/.local/bin curl -fsSL https://raw.githubusercontent.com/adulash/opencode/dev/install | bash
```

### Agents

OpenCode includes two built-in agents you can switch between with the `Tab` key.

- **build** - Default, full-access agent for development work
- **plan** - Read-only agent for analysis and code exploration
  - Denies file edits by default
  - Asks permission before running bash commands
  - Ideal for exploring unfamiliar codebases or planning changes

Also included is a **general** subagent for complex searches and multistep tasks.
This is used internally and can be invoked using `@general` in messages.

Learn more about [agents](https://opencode.ai/docs/agents).

### Documentation

For more info on how to configure OpenCode, [**head over to our docs**](https://opencode.ai/docs).

### Contributing

If you're interested in contributing to OpenCode, please read our [contributing docs](./CONTRIBUTING.md) before submitting a pull request.

### Building on OpenCode

If you are working on a project that's related to OpenCode and is using "opencode" as part of its name, for example "opencode-dashboard" or "opencode-mobile", please add a note to your README to clarify that it is not built by the OpenCode team and is not affiliated with us in any way.

### FAQ

#### How is this different from Claude Code?

It's very similar to Claude Code in terms of capability. Here are the key differences:

- 100% open source
- Not coupled to any provider. Although we recommend the models we provide through [OpenCode Zen](https://opencode.ai/zen), OpenCode can be used with Claude, OpenAI, Google, or even local models. As models evolve, the gaps between them will close and pricing will drop, so being provider-agnostic is important.
- Built-in opt-in LSP support
- A focus on TUI. OpenCode is built by neovim users and the creators of [terminal.shop](https://terminal.shop); we are going to push the limits of what's possible in the terminal.
- A client/server architecture. This, for example, can allow OpenCode to run on your computer while you drive it remotely from a mobile app, meaning that the TUI frontend is just one of the possible clients.

---

## Contact the maintainer

This fork is maintained by an independent developer. For anything related to **this fork** — questions, feature ideas, bug reports — please use the channels below, **not** the upstream OpenCode channels:

| Channel | Link |
| --- | --- |
| Repository | [github.com/adulash/opencode](https://github.com/adulash/opencode) |
| Issues & feature requests | [Open a new issue](https://github.com/adulash/opencode/issues/new/choose) |
| Discussions | [GitHub Discussions](https://github.com/adulash/opencode/discussions) |
| Email | [adula.dev@gmail.com](mailto:adula.dev@gmail.com) |
| Security vulnerabilities | [Private advisory](https://github.com/adulash/opencode/security/advisories/new) — see [SECURITY.md](./SECURITY.md) |

---

## Upstream project & Arabic localization

This project is a fork of the open source **OpenCode** project:

- **Original project:** [github.com/anomalyco/opencode](https://github.com/anomalyco/opencode) — [opencode.ai](https://opencode.ai)
- **License:** MIT. All credit for the original work belongs to the OpenCode team and its contributors. See [LICENSE](./LICENSE).

**What is different here?** This fork has been professionally localized into Arabic by [adulash](https://github.com/adulash):

- Arabic translations for the desktop app, web UI and console interfaces.
- Localized documentation.
- Right-to-left (RTL) support across the interfaces.
- Fixes for Arabic alignment, contrast and text rendering in the terminal UI (TUI).
- Other fixes and improvements.

> This is an **unofficial** fork and is not affiliated with or endorsed by the OpenCode team. Please do not send issues about this fork to the upstream repository — and if a bug also exists in upstream OpenCode, report it there as well.

للعربية، راجع [README.ar.md](./README.ar.md).
