# Dynamic values, generators and templates

A Labs 2.0 probe lab for the **Early Access value plumbing**, none of which had
been exercised before:

| Feature | Availability | Resource used here |
|---|---|---|
| Dynamic values | Early Access | `variable`, `output` |
| Random generators | Early Access | all five types |
| Template | **Early Access** | `template.app_config` |
| Notes tab | Early Access | `note.values` |
| Expression fields | Early Access | generator refs in `environment` |

> Template is Early Access, not Post GA. An earlier lab of mine avoided it on
> the wrong assumption. `copy` *is* Post GA; the two are often mentioned
> together, which is where the confusion came from.

## The question this lab is built to answer

`template` takes `source`, `destination` and `variables` — but **no `target`**.
So which filesystem does `destination` write to? The lab writes to
`/tmp/generated/app.conf` and then checks for it inside `container.app`.

Result is recorded in `FINDINGS.md`.

## Startup guard

`container.app` waits for the network before its real entrypoint, because
containers start ~1.6s before the CNI attach. See
`instruqt-guacamole-lab-hp/FINDINGS.md` (G2).
