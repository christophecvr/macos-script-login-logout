#!/bin/bash

# Author christophecvr christophevanr@gmail.com
# 2024/01/14

# some default locations
PLIST_PATH="$HOME/Library/LaunchAgents"
SCRIPTS_PATH="$HOME/Library/Scripts"
LOGS_PATH="$HOME/Library/Logs"

GIT_REPO_DIR="$PWD"
#echo $GIT_REPO_DIR
if [ "`echo "$GIT_REPO_DIR" | grep -o "macos-script-login-logout"`" != "macos-script-login-logout" ]; then
  #echo "$PWD This is not the git repo directory"
  GIT_REPO_LOC=`echo "/$BASH_SOURCE" | sed s/"\.\/"//g | sed s/"install.sh"//g | sed 's/\/*$//g'`
  GIT_REPO_DIR="$PWD$GIT_REPO_LOC"
  #echo "$GIT_REPO_DIR But this should be the git repo"
fi

cd $HOME
if [ ! -f "$GIT_REPO_DIR/login-logout-script.plist" ] || [ ! -f "$GIT_REPO_DIR/login-logout.sh" ];then
  echo "Could not find the files to install or uninstall aborting process"
  return 2> /dev/null ; exit
#else
  #echo "git is cloned ok install can go"
fi

function rmgitrepo()
{
  echo ""
  echo "####################################################################################"
  echo "### Install,Uninstall and or reinstall is done"
  echo "### Or you aborted installation"
  echo "### Do You wan't to remove the cloned git repository:"
  echo "### $GIT_REPO_DIR  ?"
  echo "### Answer Yes or No ***** !!! Default is NO !!! ******"
  echo "####################################################################################"
  echo ""
  read ANSWER
  if [ "$ANSWER" == "Yes" ] || [ "$ANSWER" == "yes" ];then
    rm -rf $GIT_REPO_DIR
    echo ""
    echo "################################################################################"
    echo "### GIT repository macos-script-login-logout is removed from you're pc"
    echo "################################################################################"
  fi
}

echo ""
echo "########################################################################"
echo "### Git repository macos-script-login-logout is cloned and found"
echo "### I ask you some questions "
echo "### "
echo "### Git repo path: $GIT_REPO_DIR"
echo "### You're home path: $HOME"
echo "### The Installing user (You): $USER"
echo "###"
echo "### Are the mentioned paths above right ? Yes/No  default Yes"
echo "########################################################################"
echo ""
read ANSWER
if [ "$ANSWER" == "No" ] || [ "$ANSWER" == "no" ];then
  echo ""
  echo "#############################################################################"
  echo "### You answered No are you shure the info is wrong ? You always can retry"
  echo "### If the info is not the right one automatic installation is not posible"
  echo "### Aborting installation"
  echo "#############################################################################"
  echo ""
  echo ""
  return 2> /dev/null ; exit
fi
ANSWER=""
echo ""

TEST_PREVIOUS_INSTALL=`launchctl list LOGIN.LOGOUT.SERVICE 2>/dev/null | grep -o LOGIN.LOGOUT.SERVICE`
if [ "$TEST_PREVIOUS_INSTALL" == "LOGIN.LOGOUT.SERVICE" ];then
  SERVICE="loaded"
  echo "Service Loaded"
fi
if [ -f "$HOME/Library/Logs/login-logout-script-install.log" ];then
  echo "installog found"
  INSTALLED_SCRIPTS_PATH=`grep "SCRIPTS_PATH" $HOME/Library/Logs/login-logout-script-install.log | sed s/"SCRIPTS_PATH = "//g`
  # echo $INSTALLED_SCRIPTS_PATH
  INSTALLED_LOGS_PATH=`grep "LOGS_PATH" $HOME/Library/Logs/login-logout-script-install.log | sed s/"LOGS_PATH = "//g`
  # echo $INSTALLED_LOGS_PATH
  if [ -f $PLIST_PATH/login-logout-script.plist ] && [ -f $INSTALLED_SCRIPTS_PATH/login-logout.sh ];then
    SERVICE="$SERVICE""installed"
    echo "Service installed"
    echo "########################################################################################################"
    echo "### !!! If You wan't to reinstall this service after uninstalling do You wan't to keep You're path's !!!"
    echo "###"
    echo "### PLIST_PATH = $PLIST_PATH"
    echo "### SCRIPTS_PATH = $INSTALLED_SCRIPTS_PATH"
    echo "### LOGS_PATH = $INSTALLED_LOGS_PATH"
    echo "###"
    echo "### Yes or No ? default is No. By default MacOs default paths will be used."
    echo "########################################################################################################"
    echo ""
    read KEEP_PATHS
    if [ "$KEEP_PATHS" == "Yes" ];then
      SCRIPTS_PATH="$INSTALLED_SCRIPTS_PATH"
      LOGS_PATH="$INSTALLED_LOGS_PATH"
      echo "paths changed to those from previous installation"
      KEEP_PATHS=""
    fi
  else
    echo ""
    echo "##############################################################################################"
    echo "### I did found a previous installog but no installation removing the installlog"
    echo "##############################################################################################"
    rm -f $HOME/Library/Logs/login-logout-script-install.log
  fi
