#! /usr/bin/env sh

# Terminate already running fcitx5 instances
fcitx5-remote -e

# Wait until the processes have been shut down
while pgrep -u $UID -x fcitx5 >> /dev/null; do
	sleep 1
done

# Launch picom
exec fcitx5 -d

