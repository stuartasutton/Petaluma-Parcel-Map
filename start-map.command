#!/bin/bash
set -eu

ROOT="$(cd -- "$(dirname -- "$0")" && pwd -P)"
cd "$ROOT"
PORT=8001
MAP_FILE=Assessor-parcel-map-2026-11-24.html
URL="http://127.0.0.1:$PORT/$MAP_FILE"
PID_FILE=.map-server.pid
LOG_FILE=.map-server.log
LOCK_DIR=.map-server.lock
SERVER_ARGS="-u -m http.server $PORT --bind 127.0.0.1 --directory $ROOT"

fail() {
    printf '%s\n' "$*" >&2
    exit 1
}

command -v python3 >/dev/null && python3 --version >/dev/null 2>&1 ||
    fail "Python 3 is required. Install it from https://www.python.org/downloads/macos/."
[[ -r "$MAP_FILE" ]] || fail "Map file is missing or unreadable: $ROOT/$MAP_FILE"
mkdir "$LOCK_DIR" 2>/dev/null ||
    fail "Could not lock the launcher. Wait for any start or stop to finish and check that $ROOT is writable."
trap 'rmdir "$LOCK_DIR"' EXIT
trap 'exit 1' HUP INT TERM

ready() {
    lsof -nP -a -p "$SERVER_PID" -iTCP:"$PORT" -sTCP:LISTEN -t >/dev/null 2>&1 &&
        curl --noproxy '*' -fsSI --max-time 2 "$URL" >/dev/null 2>&1
}

SERVER_PID=""
if [[ -f "$PID_FILE" ]]; then
    SERVER_PID="$(cat "$PID_FILE")"
fi

if [[ "$SERVER_PID" =~ ^[1-9][0-9]*$ ]] &&
    [[ "$(ps -ww -p "$SERVER_PID" -o command= 2>/dev/null)" == *" $SERVER_ARGS" ]]; then
    echo "The Parcel Map server is already running (PID $SERVER_PID)."
else
    # Check that the checkout is writable before starting a background process.
    : > "$PID_FILE"
    : > "$LOG_FILE"
    nohup python3 -u -m http.server "$PORT" --bind 127.0.0.1 --directory "$ROOT" \
        >>"$LOG_FILE" 2>&1 </dev/null &
    SERVER_PID=$!
    printf '%s\n' "$SERVER_PID" > "$PID_FILE"
fi

for ((attempt = 0; attempt < 30; attempt++)); do
    if ready; then
        echo "Parcel Map: $URL"
        open -a "Google Chrome" "$URL" ||
            fail "Chrome could not open. Install Google Chrome or paste $URL into your browser."
        exit 0
    fi
    kill -0 "$SERVER_PID" 2>/dev/null || break
    sleep 0.25
done

if grep -qi "address already in use" "$LOG_FILE" 2>/dev/null; then
    fail "Port $PORT is in use by another process. Free port $PORT and try again. See $ROOT/$LOG_FILE."
fi
fail "The Parcel Map did not respond at $URL. See $ROOT/$LOG_FILE for details."
