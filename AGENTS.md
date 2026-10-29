# Agent Guidelines

## Commit Messages

Use [Conventional Commits](https://www.conventionalcommits.org/) format:

```
<type>[optional scope]: <short summary>

<markdown body>
```

Types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `ci`, `perf`.

Scopes are usually the crate name: `infinity-slack-bot` or `infinity-slack-dataflow`.

For breaking changes, append `!` after the type (e.g. `refactor(infinity-slack-dataflow)!:`), and add `BREAKING CHANGE: ...`
footers describing each breaking change (or summarizing if many).

## Descriptions

Write the description in **Markdown**. Use bullet lists, code spans, and headings to organize multi-topic changes. Example:

```
feat(infinity-slack-bot): add a "Compact session" message shortcut

* Parse the `compact_session` message action
* Send `TriggerCompaction` for the thread's session
* Post an in-thread note on `CompactionApplied`
```

## Development

* Run `./check.bash` to test your changes before finalizing.
* Never ignore errors (`Result::Err`), make sure they are passed along or at least logged.
* Use `.expect("...")` with a descriptive message instead of `.unwrap()`. Prefix the message with "bug:" if a panic
  would represent a logical bug in our code (rather than a runtime error out of our control).
* `infinity-slack-dataflow` is a [Hydro](https://hydro.run) dataflow staged with stageleft. Types used in *type position*
  inside `q!()` bodies must be imported at the top of `flow.rs` (see the note there). The simulator tests in
  `crates/infinity-slack-dataflow/tests/` compile the dataflow into a dylib on first run.

## Tracking infinity

The bot talks to the [Infinity](https://github.com/hydro-project/infinity) daemon over `infinity-protocol`, which is
consumed as a git dependency **pinned to an exact revision** of `hydro-project/infinity` in the root `Cargo.toml`
(`[workspace.dependencies]`).

To pick up protocol changes (e.g. a newly merged daemon feature the bot needs):

1. Update the `rev = "..."` of `infinity-protocol` in the root `Cargo.toml` to the full SHA of the infinity commit.
   Prefer commits on infinity's `main`; pin to an unmerged branch commit only for work that is explicitly stacked on
   an open infinity PR, and repin to `main` once it merges.
2. Run `cargo update -p infinity-protocol` and then `./check.bash`.
3. Regenerate `THIRD-PARTY` if dependencies changed (`bash scripts/generate-third-party.sh`).
4. Commit the bump on its own (e.g. `chore: bump infinity to <short-sha>`) or together with the change that needs it.

A bot built against a newer protocol than the running daemon is generally fine: the daemon skips client messages it
cannot parse, so new features degrade to no-ops until the daemon is updated.
