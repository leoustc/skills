---
name: ssh-tunnel-gateway
description: Build, configure, and operate ssh-tunnel-gateway (ssh-tunnel-server and ssh-tunnel-agent), including over-ssh mode and systemd deployment.
---

# SSH Tunnel Gateway

## Use This Skill When

- The task is about `ssh-tunnel-gateway`.
- The user needs to run or debug `ssh-tunnel-server` or `ssh-tunnel-agent`.
- The user needs deployment guidance for SSH transport, control plane, or systemd.

## Workflow

1. Confirm mode:
   - Standard mode (HTTP control endpoint + SSH data plane).
   - `--over-ssh` mode (SSH alias driven path).
2. Collect required runtime values:
   - Control endpoint, SSH host/users, key path, and state path.
3. Provide foreground commands first for validation, then systemd units.
4. Validate with logs:
   - Register and heartbeat events, stable `agent_id`, expected `port_b`.
5. If release work is requested, follow `references/operations.md`.

## Default Runtime Paths

- State directory: `~/.ssh-tunnel`
- Session file: `~/.ssh-tunnel/session.json`
- Key file: `~/.ssh-tunnel/agent.pem`
- Agent id file: `~/.ssh-tunnel/agent_id`
- Lease cleanup TTL: `7` days (`LEASE_TTL_DAYS`)

## Critical Rules

- Keep SSH native (`ProxyJump`, standard ssh config, standard sshd behavior).
- `--over-ssh <alias>` must match an alias in SSH config.
- In `--over-ssh` mode:
  - Use alias directly as destination (do not force `user@alias`).
  - Use only the port from `API_URL`; host comes from SSH alias.

## References

- Operational details and release checklist: `references/operations.md`
