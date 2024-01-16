# macOS (macOSX) Login/Logout Script .
Launchagent script to execute a command or shell script at user login or logout.
This works on macOS High Sierra 10.13.6 Last avbl MacOs on my hardware (mid 2010)
It will work on the High Sierra and most probably on on some older osx versions.
The newer I don't I just can't test it. If someone with MacOs higher then High Sierra 10.13.6
Test this, that would be nice.

# Automatic Install with install.sh

- Open terminal
- type: cd $HOME
- type: git clone https://github.com/christophecvr/macos-script-login-logout
- type: cd macos-script-login-logout
- type: source install.sh

That is all. There might be some interactif question asked to you just respond to You're needs.

# Manual Install :

There are two files:
- login-logout-script.plist
- login-logout.sh: bash shell script

# Install

Customize the login-logout-script.plist: according explanation in file.

Then copy the file login-logout-script.plist to $HOME/Library/LaunchAgents/

Customize the login-logout.sh to you're needs
place it in $HOME/Library/Scripts .
- Make script executable.
- chmod 755 $HOME/Library/Scripts/login-logout.sh

# To start the login logout service
- open terminal
- type : launchctl load -w ~/Library/LaunchAgents/login-logout-script.plist

# To stop the login logout service
- open terminal
- type : launchctl unload -w ~/Library/LaunchAgents/login-logout-script.plist

The script will be started at every user login. Stopped on user logout.
If you only wan't to load it manually set the key RunAtLoad into plist to false.
- then start manually :
- launchctl start LOGIN.LOGOUT.SERVICE
- to stop
- launchctl stop LOGIN.LOGOUT.SERVICE

# After changing file login-logout.sh
unload and reload the service in order to have changes directly applied
- open terminal
- type : launchctl unload -w ~/Library/LaunchAgents/login-logout-script.plist
- type : launchctl load -w ~/Library/LaunchAgents/login-logout-script.plist

Alternatively just logout,login,logout,login and You're changes should be in effect.

## Links

- [Daemons and Services Programming Guide][1]
- [What is Launchd][2]


  [1]: https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/Introduction.html
  [2]: http://www.launchd.info/ 
