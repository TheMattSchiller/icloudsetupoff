#!/bin/bash

# Determine OS version
osvers=$(sw_vers -productVersion | awk -F. '{print $2}')
sw_vers=$(sw_vers -productVersion)

#users folder location, template folders location
#and plist location within users folder
users_folder="/Users"
templates_folder="/System/Library/User Template"
plist="/Library/Preferences/com.apple.SetupAssistant"

#Ensures that script is run as root user
if [ $(id -u) != 0 ];
then
	echo "this script must be run as root"
	exit 1
fi
#Checks the existing user folders in /Users
#for the presence of the Library/Preferences directory.
#If the directory is not found, it is created and then the
#plist is created if it does not exist.
#Then iCloud pop-up settings are set to be disabled.
icloud_setup_off ()
{
cd "$1"
for user in *
  do
    echo "$user"
    if [ "$1" = "$templates_folder" ]
    then
      user_uid="root"
    else
      user_uid=`basename "${user}"`
    fi
    if [ ! "${user_uid}" = "Shared" ]
    then
      if [ ! -d "${user}"/Library/Preferences ]
      then
        mkdir -p "${user}"/Library/Preferences
        chown "${user_uid}" "${user}"/Library
        chown "${user_uid}" "${user}"/Library/Preferences
      fi
      if [ ! -a "${user}""$plist" ]
      then
        touch "${user}""$plist".plist
      fi
      defaults write "$1"/"$user""$plist" DidSeeCloudSetup -bool TRUE
      defaults write "$1"/"$user""$plist" DidSeeApplePaySetup -bool TRUE
      defaults write "$1"/"$user""$plist" DidSeeAvatarSetup -bool TRUE
      defaults write "$1"/"$user""$plist" DidSeeSiriSetup -bool TRUE
      defaults write "$1"/"$user""$plist" DidSeeSyncSetup -bool TRUE
      defaults write "$1"/"$user""$plist" DidSeeSyncSetup2 -bool TRUE
      defaults write "$1"/"$user""$plist" DidSeeTouchIDSetup -bool TRUE
      defaults write "$1"/"$user""$plist" DidSeeiCloudLoginForStorageServicesSetup -bool TRUE
      defaults write "$1"/"$user""$plist" SkipFirstLoginOptimization -bool TRUE
      defaults write "$1"/"$user""$plist" GestureMovieSeen none
      defaults write "$1"/"$user""$plist" LastSeenCloudProductVersion "${sw_vers}"
      defaults write "$1"/"$user""$plist" RegisteredVersion "${sw_vers}"
      chown "${user_uid}" "${user}""$plist".plist
    fi
done
}

echo "Disabling iCloud setup and Setup Assistant for..."
echo "..."
#run on users folder
icloud_setup_off "$users_folder"

#run on templates folder
icloud_setup_off "$templates_folder"

exit
