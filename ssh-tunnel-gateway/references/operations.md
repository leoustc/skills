# SSH Tunnel Gateway Operations Reference

## Scope

- Package: `ssh-tunnel-gateway`
- CLIs: `ssh-tunnel-server`, `ssh-tunnel-agent`
- Transport model:
  - SSH data plane (`22`)
  - HTTP control plane (`12000`) or `--over-ssh`

## Design Intent

- Keep SSH native: `ProxyJump`, standard ssh config, and standard sshd settings.
- Keep control plane minimal: `POST /` with `action=register|heartbeat`.
- Keep identity stable: reuse cached `agent_id`; reuse `port_b` when possible.
- Prefer explicit, operationally safe defaults.

## Runtime Defaults

- Agent state directory: `~/.ssh-tunnel`
- Agent session file: `~/.ssh-tunnel/session.json`
- Agent key file: `~/.ssh-tunnel/agent.pem`
- Agent id file: `~/.ssh-tunnel/agent_id`
- Lease cleanup default: `7` days (`LEASE_TTL_DAYS`)

## `--over-ssh` Rules

- `--over-ssh <alias>` must match an alias in SSH config (`~/.ssh/config` or `SSH_CONFIG_PATH`).
- If alias is missing, fallback to standard endpoint mode.
- In `--over-ssh` mode, ignore `API_URL` host and use only its port.
- Use SSH alias directly as destination (do not force `user@alias`).

## Systemd Rules

- Use `-d` for both CLIs under systemd.
- Prefer absolute paths in environment files.
- Set `User=` explicitly so home expansion resolves correctly.
- Keep optional environment variables commented in example env files.

## Logging Expectations

- Agent logs register result with:
  - `agent_id`
  - `port_b`
  - `ssh_user`
  - `jump_user`
  - `jump_host`
  - `connect_hint`
- Server logs register/heartbeat with client IP and key operational fields.
- Foreground mode should provide enough detail to debug without opening code.

## Release Checklist

1. Update `VERSION`.
2. Verify README reflects current behavior and flags.
3. Build with `make build`.
4. Verify versions:
   - `ssh-tunnel-server --version`
   - `ssh-tunnel-agent --version`
5. Upload with `make upload`.
6. If package upload fails due to existing files, bump version and rebuild.

## Documentation Style

- Put copy/paste commands before deep details.
- Keep server and agent examples separate and explicit.
- Keep required env vars active; leave optional vars as comments.
