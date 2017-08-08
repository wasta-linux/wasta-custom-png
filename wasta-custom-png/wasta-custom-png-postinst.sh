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

# setup directory for reference later
DIR=/usr/share/wasta-custom-png/resources

# ------------------------------------------------------------------------------
# LibreOffice Preferences Extension install (for all users)
# ------------------------------------------------------------------------------

# REMOVE "Wasta-English-Intl-Defaults" extension: remove / reinstall is only
#   way to update
EXT_FOUND=$(ls /var/spool/libreoffice/uno_packages/cache/uno_packages/*/wasta-english-intl-defaults.oxt* 2> /dev/null)

if [ "$EXT_FOUND" ];
then
    unopkg remove --shared wasta-english-intl-defaults.oxt
fi

# Install wasta-english-intl-defaults.oxt (Default LibreOffice Preferences)
echo
echo "*** Installing/Updating Wasta English Intl Default LO Extension"
echo
unopkg add --shared $DIR/wasta-english-intl-defaults.oxt

# IF user has not initialized LibreOffice, then when adding the above shared
#   extension, the user's LO settings are created, but owned by root so
#   they can't change them: solution is to just remove them (will get recreated
#   when user starts LO the first time).


for LO_FOLDER in /home/*/.config/libreoffice;
do
    LO_OWNER=$(stat -c '%U' $LO_FOLDER)

    if [ "$LO_OWNER" == "root" ];
    then
        echo
        echo "*** LibreOffice settings owned by root: resetting"
        echo "*** Folder: $LO_FOLDER"
        echo
    
        rm -rf $LO_FOLDER
    fi
done

# ------------------------------------------------------------------------------
# Set system-wide Paper Size
# ------------------------------------------------------------------------------
# Note: This sets /etc/papersize.  However, many apps do not look at this
#   location, but instead maintain their own settings for paper size :-(
paperconfig -p a4

# ------------------------------------------------------------------------------
# Add .kmfl placeholder to each user/home folder
# ------------------------------------------------------------------------------

for USER_HOME in /home/*;
do
    USER_HOME_NAME=$(basename $USER_HOME)

    # only process if "real user" (so not for wasta-remastersys, etc.)
    if id "$USER_HOME_NAME" >/dev/null 2>&1;
    then
        echo
        echo "*** adding .kmfl placeholder directory for $USER_HOME_NAME"
        echo 

        # sleep needed to avoid race condition that was crashing cinnamon??
        sleep 2

        # copy in .kmfl placeholder folder for users to add layouts to
        cp -uR $DIR/.kmfl \
            $USER_HOME/

        echo
        echo "*** adding scrollbar arrows for $USER_HOME_NAME"
        echo 

        # sleep needed to avoid race condition that was crashing cinnamon??
        sleep 2

        # copy in gtk.css tweak for scrollbar arrows
        cp -uR $DIR/gtk-3.0 \
            $USER_HOME/.config/

        echo
        echo "*** adding Mouse Exercise to Desktop for $USER_HOME_NAME"
        echo 

        # sleep needed to avoid race condition that was crashing cinnamon??
        sleep 2

        # copy in Mouse Exercise folder
        cp -uR $DIR/Mouse_exercise_2017 \
            $USER_HOME/Desktop/
	mv $USER_HOME/Desktop/Mouse_exercise_2017 $USER_HOME/Desktop/Mouse_Exercise

        # ensure all ownership is correct
        chown -R $USER_HOME_NAME:$USER_HOME_NAME \
            $USER_HOME/.kmfl

        chown -R $USER_HOME_NAME:$USER_HOME_NAME \
            $USER_HOME/.config/gtk-3.0

        chown -R $USER_HOME_NAME:$USER_HOME_NAME \
            $USER_HOME/Desktop/Mouse_Exercise

    fi
done

# ------------------------------------------------------------------------------
# Dconf / Gsettings Default Value adjustments
# ------------------------------------------------------------------------------
# Override files in /usr/share/glib-2.0/schemas/ folder.
#   Values in z_20_wasta-custom-png.gschema.gschema.override will override values
#   in z_10_wasta-base-setup.gschema.override which will override Mint defaults.
echo
echo "*** Updating dconf / gsettings default values"
echo
# Sending any "error" to null (if a key isn't found it will return an error,
#   but for different version of Cinnamon, etc., some keys may not exist but we
#   don't want to error in this case: suppressing errors to not worry user.
glib-compile-schemas /usr/share/glib-2.0/schemas/ 2>/dev/null || true;


# ------------------------------------------------------------------------------
# Finished
# ------------------------------------------------------------------------------

echo
echo "*** Finished with wasta-custom-png-postinst.sh"
echo

exit 0
