#!/bin/bash

# Author christophecvr christophevanr@gmail.com
# 2024/01/14

# This scripts installs the user macos-script-login-logout
# The user can set a specific command and or scipt file to be executed 
# at login or logout it is user based so rights are those from user.
# Insert you're desired commands or scripts into login-logout.sh script.

GIT_REPO_DIR=`pwd`
cd ~

# Check if there was already a service loaded with previous tests.
TEST_PREVIOUS_INSTALL=`launchctl list LOGIN.LOGOUT.SERVICE 2>/dev/null | grep -o LOGIN.LOGOUT.SERVICE`
if [ "$TEST_PREVIOUS_INSTALL" == "LOGIN.LOGOUT.SERVICE" ];then
  echo "You're service was already installed and loaded"
  echo "Do You wan't to proceed ? Yes or No"
  read ANSWER
  if [ "$ANSWER" == "Yes" ];then
    BACKUP=`find $HOME/Library/Scripts -maxdepth 1 -type f -name "login-logout.sh"`
    if [ -f "$BACKUP" ];then
      cp -af "$BACKUP" "$BACKUP.bak"
      echo "A backup from login-logout.sh is made with name login-logout.sh.bak"
    fi
    echo "Unloading previous installed service"
    echo "Previous files will be reset to the current"
    echo "Aded command in login-logout.sh will be gone"
  else
    echo "You aborted the installation"
    exit
  fi
  if [ -f ~/Library/LaunchAgents/login-logout-script.plist ];then
    launchctl unload -w ~/Library/LaunchAgents/login-logout-script.plist
    if [ -f "$HOME/Library/Logs/login-logout.log" ];then
      rm -f "$HOME/Library/Logs/login-logout.log"
    fi
    if [ -f "$HOME/Library/Logs/login-logout.err" ];then
      rm -f "$HOME/Library/Logs/login-logout.err"
    fi
  else
    echo "there is something very wrong login-logout-script.plist not found"
    echo "A previous scipt has been loaded but could not be found in $HOME/Library/LaunchAgents"
    echo "Maybe you renamed it or loaded it from another location ?"
    echo "Installation Aborted"
    exit
  fi
else
  if [ -f ~/Library/LaunchAgents/login-logout-script.plist ];then
    echo "Warning the login-logout-script.plist already installed but not loaded"
    echo "If You continue this installation all you're previous changes will be gone."
    echo "Continue Yes or No ?"
    read ANSWERB
    if [ "$ANSWERB" == "Yes" ]; then  
      echo "We proceed with installation"
      BACKUP=`find $HOME/Library/Scripts -maxdepth 1 -type f -name "login-logout.sh"`
      if [ -f "$BACKUP" ] ; then
        cp -af "$BACKUP" "$BACKUP.bak"
        echo "A backup from login-logout.sh is made with name login-logout.sh.bak"
      fi
      echo "Previous files will be reset to the current"
      echo "Aded command in login-logout.sh will be gone"
      if [ -f "$HOME/Library/Logs/login-logout.log" ];then
        rm -f "$HOME/Library/Logs/login-logout.log"
      fi
      if [ -f "$HOME/Library/Logs/login-logout.err" ];then
        rm -f "$HOME/Library/Logs/login-logout.err"
      fi
    else
      echo "Installation aborted"
      exit
    fi
  fi
fi

if [ -f "$GIT_REPO_DIR/login-logout-script.plist" ] && [ -f "$GIT_REPO_DIR/login-logout.sh" ];then
  cp -af "$GIT_REPO_DIR/login-logout-script.plist" ~/Library/LaunchAgents/
  if [ ! -d ~/Library/Scripts ] ; then
    echo "creating directory Scripts in You're home/Library dir"
    mkdir $HOME/Library/Scripts
  fi
  SCRIPT_PATH="$HOME/Library/Scripts"
  cp -af "$GIT_REPO_DIR/login-logout.sh" $SCRIPT_PATH
  if [ -f "$GIT_REPO_DIR/WisLibreofficeHistory.sh" ];then
    cp -af "$GIT_REPO_DIR/WisLibreofficeHistory.sh" $SCRIPT_PATH
  fi
else
  echo "SOMETHING WENT WRONG login-logout-script.plist or login-logout.sh not found"
  exit
fi
if [ -f ~/Library/LaunchAgents/login-logout-script.plist ];then
  sed -i '' "s#SCRIPT_DIR#$SCRIPT_PATH#g" "$HOME/Library/LaunchAgents/login-logout-script.plist"
  sed -i '' "s#USERS_DIR#$HOME#g" "$HOME/Library/LaunchAgents/login-logout-script.plist"
  launchctl load -w ~/Library/LaunchAgents/login-logout-script.plist
  echo "Service Installed and Loaded"
  echo "You can add command or script in file $SCRIPT_PATH/login-logout.sh"
fi

echo " "
echo "Do you Wan't to remove the cloned git repo ? Yes or No"
read REMOVE_REPO
if [ "$REMOVE_REPO" == "Yes" ];then
  rm -rf "$GIT_REPO_DIR"
  echo "git repo removed"
else
  echo "git repo remains on you're pc"
fi

