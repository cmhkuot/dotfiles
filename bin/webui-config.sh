#!/bin/bash
#
# Export/import Open WebUI admin settings.
# They live in the `config` key/value table inside webui.db, not in env vars.
# Reading SQLite directly avoids enabling API keys and storing another secret.

set -e

DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
source "$DOTFILES/bin/print.sh"

CONFIG_FILE="$DOTFILES/config/open-webui/webui-config.json"
COMPOSE_FILE="$DOTFILES/config/open-webui/compose.yml"
DB=/app/backend/data/webui.db

docker inspect -f '{{.State.Running}}' open-webui 2>/dev/null | grep -q true || {
    print_error "Container open-webui is not running. Start it with: webui up -d"
    exit 1
}

case "${1:-}" in
export)
    tmp=$(mktemp)
    trap 'rm -f "$tmp"' EXIT
    docker exec open-webui python3 -c "
import json, re, sqlite3, sys

SECRET = re.compile(r'key|secret|password|token|credential', re.I)


def holds_secret(node, parent=''):
    '''Secrets also hide inside values, e.g. tool_server.connections[].key'''
    if isinstance(node, dict):
        return any(holds_secret(v, k) for k, v in node.items())
    if isinstance(node, list):
        return any(holds_secret(v, parent) for v in node)
    return isinstance(node, str) and bool(node) and bool(SECRET.search(parent))


db = sqlite3.connect('$DB')
out = {}
for key, value in db.execute('select key, value from config'):
    if SECRET.search(key):
        continue
    try:
        parsed = json.loads(value)
    except (TypeError, ValueError):
        parsed = value
    if holds_secret(parsed, key):
        continue
    out[key] = parsed
json.dump(out, sys.stdout, indent=2, sort_keys=True, ensure_ascii=False)
print()
" >"$tmp"
    mv "$tmp" "$CONFIG_FILE"
    print_status "Exported -> $CONFIG_FILE"
    ;;
import)
    [ -f "$CONFIG_FILE" ] || {
        print_error "$CONFIG_FILE not found"
        exit 1
    }
    docker exec -i open-webui python3 -c "
import json, sqlite3, sys, time

db = sqlite3.connect('$DB')
now = int(time.time())
rows = [(k, json.dumps(v), now) for k, v in json.load(sys.stdin).items()]
# Upsert only: keys absent from the file keep their current value, so the
# secrets skipped during export are never wiped.
db.executemany(
    'insert into config(key, value, updated_at) values(?, ?, ?) '
    'on conflict(key) do update set value=excluded.value, updated_at=excluded.updated_at',
    rows,
)
db.commit()
print(f'{len(rows)} keys')
" <"$CONFIG_FILE"
    # Recreate rather than restart so .env changes are picked up too
    docker compose -f "$COMPOSE_FILE" up -d --force-recreate >/dev/null
    print_status "Imported <- $CONFIG_FILE, container recreated"
    ;;
*)
    echo "Usage: $(basename "$0") export|import"
    exit 1
    ;;
esac
