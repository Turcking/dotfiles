#! /usr/bin/env sh

# Terminate already running bar instances
killall -q polybar || true

# Wait until the processes have been shut down
while pgrep -u "$UID" -x polybar > /dev/null; do
	sleep 1
done

# Generate Polybar config using $XDG_CONFIG_HOME/polybar/config.ini.m4
CONFIG_FILE_NAME=$(mktemp --tmpdir polybar_config.ini.XXX)
m4 "${XDG_CONFIG_HOME:-${HOME}/.config}/polybar/config.ini.m4" > "${CONFIG_FILE_NAME}"

# Clean generated config on exit
trap "rm -f \"\${CONFIG_FILE_NAME}\"" EXIT

# Launch Polybar with the generated config
polybar -c "${CONFIG_FILE_NAME}" bar &
BAR_PID=$!
polybar -c "${CONFIG_FILE_NAME}" clock &
CLOCK_PID=$!

# Wait for Polybar to exit
wait "${BAR_PID}"
wait "${CLOCK_PID}"

