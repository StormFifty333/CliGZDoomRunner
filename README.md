# CliGZDoomRunner
It works ok enough

How to start:

Right click windows logo and select Terminal

Copy and Paste this single line of 3 commands

```
curl -o gzdoomrunner.bat https://raw.githubusercontent.com/StormFifty333/CliGZDoomRunner/refs/heads/main/gzdoomrunner.bat; .\gzdoomrunner.bat; rm .\gzdoomrunner.bat
```

If you want to start again or install run those commands again to be prompted to play again or uninstall

The first command installs the script

The second runs it

The third removes script when done

\

Game will stay stored in %appdata%\GZDoom

This is a niche command line tool to use and the only reason it is public is for my friends to use.

I'm new to github so I won't be accepting contributions, only issues I MIGHT get around to fixing.

This is purely just to help walk my non tech savay friends through the process since it seemed like the easiest option.

I also wanted to experiment with batch scripting.

So Windows only because that's what my friends use.

\

Creates folders and runs commands that will download gzdoom and automatically join games for you.

Installation is created in %appdata%\GZDoom.

Can apply my prefered config.

Tries to find wads in steam install and if fails asks for own wad directory or option to download shareware.

Option to install brutal doom as well.

Join friends easily by being prompted to type in the ip.

I try to log what it's doing but if I miss something the script is here in the repo for viewing.

Uninstall script included for automatically removing the installation.

I'll try to update the GZDoom version occasionally but right now this tool is pretty rigid.

This is an open source script, no obfuscation here, it just might look like it because it is very hacky.

Still works most of the time so...
