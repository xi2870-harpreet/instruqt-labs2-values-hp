# Generated values

These come from the `note` resource's own `variables` map, rendered with
Handlebars. If any render as literal `{{braces}}`, note variables are broken.

| Value | Rendered |
|---|---|
| `variable.app_name` | {{app_name}} |
| `random_creature.codename` | {{codename}} |
| `random_id.build.hex` | {{build_id}} |
| `random_number.replicas` | {{replicas}} |

The password and UUID are deliberately **not** here — they are checked inside
the container instead, so a notes tab never displays a secret.
