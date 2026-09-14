# Findings from the values / generators / template lab

Lab: `instruqt-support / instruqt-labs2-values-hp`
Repo: https://github.com/xi2870-harpreet/instruqt-labs2-values-hp

---

## V1 — `instruqt lab validate` accepts an `editor` resource the platform rejects  (P2, believed new)

### What was written

```hcl
resource "editor" "workspace" {
  target    = resource.container.app
  directory = "/tmp"
}
```

This is wrong — both arguments belong inside a `workspace` block — but nothing
said so until the lab was played.

### What the CLI said

```
==> Validating lab...
    [SUCCESS] Lab is valid
```

### What the platform said, at play time

```
unable to decode body: /tmp/sandbox-4154372706/tabs.hcl:7,3-9: Unsupported
argument; An argument named "target" is not expected here., and 1 other
diagnostic(s)
```

The lab imported cleanly, showed a **Code Editor** resource on the overview
page, and only failed when someone pressed Play.

### Why this matters

`validate` exists to catch exactly this. An author gets SUCCESS locally, pushes,
imports, sees the resource listed in the UI, and still has a broken lab. The
runtime clearly has the schema — it produces a precise, well-pointed diagnostic
— so the CLI is not using it.

This is the same class as the tab-target gap found earlier
(`instruqt-labs-conformance`, C1a): **the platform enforces a schema the CLI
validator does not**. Two independent instances now.

### The correct form, for reference

```hcl
resource "editor" "workspace" {
  workspace "container" {
    target    = resource.container.app
    directory = "/tmp"
  }

  workspace "local" {
    directory = "/tmp/generated"
  }
}
```

### Reproduce

Check out commit `a4c7b5f^` of this repo (the pre-fix `tabs.hcl`), run
`instruqt lab validate` — SUCCESS — then play the lab.

---

## Correction to an earlier assumption of mine

`template` is **Early Access**, not Post GA. The availability table lists:

| Feature | Available |
|---|---|
| Template | Early Access |
| Copy | Post GA |

The Guacamole lab was deliberately built with no file injection because I
believed both were Post GA. Only `copy` is.

---

## V2 — a failed session is sticky, blocks new ones, and `Exit` does nothing  (P2, strengthens G4)

After fixing V1 and pushing, the lab could not be run again:

- The manage page synced to the new commit and offered **Play**.
- Pressing Play produced **no new log entry at all** — the platform never
  attempted a new sandbox.
- The play URL kept serving the **original failure page**, quoting the old
  `tabs.hcl` and the old sandbox directory.
- **`Exit` on the failure screen does nothing.** This was clicked with a real
  mouse event at its actual coordinates, not a synthetic `.click()`, which
  settles a hedge left in the Guacamole lab's G4: the button really is inert.
- There is **no Stop control** on the manage page while this state persists, so
  there is no way to clear it from the UI.

The net effect: one bad commit can wedge a lab, and fixing the commit does not
un-wedge it.

In the Guacamole lab the recovery was Stop then Play, but Stop is only offered
while a session is considered live. Here the session is failed-but-retained, so
neither control is available.

---

## Open question this lab is built to answer

`template` takes `source`, `destination` and `variables` but **no `target`**, so
it is not documented which filesystem `destination` writes to. The lab writes to
`/tmp/generated/app.conf` and looks for it from two directions:

- `task.templated` checks for it **inside** `container.app`
- `editor.workspace` has a `local` workspace rooted at `/tmp/generated`, which
  reads the **local** filesystem

**Still unanswered.** The lab has not reached a running state because of V2, so
neither check has executed. The HCL is correct and validates; it needs a session
that actually starts.
