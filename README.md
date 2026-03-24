# JokeDatabase

## Overview
JokeDatabase is a World of Warcraft Retail addon that posts random jokes to group chat.
It can post automatically after failed encounters and can reply to joke requests in party, raid, and instance chat.
The addon uses persistent saved variables to track recent joke usage across sessions.

## Features
- Posts a random joke on encounter wipe events in dungeon and raid groups.
- Responds to `!joke` in party, raid, and instance chat.
- Responds to `!joke` in guild chat.
- Responds to `PlayerName tell us a joke` when `PlayerName` is your character name.
- Stores joke text separately from runtime logic for easier maintenance.
- Skips recent-joke filtering when tracking is disabled.
- Includes slash commands to configure tracking and print status.

## Modules
- `Jokes.lua`: Static joke list data used by the addon.
- `JokePool.lua`: Joke selection and tracking logic (saved variable initialization, pool rebuild/reset, and posting).
- `JokeDatabase.lua`: Event wiring, chat/encounter handlers, and slash command routing.

## Installation
1. Copy the `JokeDatabase` folder into your WoW addons directory: `World of Warcraft/_retail_/Interface/AddOns/`.
2. Ensure the final path is `World of Warcraft/_retail_/Interface/AddOns/JokeDatabase/`.
3. Start or restart WoW and enable JokeDatabase in the AddOns list.
4. Run `/reload` after updates.

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

## Saved Variables
- `JokeDatabaseSaved.trackingEnabled`: Enables or disables persistent tracking.
- `JokeDatabaseSaved.printStatusOnJoke`: Enables or disables per-joke status prints.
- `JokeDatabaseSaved.recentlyUsedJokes`: Stores recently used jokes as a lookup set (`jokeText -> true`).
- `JokeDatabaseSaved.recentJokeCount`: Stores the number of tracked recent jokes.
- `JokeDatabaseSaved.totalJokesPosted`: Stores total posted jokes.

## License
GPL v3. See [LICENSE](LICENSE).
