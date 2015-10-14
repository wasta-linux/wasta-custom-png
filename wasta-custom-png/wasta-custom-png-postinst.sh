#!/bin/bash

# ==============================================================================
# wasta-custom-png: wasta-custom-png-postinst.sh
#
#   This script is automatically run by the postinst configure step on
#       installation of wasta-custom-png.  It can be manually re-run, but is
#       only intended to be run at package installation.  
#
#   2014-01-20 rik: initial script
#   2014-04-25 rik: removed libreoffice prior logic, now install LO extension
#       to handle default settings (this is persistent over LO upgrades).
#
# ==============================================================================

# ------------------------------------------------------------------------------
# Check to ensure running as root
# ------------------------------------------------------------------------------
#   No fancy "double click" here because normal user should never need to run
if [ $(id -u) -ne 0 ]
then
	echo
	echo "You must run this script with sudo." >&2
	echo "Exiting...."
	sleep 5s
	exit 1
fi

# ------------------------------------------------------------------------------
# Initial Setup
# ------------------------------------------------------------------------------

echo
echo "*** Beginning wasta-custom-png-postinst.sh"
echo

# ------------------------------------------------------------------------------
# LibreOffice Preferences Extension Install (for all users)
# ------------------------------------------------------------------------------

# Install wasta-english-intl-defaults.oxt (Default LibreOffice Preferences)
echo
echo "*** Installing LibreOffice Default Setttings Extension (for all users)"
echo
unopkg add --shared /usr/share/wasta-custom-png/resources/wasta-english-intl-defaults.oxt

# ------------------------------------------------------------------------------
# Finished
# ------------------------------------------------------------------------------

echo
echo "*** Finished with wasta-custom-png-postinst.sh"
echo

exit 0
