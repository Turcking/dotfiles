#! /usr/bin/env sh

# This script can update and run winkey-polybar automatically.
# You can use environment variable `WINKEY_POLYBAR_PROJECT_BASE_DIR` to change project directory.
# For example, you have or want winkey-polybar project in `${HOME}/winkey-polybar`, set `WINKEY_POLYBAR_PROJECT_BASE_DIR` to `${HOME}`.
# Default value is `${XDG_CACHE_HOME}/i3_scripts`.

function restartWinkeyPolybar {
	# Terminate already running winkey-polybar instances
	killall -q winkey-polybar

	# Wait until the processes have been shut down
	while pgrep -u $UID -x winkey-polybar >> /dev/null; do
		sleep 1
	done

	# Launch winkey-polybar
	if [ -f winkey-polybar/winkey-polybar ]; then
		exec winkey-polybar/winkey-polybar
	fi
}

function updateWinkeyPolybar {
	# Fetch or pull winkey-polybar for latest version
	if [ -d winkey-polybar ]; then
		cd winkey-polybar
		git pull https://github.com/Turcking/winkey-polybar
		cd ..
	else
		git clone https://github.com/Turcking/winkey-polybar
	fi

	# Build
	if [ -d winkey-polybar ]; then
		cd winkey-polybar
		make
		cd ..
	fi
}

# Prepare `WINKEY_POLYBAR_PROJECT_BASE_DIR`
if [ -z "${WINKEY_POLYBAR_PROJECT_BASE_DIR}" ]; then
	if [ -n "${XDG_CACHE_HOME}" ]; then
		WINKEY_POLYBAR_PROJECT_BASE_DIR="${XDG_CACHE_HOME}/i3_scripts"
	else
		WINKEY_POLYBAR_PROJECT_BASE_DIR="${HOME}/.cache/i3_scripts"
	fi
fi

# Prepare base directory
if [ ! -e ${WINKEY_POLYBAR_PROJECT_BASE_DIR} ]; then
	mkdir -p ${WINKEY_POLYBAR_PROJECT_BASE_DIR}
fi
if [ ! -d ${WINKEY_POLYBAR_PROJECT_BASE_DIR} ]; then
	exit
fi
cd "${WINKEY_POLYBAR_PROJECT_BASE_DIR}"

# Restart winkey-polybar first
restartWinkeyPolybar &

# Get last hashcode to check update
if [ -f winkey-polybar/winkey-polybar ]; then
	lastHashcode=$(md5sum winkey-polybar/winkey-polybar)
fi

# Update winkey-polybar
updateWinkeyPolybar

# Get currenct hashcode to check update
if [ -f winkey-polybar/winkey-polybar ]; then
	currentHashcode=$(md5sum winkey-polybar/winkey-polybar)
fi

# Restart winkey-polybar if updated, else wait.
if [ -n "${currentHashcode}" -a "${lastHashcode}" != "${currentHashcode}" ]; then
	restartWinkeyPolybar &
	wait
fi
wait