else
  # echo "No installog found try to find installation on default locations"
  if [ -f $PLIST_PATH/login-logout-script.plist ] && [ -f $SCRIPTS_PATH/login-logout.sh ];then
    echo "Did found installation on default location whitout installog"
    SERVICE="$SERVICE""installed"
    INSTALLED_SCRIPTS_PATH=$SCRIPTS_PATH
    INSTALLED_LOGS_PATH=$LOGS_PATH
  else
    if [ -f $PLIST_PATH/login-logout-script.plist ];then
      echo ""
      echo "#########################################################################################################################"
      echo "##### ****** !!! A $PLIST_PATH/login-logout-script.plist is found !!!!!********"
      echo "##### This script does not find the login-logout.sh file ."
      echo "##### Most probably You did previousely a manual installation"
      echo "##### Or used this script with non standard paths and removed the $HOME/Library/Logs/login-logout-script-install.log"
      echo "##### If so first remove that installation manualy before using this script"
      echo "##### Uninstall and or Install process aborted"
      echo "##########################################################################################################################"
      echo "" 
      return 2> /dev/null ; exit
    fi   
  fi
fi
if [ "$SERVICE" == "loadedinstalled" ] || [ "$SERVICE" == "installed" ];then
  echo ""
  echo "#########################################################################################################"
  echo "### A previous installation is found"
  echo "### By uninstalling you're changes into login-logout.sh will be lost"
  echo "### Do you wan't to continu ? Yes or No default Yes"
  echo "#########################################################################################################"
  echo ""
  read ANSWER
  if [ "$ANSWER" == "No" ] || [ "$ANSWER" == "no" ];then
    echo ""
    echo "###########################################################################################"
    echo "###*** You selected to STOP the Install/Uninstalling process ***"
    echo "###########################################################################################"
    echo ""
    return 2> /dev/null ; exit
  fi    
  if [ "$SERVICE" == "loadedinstalled" ];then
    launchctl unload -w $PLIST_PATH/login-logout-script.plist
    echo "unloading service"
  fi
  echo "removing previous installation"
  rm -f $PLIST_PATH/login-logout-script.plist
  rm -f $INSTALLED_SCRIPTS_PATH/login-logout.sh
  if [ -f "$INSTALLED_LOGS_PATH/login-logout.log" ];then
    rm -f $INSTALLED_LOGS_PATH/login-logout.log
  fi
  if [ -f "$INSTALLED_LOGS_PATH/login-logout.err" ];then
    rm -f $INSTALLED_LOGS_PATH/login-logout.err
  fi
  echo ""
  echo "############################################################################################################"
  echo "### Previous installation has been unloaded and removed"
  echo "### Do you wan't to reinstall the service Yes or No !!!*** Default is Yes ***!!!"
  echo "############################################################################################################"
  echo ""
  read ANSWER
  if [ "$ANSWER" == "No" ] || [ "$ANSWER" == "no" ];then
    if [ -f "/Library/Logs/login-logout-script-install.log" ];then
      rm -f "/Library/Logs/login-logout-script-install.log"
    fi
    echo ""
    echo "#########################################################"
    echo "### You selected to NOT Reinstall The service"
    echo "### Previous installation is removed"
    echo "#########################################################"
    rmgitrepo
    return 2> /dev/null ; exit
  fi
else
  if [ "$SERVICE" == "loaded" ];then
    echo ""
    echo "#########################################################################################################################"
    echo "##### ****** !!! A LOADED LOGIN.LOGOUT.SERVICE has been found but no installation !!! ********"
    echo "##### This script does not find the installation self."
    echo "##### Most probably You did previousely a manual installation"
    echo "##### Or used this script with non standard paths and removed the $HOME/Library/Logs/login-logout-script-install.log"
    echo "##### If so first remove that installation manualy before using this script"
    echo "##### Uninstall and or Install process aborted"
    echo "##########################################################################################################################"
    echo ""
    return 2> /dev/null ; exit
  fi
fi

echo ""
echo "##########################################################################################################"
echo "### This script is a user Launchagent"
echo "### It will perform the command or scripts You insert in the login-logout.sh"
echo "### All actions are done with user autorithy so you can't do actions on system maps"
echo "### This script will install the files login-logout.sh and login-logout-script.plist on MacOs(x)"
echo "### Default user paths in users $HOME DIR locations "
echo "### The owner ship of installed files will all be $USER also the login-logout.sh"
echo "### I well will give you the opportunity to change the locations off"
echo "### login-logout.sh script file and logs files but select only paths in or above $HOME"
echo "### Use only full hard target paths if You change one of the locations"
echo "### #####################################################################################################"
echo ""
echo "#####################################################################################################################################"
echo "### $SCRIPTS_PATH = The default login-logout.sh location Do You wan't to change it ? Yes/No default No"
echo "#####################################################################################################################################"
read ANSWER
if [ "$ANSWER" == "Yes" ];then
  echo "#########################################################################################"
  echo "### Insert the wanted Location"
  echo "#########################################################################################"
  read ANSWER
  if [ -d "$ANSWER" ] && [ "`echo $ANSWER | grep -o "$HOME"`" == "$HOME" ];then
    SCRIPTS_PATH="$ANSWER"
  else
    echo ""
    echo "############################################################################################"
    echo "### Not a correct path keeping default $SCRIPTS_PATH"
    echo "############################################################################################"
  fi
  ANSWER=""
