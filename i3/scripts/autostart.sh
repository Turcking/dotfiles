#! /usr/bin/env sh

# Run all executable autostart scripts in i3 scripts directory
for autostart_file in "${XDG_CONFIG_HOME:-${HOME}/.config}"/i3/scripts/autostart-*.sh; do
	if [ -x "${autostart_file}" ]; then
		"${autostart_file}" &  # Put it in background
	fi
done
