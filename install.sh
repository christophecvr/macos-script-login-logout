#!/bin/bash

# Author christophecvr christophevanr@gmail.com
# 2024/01/14

# This scripts installs the user macos-script-login-logout
# If the script was already installed it will unload and uninstall this script.
# All you're previous changes will be lost.
# The user can set a specific command and or scipt file to be executed 
# at login or logout it is user based so rights are those from user.
# Insert you're desired commands or scripts into login-logout.sh script.
# The script will make use of macos user defult locations.
# - script files in /Users/<home>/Library/Scipts
# - Log Files in    /Users/<home>/Library/Logs
# - Launchagent in  /Users/<home>/LaunchAgents

SERVICE=""
GIT_REPO_DIR=`pwd`

if [ "`echo $GIT_REPO_DIR | grep -o "macos-script-login-logout"`" != "macos-script-login-logout" ]; then
  echo "$PWD this is not the git repo directory"
# below using $BASH_SOURCE will always show the script name with the full path used to start
# iF you start it out of the git repo it will only give script-name here install.sh
# if you started it from underlying path it will give you that path.
# means source macos-script-login-logout/install.sh then $BASH_SOURCE = macos-script-login-logout/install.sh
# This is so on standard bash macos High Sierra could be different on other bash,shell or macos versions.
  GIT_REPO_DIR="$PWD`echo "/$BASH_SOURCE" | grep "install.sh" | sed s/"\/install.sh"//g`"
  echo "$GIT_REPO_DIR but this should be the git repo dirextory"
  
  if [ "`echo $GIT_REPO_DIR | grep -o "macos-script-login-logout"`" != "macos-script-login-logout" ]; then
    echo "On You're pc you can only start the script out off git repo directory."
    echo "Aborting Installation"
    return 2> /dev/null; exit
  fi
fi

cd ~

# Check if there was already a service installed and loaded.
TEST_PREVIOUS_INSTALL=`launchctl list LOGIN.LOGOUT.SERVICE 2>/dev/null | grep -o LOGIN.LOGOUT.SERVICE`
if [ "$TEST_PREVIOUS_INSTALL" == "LOGIN.LOGOUT.SERVICE" ];then
  SERVICE="loaded"
fi
if [ -f "$HOME/Library/LaunchAgents/login-logout-script.plist" ];then
  SERVICE="$SERVICE""installed"
fi
if [ "$SERVICE" == "loaded" ];then
  echo ""
  echo "The service is loaded but I can't find the installation"
  echo "I'm unable to remove it clean"
  echo "Aborting the script nothing is done"
  return 2> /dev/null; exit
fi
if [ "$SERVICE" == "loadedinstalled" ] || [ "$SERVICE" == "installed" ];then
  echo ""
  echo "A previous installation of this script has been found"
  echo "If You proceed that installation will be removed"
  echo "All You're changes to login-logout.sh will be lost"
  echo ""
  echo "Do You wan't to proceed Yes or No ?"
  read USER_ANSWER
  if [ "$USER_ANSWER" != "Yes" ];then
    echo "You choosed to abort the process"
    return 2> /dev/null; exit
  fi

  if [ "$SERVICE" == "loadedinstalled" ];then
    launchctl unload -w ~/Library/LaunchAgents/login-logout-script.plist
    echo ""
    echo "Service unloaded"
    echo ""
  fi
  rm -f "$HOME/Library/LaunchAgents/login-logout-script.plist"
  echo "$HOME/Library/LaunchAgents/login-logout-script.plist removed"
  if [ -f "$HOME/Library/Scripts/login-logout.sh" ];then
    rm -f "$HOME/Library/Scripts/login-logout.sh"
    echo "$HOME/Library/Scripts/login-logout.sh removed"
  fi
  if [ -f "$HOME/Library/Scripts/WisLibreofficeHistory.sh" ];then
    rm -f "$HOME/Library/Scripts/WisLibreofficeHistory.sh"
    echo "$HOME/Library/Scripts/WisLibreofficeHistory.sh removed"
  fi
  if [ -f "$HOME/Library/Logs/login-logout.err" ];then
    rm -f "$HOME/Library/Logs/login-logout.err"
    echo "$HOME/Library/Logs/login-logout.err removed"
  fi
  if [ -f "$HOME/Library/Logs/login-logout.log" ];then
    rm -f "$HOME/Library/Logs/login-logout.log"
    echo "$HOME/Library/Logs/login-logout.log removed"
  fi
  echo ""
  echo "The previous installation is removed"
  echo "Do You wan't to reinstall the current version ? Yes or No"
  read USER_ANSWER2
  if [ "$USER_ANSWER2" != "Yes" ];then
    echo ""
	echo "You choosed to abort the installation of new version"
    echo ""
	echo "Do You wan't to remove the git repo ? Yes or No"
    read USER_ANSWER3
    if [ "$USER_ANSWER3" == "Yes" ];then
      rm -rf "$GIT_REPO_DIR"
      echo ""
      echo "Git repo removed"
      echo ""
    else
      echo ""
      echo "Git repo remains on pc"
      echo
    fi
    return 2> /dev/null; exit
  fi
fi

# Installing The Launchagent service
if [ -f "$GIT_REPO_DIR/login-logout-script.plist" ] && [ -f "$GIT_REPO_DIR/login-logout.sh" ];then
  echo "installing script files"
  cp -af "$GIT_REPO_DIR/login-logout-script.plist" "$HOME/Library/LaunchAgents"
  cp -af "$GIT_REPO_DIR/login-logout.sh" "$HOME/Library/Scripts"
  sed -i '' "s#USERS_DIR#$HOME#g" "$HOME/Library/LaunchAgents/login-logout-script.plist"
  if [ -f "$GIT_REPO_DIR/WisLibreofficeHistory.sh" ];then
    echo "installing WisLibreofficeHistory.sh"
    cp -af "$GIT_REPO_DIR/WisLibreofficeHistory.sh" "$HOME/Library/Scripts"
  fi
  launchctl load -w ~/Library/LaunchAgents/login-logout-script.plist
fi
echo ""
echo "	#############################################################################################"
echo "	###            User LaunchAgent Login-Logout is installed and Loaded"
echo "	### 	You can ad a command or script in $HOME/Library/Scripts/login-logout.sh"
echo "	#############################################################################################"
echo ""
echo "Do You wan't to remove the git repo from you're pc ? Yes or No"
read USER_ANSWER4
if [ "$USER_ANSWER4" == "Yes" ];then
  rm -rf "$GIT_REPO_DIR"
  echo ""
  echo "Git repo removed from you're pc"
else
  echo ""
  echo "Git repo remains on you're pc"
fi