fi
echo ""
echo "##############################################################################################################"
echo "### $LOGS_PATH = The default log location. Do You wan't to change it ? Yes/No default No"
echo "##############################################################################################################"
read ANSWER
if [ "$ANSWER" == "Yes" ] && [ "`echo $ANSWER | grep -o "$HOME"`" == "$HOME" ];then
  echo "#############################################"
  echo "### Insert the wanted location"
  echo "#############################################"
  read ANSWER
  if [ -d "$ANSWER" ];then
    LOGS_PATH="$ANSWER"
  else
    echo ""
    echo "#####################################################################"
    echo "### Not a correct path keeping default $LOGS_PATH"
    echo "#####################################################################"
  fi
  ANSWER=""
fi
echo ""
echo "############################################################################"
echo "### The current install paths are:"
echo "###"
echo "### $PLIST_PATH plist file"
echo "### $SCRIPTS_PATH script-files"
echo "### $LOGS_PATH Log files"
echo "###"
echo "### If You're happy with the paths we can proceed with the installation"
echo "### Do You wan't to proceed Yes/No default Yes"
echo "#############################################################################"

read ANSWER
if [ "$ANSWER" == "No" ];then
  echo ""
  echo "#######################################################"
  echo "#### You Aborted The Installation"
  echo "#######################################################"
  return 2> /dev/null ; exit
fi

cp -f "$GIT_REPO_DIR/login-logout-script.plist" "$PLIST_PATH"
cp -af "$GIT_REPO_DIR/login-logout.sh" "$SCRIPTS_PATH"
sed -i '' "s#SCRIPT_PATH#$SCRIPTS_PATH#g" "$PLIST_PATH/login-logout-script.plist"
sed -i '' "s#LOG_PATH#$LOGS_PATH#g" "$PLIST_PATH/login-logout-script.plist"

echo "Installation completed"
echo "Making a install Report"
INSTALL_LOG="$HOME/Library/Logs/login-logout-script-install.log"
if [ ! -f "$INSTALL_LOG" ];then
touch $INSTALL_LOG
fi
echo ""
echo "######################################################" > $INSTALL_LOG
echo "Login-Logout-Install-report"  >> $INSTALL_LOG
echo "######################################################" >> $INSTALL_LOG
echo "" >> $INSTALL_LOG
echo "`date "+%Y-%m-%d %H:%M:%S"` $USER Installed macos-script-login-logout" >> $INSTALL_LOG
echo "" >> $INSTALL_LOG
echo "" >> $INSTALL_LOG
echo "Install Locations" >> $INSTALL_LOG
echo "" >> $INSTALL_LOG
echo "GIT_REPO_DIR = $GIT_REPO_DIR" >> $INSTALL_LOG
echo "PLIST_PATH = $PLIST_PATH" >> $INSTALL_LOG
echo "SCRIPTS_PATH = $SCRIPTS_PATH" >> $INSTALL_LOG
echo "LOGS_PATH = $LOGS_PATH" >> $INSTALL_LOG
echo "" >> $INSTALL_LOG
echo "#################################################################" >> $INSTALL_LOG
echo "macos-script-login-logout INSTALLED" >> $INSTALL_LOG
echo "#################################################################" >> $INSTALL_LOG
echo "" >> $INSTALL_LOG
echo ""
echo "#################################################################"
echo "$INSTALL_LOG is completed"
echo "#################################################################"
if [ -f "$PLIST_PATH/login-logout-script.plist" ];then
  launchctl load -w $PLIST_PATH/login-logout-script.plist
  echo ""
  echo "###########################################################################################################"
  echo "### LOGIN.LOGOUT.SERVICE is Installed and Loaded"
  echo "### You can add commands or scripts to $SCRIPTS_PATH/login-logout.sh"
  echo "### Do not Forget to unload and reload the service after a change"
  echo "### To unload type: launchctl unload -w $PLIST_PATH/login-logout-script.plist "
  echo "### To load type: launchctl load -w $PLIST_PATH/login-logout-script.plist "
  echo "### Alternatively logout,login,logout,login and you should se the effects of change."
  echo "###########################################################################################################"
  rmgitrepo
else
  echo ""
  echo "###############################################################"
  echo "### Could not find the service due to a unknown error "
  echo "### !!! Installation failed !!!"
  echo "###############################################################"
fi

