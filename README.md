# macos-script-login-logout
Launchagent script to execute a command or shell script at user login or logout.

There are two files:
- login-logout-script.plist
- login-logout.sh: bash shell script

# Install

Customize the login-logout-script.plist: according explanation in file.

Then copy the file login-logout-script.plist to $HOME/Library/LaunchAgents/

Customize the login-logout.sh to you're needs
place it for example $HOME/scripts/ It's what I do all my user scripts ar in a own created map called scripts.
- Make script executable.
- chmod 755 $HOME/scripts/login-logout.sh

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

## Links

- [Daemons and Services Programming Guide][1]
- [What is Launchd][2]


  [1]: https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/Introduction.html
  [2]: http://www.launchd.info/ 
