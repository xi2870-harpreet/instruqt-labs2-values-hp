#!/bin/sh
# The template resource has no `target`, so this checks whether its output
# is visible inside the container at the destination path.
F=/tmp/generated/app.conf
[ -f "$F" ] || { echo "not found: $F"; exit 1; }
# Handlebars must have been rendered, not left literal
grep -q '{{' "$F" && { echo "template left unrendered {{ }} placeholders"; exit 1; }
grep -q "^db_password" "$F" || { echo "no db_password line"; exit 1; }
cat "$F"
exit 0
