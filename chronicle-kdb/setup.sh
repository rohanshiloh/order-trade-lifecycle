#!/usr/bin/env bash
#
# setup.sh — clone the Data Intellect Chronicle Queue → kdb+ adapter and
# de-Windows it, so the Warp launch config in this directory will run.
#
# The upstream repo (DataIntellectTech/kdb-chronicle-queue) was written on
# Windows: its bundled application.properties point at C:\ChronicleQueue\...
# and the queue path is baked in with escaped backslashes. Everything else is
# portable, so the whole port is three sed expressions and a mkdir.
#
#   ./setup.sh                 # clone to ~/code/kdb-chronicle-queue
#   CLONE_DIR=/tmp/x ./setup.sh
#
# Companion paper: https://rohanshiloh.github.io/order-trade-lifecycle/#chronicle-kdb

set -euo pipefail

REPO_URL="https://github.com/DataIntellectTech/kdb-chronicle-queue.git"
CLONE_DIR="${CLONE_DIR:-$HOME/code/kdb-chronicle-queue}"
QUEUE_DIR="${QUEUE_DIR:-$HOME/ChronicleQueue/Producer/quote}"

say()  { printf '\033[1;33m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;31m!!!\033[0m %s\n' "$*" >&2; }

# ---------------------------------------------------------------- prereqs ---
for cmd in git java; do
  command -v "$cmd" >/dev/null 2>&1 || { warn "$cmd not found on PATH"; exit 1; }
done
command -v q >/dev/null 2>&1 || warn "q not on PATH — the KDB tab will fail until it is"

JAVA_MAJOR=$(java -version 2>&1 | awk -F'"' '/version/{print $2}' | cut -d. -f1)
[ "${JAVA_MAJOR:-0}" -ge 11 ] 2>/dev/null || warn "Java ${JAVA_MAJOR:-?} found; the adapter expects 11+"

# ------------------------------------------------------------------ clone ---
if [ -d "$CLONE_DIR/.git" ]; then
  say "Already cloned at $CLONE_DIR — pulling"
  git -C "$CLONE_DIR" pull --ff-only
else
  say "Cloning $REPO_URL → $CLONE_DIR"
  mkdir -p "$(dirname "$CLONE_DIR")"
  git clone --depth 1 "$REPO_URL" "$CLONE_DIR"
fi

# ------------------------------------------------------------- queue dirs ---
say "Creating queue directory $QUEUE_DIR"
mkdir -p "$QUEUE_DIR"
# A stale STOP.txt makes the adapter exit immediately and silently.
rm -f "$QUEUE_DIR/STOP.txt"

# ------------------------------------------------- de-Windows the configs ---
# sed -i differs between GNU and BSD; pick the right incantation once.
if sed --version >/dev/null 2>&1; then SED_INPLACE=(-i); else SED_INPLACE=(-i ''); fi

port_props() {
  local f="$1"
  [ -f "$f" ] || return 0
  if [ -f "$f.orig" ]; then cp "$f.orig" "$f"; else cp "$f" "$f.orig"; fi   # idempotent
  say "Porting ${f#"$CLONE_DIR"/}"

  # 1 — the Windows queue path, in both its escaped and unescaped spellings.
  #     Properties files escape backslashes, so on disk it is C:\\Chronicle...
  sed "${SED_INPLACE[@]}" \
    -e "s#C:\\\\\\\\ChronicleQueue\\\\\\\\Producer\\\\\\\\quote#${QUEUE_DIR}#g" \
    -e "s#C:\\\\ChronicleQueue\\\\Producer\\\\quote#${QUEUE_DIR}#g" \
    "$f"

  # 2 — any backslash left on a path key becomes a slash. NOTE: -E is required.
  #     BSD sed has no \| alternation, so the BRE form of this address matches
  #     nothing on macOS and the trailing \\STOP.txt survives, silently.
  sed "${SED_INPLACE[@]}" -E \
    -e '/^(chronicle\.source|adapter\.stopFile)=/ s#\\\\#/#g' \
    -e '/^(chronicle\.source|adapter\.stopFile)=/ s#\\#/#g' \
    -e '/^(chronicle\.source|adapter\.stopFile)=/ s#//+#/#g' \
    "$f"
}

port_props "$CLONE_DIR/Adapter/src/main/resources/application.properties"
port_props "$CLONE_DIR/Producer/src/main/resources/application.properties"

# coreAffinity only does anything useful on Linux; leave it off elsewhere.
if [ "$(uname -s)" != "Linux" ]; then
  sed "${SED_INPLACE[@]}" -e 's/^adapter\.coreAffinity=.*/adapter.coreAffinity=-1/' \
    "$CLONE_DIR/Adapter/src/main/resources/application.properties" 2>/dev/null || true
fi

# kdb/start_kdb.sh ships without the executable bit in some checkouts.
chmod +x "$CLONE_DIR/kdb/start_kdb.sh" 2>/dev/null || true
chmod +x "$CLONE_DIR"/Adapter/mvnw "$CLONE_DIR"/Producer/mvnw 2>/dev/null || true

# ---------------------------------------------------------------- report ----
say "Resulting adapter config:"
grep -E '^(chronicle\.|adapter\.(stopFile|coreAffinity|messageType)|kdb\.)' \
  "$CLONE_DIR/Adapter/src/main/resources/application.properties" | sed 's/^/    /'

cat <<EOF

Done.

  repo    $CLONE_DIR
  queue   $QUEUE_DIR
  config  Adapter/src/main/resources/application.properties   (.orig kept alongside)

Next:
  cp kdb-chronicle.yaml ~/.warp/launch_configurations/
  # Warp → Command Palette → Launch Configuration → kdb-chronicle

Or by hand, in four terminals:
  1  cd $CLONE_DIR/kdb       && q dummytp.q -p 5000
  2  cd $CLONE_DIR/Producer  && ./mvnw spring-boot:run
  3  cd $CLONE_DIR/Adapter   && ./mvnw spring-boot:run
  4  curl -X POST 'http://localhost:9090/producer/quoteLoader?noOfMsgs=1000&gap=0&repeatMs=2000'

Stop the adapter with:  touch "$QUEUE_DIR/STOP.txt"
EOF
