#!/bin/bash

# Determine OS version
osvers=$(sw_vers -productVersion | awk -F. '{print $2}')
sw_vers=$(sw_vers -productVersion)
users_folder="/Users/"
templates_folder="/System/Library/User Template/"

 # Checks the existing user folders in /Users
 # for the presence of the Library/Preferences directory.
 # If the directory is not found, it is created and then the
 # plist is created if it does not exist.
 # Then iCloud pop-up settings are set to be disabled.
icloud_setup_off ()
{
for user in "$1"
  do
    user_uid=`basename "${user}"`
    if [ ! "${user_uid}" = "Shared" ]
    then
      if [ ! -d "${user}"/Library/Preferences ]
      then
        mkdir -p "${user}"/Library/Preferences
        chown "${user_uid}" "${user}"/Library
        chown "${user_uid}" "${user}"/Library/Preferences
      fi
      if [ ! -a "${user}"/Library/Preferences/com.apple.SetupAssistant ]
      then
        cp /tmp/com.apple.SetupAssistant.plist "${user}"/Library/Preferences/com.apple.SetupAssistant.plist
      fi
      defaults write "$user"/Library/Preferences/com.apple.SetupAssistant DidSeeCloudSetup -bool TRUE
      defaults write "$user"/Library/Preferences/com.apple.SetupAssistant DidSeeApplePaySetup -bool TRUE
      defaults write "$user"/Library/Preferences/com.apple.SetupAssistant DidSeeAvatarSetup -bool TRUE
      defaults write "$user"/Library/Preferences/com.apple.SetupAssistant DidSeeSiriSetup -bool TRUE
      defaults write "$user"/Library/Preferences/com.apple.SetupAssistant DidSeeSyncSetup -bool TRUE
      defaults write "$user"/Library/Preferences/com.apple.SetupAssistant DidSeeSyncSetup2 -bool TRUE
      defaults write "$user"/Library/Preferences/com.apple.SetupAssistant DidSeeTouchIDSetup -bool TRUE
      defaults write "$user"/Library/Preferences/com.apple.SetupAssistant DidSeeiCloudLoginForStorageServicesSetup -bool TRUE
      defaults write "$user"/Library/Preferences/com.apple.SetupAssistant SkipFirstLoginOptimization -bool TRUE
      defaults write "$user"/Library/Preferences/com.apple.SetupAssistant GestureMovieSeen none
      defaults write "$user"/Library/Preferences/com.apple.SetupAssistant LastSeenCloudProductVersion "${sw_vers}"
      chown "${user_uid}" "${user}"/Library/Preferences/com.apple.SetupAssistant.plist
    fi
done
}

#run on users folder
icloud_setup_off $users_folder

#run on templates folder
icloud_setup_off $templates_folder

rm /tmp/com.apple.SetupAssistant.plist

exit
