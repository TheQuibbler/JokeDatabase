local _, addonTable = ...
local sessionAvailableJokes = {}

-----------------------------------
-- Helpers
-----------------------------------
-- Creates or repairs saved variable fields so persistent storage always has valid data.
local function initializeSavedVariables()
    if type(JokeDatabaseSaved) ~= "table" then
        JokeDatabaseSaved = {}
    end

    if type(JokeDatabaseSaved.trackingEnabled) ~= "boolean" then
        JokeDatabaseSaved.trackingEnabled = true
    end

    if type(JokeDatabaseSaved.printStatusOnJoke) ~= "boolean" then
        JokeDatabaseSaved.printStatusOnJoke = false
    end

    if type(JokeDatabaseSaved.recentlyUsedJokes) ~= "table" then
        JokeDatabaseSaved.recentlyUsedJokes = {}
    end

    if type(JokeDatabaseSaved.totalJokesPosted) ~= "number" then
        JokeDatabaseSaved.totalJokesPosted = 0
    end
end

-- Rebuilds the in-memory joke pool from all jokes, excluding recently used jokes when tracking is enabled.
local function rebuildAvailableJokePool()
    local jokes = addonTable.jokeList or {}

    local available = {}
    for _, joke in ipairs(jokes) do
        if JokeDatabaseSaved.trackingEnabled then
          if not JokeDatabaseSaved.recentlyUsedJokes[joke] then
            table.insert(available, joke)
          end
        else 
            table.insert(available, joke)
        end
    end

    if #available == 0 and #jokes > 0 then
        JokeDatabaseSaved.recentlyUsedJokes = {}
        for _, joke in ipairs(jokes) do
            table.insert(available, joke)
        end
    end

    sessionAvailableJokes = available
end

-- Clears persisted tracking state so joke selection can restart from a full pool.
local function resetTrackingHistory()
    JokeDatabaseSaved.recentlyUsedJokes = {}
    rebuildAvailableJokePool()
end

-- Chooses a random joke from the in-memory pool and removes it for this session.
local function selectJoke()
    if #sessionAvailableJokes == 0 then
        rebuildAvailableJokePool()
    end

    if #sessionAvailableJokes == 0 then
        return nil
    end

    local selectedIndex = math.random(1, #sessionAvailableJokes)
    local selectedJoke = sessionAvailableJokes[selectedIndex]
    table.remove(sessionAvailableJokes, selectedIndex)

    if JokeDatabaseSaved.trackingEnabled then
        if not JokeDatabaseSaved.recentlyUsedJokes[selectedJoke] then
            JokeDatabaseSaved.recentlyUsedJokes[selectedJoke] = true
        end
    end

    return selectedJoke
end

-- Sends a selected joke to the specified channel and updates saved usage tracking.
local function postJoke(channelName)
    local selectedJoke = selectJoke()

    if not selectedJoke then
        return
    end

    if type(selectedJoke) ~= "string" or selectedJoke == "" then
        return
    end

    C_ChatInfo.SendChatMessage(selectedJoke, channelName)
    JokeDatabaseSaved.totalJokesPosted = JokeDatabaseSaved.totalJokesPosted + 1

    if JokeDatabaseSaved.printStatusOnJoke then
        local totalJokeCount = #addonTable.jokeList
        print("JokeDatabase: Recently used jokes " .. #JokeDatabaseSaved.recentlyUsedJokes .. "/" .. totalJokeCount .. ".")
        print("JokeDatabase: Total jokes posted " .. JokeDatabaseSaved.totalJokesPosted .. ".")
    end
end

-----------------------------------
-- Public API
-----------------------------------
addonTable.jokePool = {
    initializeSavedVariables = initializeSavedVariables,
    rebuildAvailableJokePool = rebuildAvailableJokePool,
    resetTrackingHistory = resetTrackingHistory,
    postJoke = postJoke,
}
