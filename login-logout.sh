#!/bin/bash

# Author christophecvr christophevanr@gmail.com
# Based on boot-shutdown script of:
# Vincenzo D'Amore v.damore@gmail.com
# Adapted to work as user Launchagent.
# 2024/01/12

trap userlogout SIGTERM

function userlogout()
{
  echo `date "+%Y-%m-%d %H:%M:%S"` "$USER" "Received a logout signal"

  # INSERT HERE THE COMMAND OR SCRIPT YOU WANT EXECUTE AT USER LOGOUT
  if [ -f ~/Library/Scripts/WisLibreofficeHistory.sh ];then
    ~/Library/Scripts/WisLibreofficeHistory.sh
  else
    echo `date "+%Y-%m-%d %H:%M:%S"` "$USER" "Could not find Scriptfile WisLibreofficeHistory.sh"
  fi

  exit 0
}

function userlogin()
{
  echo `date "+%Y-%m-%d %H:%M:%S"` `whoami` "Logged in"

  # INSERT HERE THE COMMAND OR SCRIPT YOU WANT EXECUTE AT USER LOGIN

  tail -f /dev/null &
  wait $!
}

userlogin;
