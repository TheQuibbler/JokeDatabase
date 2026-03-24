# JokeDatabase

## Overview
JokeDatabase is a World of Warcraft Retail addon that posts random jokes to group chat.
It can post automatically after failed encounters and can reply to joke requests in guild, party, raid, and instance chat.
The addon uses persistent saved variables to track recent joke usage across sessions.

This is a addonification of my own Weakaura, which was a continuation of Tarball's Dadabase. 
Updated with over 600 jokes, and persistent tracking of recently used jokes to avoid repeats until all jokes have been used.

## Features
- Posts a random joke on encounter wipe events in dungeon and raid groups.
- Responds to `!joke` in guild, party, raid, and instance chat.
- Responds to `PlayerName tell us a joke` when `PlayerName` is your character name.
- Enable/Disable optional tracking of recently used jokes to avoid repeats until all jokes have been used.
- Enable/Disable optional status output after posting jokes.

## Installation
1.  Copy the `JokeDatabase` folder into your World of Warcraft `Interface/AddOns/` directory.
2.  Reload the UI (`/reload`) or restart the client. 

## Usage
- Automatic wipe jokes are posted after failed encounters.
- In group chat, players can request a joke with `!joke`.
- In group chat, players can request a joke with `YourCharacterName tell us a joke`.

## Options
- `/jokedb tracking on` enables persistent recent-joke tracking.
- `/jokedb tracking off` disables persistent recent-joke tracking.
- `/jokedb poststatus on` enables status output after each posted joke.
- `/jokedb poststatus off` disables status output after each posted joke.
- `/jokedb reset` clears only recent-joke tracking state.
- `/jokedb status` shows tracking state, recent joke count, and lifetime posted count.
- `/jokedb help` displays command help.

## License
This project is licensed under GPL v3. See the [LICENSE](LICENSE) file for details.