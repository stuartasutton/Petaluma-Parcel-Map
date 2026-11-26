#!/bin/bash
set -eu

ROOT="$(cd -- "$(dirname -- "$0")" && pwd -P)"
cd "$ROOT"
PID_FILE=.map-server.pid
LOCK_DIR=.map-server.lock
SERVER_ARGS="-u -m http.server 8001 --bind 127.0.0.1 --directory $ROOT"

if ! mkdir "$LOCK_DIR" 2>/dev/null; then
    echo "Could not lock the launcher. Wait for any start or stop to finish and check that $ROOT is writable." >&2
    exit 1
fi
trap 'rmdir "$LOCK_DIR"' EXIT
trap 'exit 1' HUP INT TERM

if [[ ! -f "$PID_FILE" ]]; then
    echo "No Parcel Map server is recorded for this checkout."
    exit 0
fi

SERVER_PID="$(cat "$PID_FILE")"
is_parcel_server() {
    [[ "$SERVER_PID" =~ ^[1-9][0-9]*$ ]] &&
        [[ "$(ps -ww -p "$SERVER_PID" -o command= 2>/dev/null)" == *" $SERVER_ARGS" ]]
}

if is_parcel_server; then
    kill "$SERVER_PID"
    for ((attempt = 0; attempt < 20; attempt++)); do
        if ! is_parcel_server; then
            rm -f "$PID_FILE"
            echo "Stopped the Parcel Map server."
            exit 0
        fi
        sleep 0.25
    done
    echo "The Parcel Map server has not exited (PID $SERVER_PID). Try stopping it again." >&2
    exit 1
fi

rm -f "$PID_FILE"
echo "Cleared a stale PID file. No process was stopped."
