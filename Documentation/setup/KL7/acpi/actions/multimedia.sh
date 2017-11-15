#!/bin/sh

set $*

group=${1%%/*}
action=${1#*/}

log_unhandled() {
	logger "Multimedia event unhandled: $*"
}

case "$group" in
	button)
		case "$action" in
			volumeup)
				/usr/bin/amixer -q set PCM '3dB+'
				;;

			volumedown)
				/usr/bin/amixer -q set PCM '3dB-'
				;;

			mute)
				/usr/bin/amixer -q set PCM toggle
				;;
		esac
		;;

	cd)
		case "$action" in
			play)
				logger "TODO: play"
				;;

			prev)
				logger "TODO: prev"
				;;

			next)
				logger "TODO: next"
				;;

			*)	log_unhandled $* ;;
		esac
		;;

	*)	log_unhandled $* ;;
esac
