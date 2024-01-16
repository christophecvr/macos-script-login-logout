#!/bin/sh

# Author: christophecvr christophevanr@gmail.com
# 2024/01/11
# Find the office history file if found remove it.

HistoryFile=`find ~/Library -type f -name "org.libreoffice.script.sfl2"`
if [ -f "$HistoryFile" ];then
  rm -f "$HistoryFile"
  echo `date "+%Y-%m-%d %H:%M:%S"` "$USER" "Removed $HistoryFile"
else
  echo `date "+%Y-%m-%d %H:%M:%S"` "$USER" "No LibreOffice History file found"
fi
