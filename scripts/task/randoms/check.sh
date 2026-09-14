#!/bin/sh
# Every generated value should be present and well formed.
fail() { echo "FAIL: $1"; exit 1; }

[ -n "$DB_PASSWORD" ] || fail "DB_PASSWORD empty"
[ "$(printf %s "$DB_PASSWORD" | wc -c)" -eq 24 ] || fail "DB_PASSWORD is not 24 chars"

# random_id.hex of 8 bytes is 16 hex characters
echo "$BUILD_ID" | grep -Eq '^[0-9a-f]{16}$' || fail "BUILD_ID is not 16 hex chars: $BUILD_ID"

echo "$SESSION_ID" | grep -Eq '^[0-9a-f-]{36}$' || fail "SESSION_ID is not a UUID: $SESSION_ID"

[ "$REPLICAS" -ge 2 ] 2>/dev/null && [ "$REPLICAS" -le 9 ] || fail "REPLICAS out of range: $REPLICAS"

# random_creature is documented as "adjective-animal"
echo "$CODENAME" | grep -q '-' || fail "CODENAME is not adjective-animal: $CODENAME"

echo "ok: $CODENAME / $BUILD_ID / replicas=$REPLICAS"
exit 0
