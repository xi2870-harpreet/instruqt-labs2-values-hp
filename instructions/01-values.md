# Generated values

This lab exercises the Early Access value plumbing, none of which had been
tested before: `variable`, all five random generators, `output`, `template`,
`note` variables, and an `editor` tab.

## What is generated

| Resource | Attribute | Passed to the container as |
|---|---|---|
| `random_password.db` | `.value` | `DB_PASSWORD` |
| `random_id.build` | `.hex` | `BUILD_ID` |
| `random_uuid.session` | `.value` | `SESSION_ID` |
| `random_number.replicas` | `.value` | `REPLICAS` |
| `random_creature.codename` | `.value` | `CODENAME` |

Note that `random_id` has **no `.value`** — it exposes `.hex`, `.dec` and
`.base64` instead. Using `.value` fails validation.

Open the **Values** tab on the right: it is a `note` resource rendering those
same values through Handlebars.

<instruqt-task id="randoms"></instruqt-task>

Inspect them yourself in the Shell tab:

```sh
env | grep -E 'APP_NAME|BUILD_ID|SESSION_ID|REPLICAS|CODENAME'
```
