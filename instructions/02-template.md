# Where does a template land?

The `template` resource takes `source`, `destination` and `variables` — but
**no `target`**. So it is not obvious which filesystem `destination` refers to:
the sandbox host, or a container.

This lab writes to `/tmp/generated/app.conf` and then looks for it *inside*
`container.app`.

<instruqt-task id="templated"></instruqt-task>

If the check fails, `template` does not write into containers, and pairing it
with a container needs something else — which matters, because `copy` is
Post GA and so is not available yet.

Look for yourself:

```sh
ls -la /tmp/generated/ 2>&1; cat /tmp/generated/app.conf 2>&1
```

The **Editor** tab is rooted at `/tmp`, so it gives a second view of the same
question.
