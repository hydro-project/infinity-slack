# Infinity Slack Bot

A Slack front end for [Infinity](https://github.com/hydro-project/infinity) agents. Chat with the agent from Slack's
agent surface (the app's Messages tab) or any channel it's invited to: each Slack thread maps to an Infinity session,
responses stream into the thread as they're generated, and tool calls show up as task cards while the agent works.

The bot is a single binary. Its event-routing logic is a [Hydro](https://hydro.run) dataflow
(`crates/infinity-slack-dataflow`) compiled into the binary at build time via Hydro's embedded mode, and driven by the
bot's own async I/O layer (`crates/infinity-slack-bot`). It connects to Slack over Socket Mode (WebSocket), so no
public URL is needed, and to a locally running Infinity daemon over its Unix socket.

## Quick start

1. **Install and start Infinity** (the daemon hosts the actual agent sessions); see
   [hydro-project/infinity](https://github.com/hydro-project/infinity).
2. **Create the Slack app** from the manifest and generate its tokens: [docs/slack-bot.md](docs/slack-bot.md#creating-the-slack-app).
3. **Configure** `~/.infinity/slack.json` with the tokens: [docs/slack-bot.md](docs/slack-bot.md#configuration).
4. **Run the bot:**

   ```bash
   cargo run -p infinity-slack-bot
   ```

The full guide (manifest, configuration fields, usage, restarts, model switching, context compaction,
troubleshooting) is in **[docs/slack-bot.md](docs/slack-bot.md)**.

## Repository layout

| Path | Contents |
|------|----------|
| `crates/infinity-slack-dataflow` | The Hydro dataflow: Slack events + daemon events in, Slack actions + daemon commands out. Includes deterministic simulator tests. |
| `crates/infinity-slack-bot` | The binary: Slack Web API / Socket Mode client, daemon connection management, and the embedded dataflow. |
| `docs/slack-bot.md` | User guide. |

## Relationship to Infinity

The bot depends on `infinity-protocol` (the daemon's client protocol) via a git dependency pinned to a specific
revision of `hydro-project/infinity`. See [AGENTS.md](AGENTS.md#tracking-infinity) for how to bump it.

## Development

```bash
./check.bash   # fmt, clippy (warnings denied), tests incl. the Hydro simulator tests, THIRD-PARTY freshness
```

Contribution conventions (Conventional Commits, error handling, the Hydro staging rules) are in [AGENTS.md](AGENTS.md).

This project was split out of `hydro-project/infinity`; its git history was preserved, so commit subjects from before
the split reference PR numbers (`#NNN`) in **that** repository.

## License

Apache-2.0; see [LICENSE.txt](LICENSE.txt) and [NOTICE](NOTICE). Third-party notices are in [THIRD-PARTY](THIRD-PARTY).
