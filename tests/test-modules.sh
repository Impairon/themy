#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf -- "$TMP_DIR"' EXIT

config_home="$TMP_DIR/config"
data_home="$TMP_DIR/data"
state_home="$TMP_DIR/state"
bin_dir="$TMP_DIR/bin"
wallpaper="$TMP_DIR/wallpaper.png"
mkdir -p "$config_home/themy" "$data_home" "$state_home" "$bin_dir"
printf 'test image\n' > "$wallpaper"

cp -a "$ROOT_DIR/templates" "$config_home/themy/templates"
cp -a "$ROOT_DIR/internals" "$config_home/themy/internals"
printf '%s\n' '{"btop": false, "example": true, "gtk": false, "qt": false, "yazi": false}' > "$config_home/themy/templates.json"

cat > "$bin_dir/matugen" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
cat <<'JSON'
{"colors":{"primary":{"default":{"hex":"#00aa88"}},"secondary":{"default":{"hex":"#7788aa"}},"tertiary":{"default":{"hex":"#cc6699"}},"surface":{"default":{"hex":"#202020"}},"background":{"default":{"hex":"#101010"}}}}
JSON
EOF
chmod +x "$bin_dir/matugen"

export PATH="$bin_dir:$PATH"
export XDG_CONFIG_HOME="$config_home"
export XDG_DATA_HOME="$data_home"
export XDG_STATE_HOME="$state_home"

run_themy(){
  "$ROOT_DIR/themy" --non-interactive --dark --scheme scheme-tonal-spot "$wallpaper" "$@"
}

run_themy
example_file="$config_home/themy-example/example.conf"
[[ -f "$example_file" ]]
grep -q 'primary=#00aa88' "$example_file"
grep -q 'background=#101010' "$example_file"
[[ -f "$state_home/themy/backup/example/example.conf.missing" ]]

printf 'old\n' > "$example_file"
run_themy
printf 'old\n' | cmp -s - "$state_home/themy/backup/example/example.conf"
printf 'changed\n' > "$example_file"
"$ROOT_DIR/themy" restore-backup
printf 'old\n' | cmp -s - "$example_file"

printf 'module end-to-end test passed\n'
