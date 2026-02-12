# Skill Template

Copy this folder pattern when creating a new skill.

## Folder Skeleton

```text
<skill-name>/
  SKILL.md
  references/
    <topic>.md
  scripts/
    <helper-script>
  assets/
    <templates-or-static-files>
```

## `SKILL.md` Starter

```md
---
name: <skill-name>
description: <what this skill does and when to use it>
---

# <Skill Title>

## Use This Skill When

- <condition 1>
- <condition 2>

## Workflow

1. <step 1>
2. <step 2>
3. <step 3>

## References

- `references/<topic>.md`
```

## Notes

- Keep the main `SKILL.md` short.
- Put deep implementation detail in `references/`.
- Add `scripts/` only when repeatability or safety matters.
