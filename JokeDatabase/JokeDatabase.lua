local addonName, addonTable = ...

-----------------------------------
-- Initialization
-----------------------------------
local JokeDatabase = CreateFrame("Frame")
local slashCommandNames = {
    "tracking",
    "poststatus",
    "reset",
    "status",
    "help",
}
local jokePool = addonTable.jokePool

-----------------------------------
-- Helpers
-----------------------------------
-- Picks the appropriate group channel for wipe jokes based on raid, instance, or party context.
local function getWipeChannel()
    if IsInRaid() then
        return "RAID"
    elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
        return "INSTANCE_CHAT"
    elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
        return "PARTY"
    end

    return nil
end

-- Maps chat message events to the same outgoing channel for forced joke replies.
local function getReplyChannelFromEvent(eventName)
    if eventName == "CHAT_MSG_GUILD" then
        return "GUILD"
    end

    if eventName == "CHAT_MSG_PARTY" or eventName == "CHAT_MSG_PARTY_LEADER" then
        return "PARTY"
    end

    if eventName == "CHAT_MSG_RAID" or eventName == "CHAT_MSG_RAID_LEADER" then
        return "RAID"
    end

    if eventName == "CHAT_MSG_INSTANCE_CHAT" then
        return "INSTANCE_CHAT"
    end

    if eventName == "CHAT_MSG_INSTANCE_CHAT_LEADER" then
        return "INSTANCE_CHAT"
    end

    return nil
end

-- Normalizes incoming messages for case-insensitive matching.
local function normalizeMessage(messageText)
    if type(messageText) ~= "string" then
        return ""
    end

    local loweredMessage = string.lower(messageText)
    return loweredMessage:gsub("^%s+", ""):gsub("%s+$", "")
end

-- Checks whether the incoming message is a valid joke request for this character.
local function isJokeRequest(messageText)
    local normalizedMessage = normalizeMessage(messageText)

    if normalizedMessage == "!joke" then
        return true
    end

    local playerName = UnitName("player") or ""
    local normalizedPlayerName = string.lower(playerName)

    if normalizedPlayerName == "" then
        return false
    end

    local expectedRequest = normalizedPlayerName .. " tell us a joke"
    local isMatch = normalizedMessage == expectedRequest
    return isMatch
end

-- Handles chat-driven joke requests and replies in the originating channel.
local function processChatRequest(eventName, messageText)
    if not isJokeRequest(messageText) then
        return
    end

    local replyChannel = getReplyChannelFromEvent(eventName)

    if replyChannel then
        jokePool.postJoke(replyChannel)
        return
    end
end

-- Handles failed encounters and posts a wipe joke to raid, instance, or party chat.
local function processEncounterEnd(successValue)
    if successValue ~= 0 then
        return
    end

    local _, instanceType = IsInInstance()
    if instanceType ~= "raid" and instanceType ~= "party" then
        return
    end

    local wipeChannel = getWipeChannel()

    if wipeChannel then
        jokePool.postJoke(wipeChannel)
    end
end

-- Parses and executes slash command actions for tracking control and status inspection.
local function processSlashCommand(messageText)
    local normalizedInput = normalizeMessage(messageText)
    local command, argument = normalizedInput:match("^(%S+)%s*(.-)$")

    if normalizedInput == "" then
        command = "help"
    end

    if command == "tracking" then
        if argument == "on" then
            JokeDatabaseSaved.trackingEnabled = true
            jokePool.rebuildAvailableJokePool()
            print("JokeDatabase: Persistent joke tracking enabled.")
            return
        end

        if argument == "off" then
            JokeDatabaseSaved.trackingEnabled = false
            jokePool.rebuildAvailableJokePool()
            print("JokeDatabase: Persistent joke tracking disabled.")
            return
        end

        print("JokeDatabase: Use /jokedb tracking on|off")
        return
    end

    if command == "poststatus" then
        if argument == "on" then
            JokeDatabaseSaved.printStatusOnJoke = true
            print("JokeDatabase: Post-status messages enabled.")
            return
        end

        if argument == "off" then
            JokeDatabaseSaved.printStatusOnJoke = false
            print("JokeDatabase: Post-status messages disabled.")
            return
        end

        print("JokeDatabase: Use /jokedb poststatus on|off")
        return
    end

    if command == "reset" then
        jokePool.resetTrackingHistory()
        print("JokeDatabase: Recent tracking reset. Total posted counter preserved.")
        return
    end

    if command == "status" then
        local usedCount = #JokeDatabaseSaved.recentlyUsedJokes
        local totalCount = #addonTable.jokeList
        local trackingState = JokeDatabaseSaved.trackingEnabled and "enabled" or "disabled"
        print("JokeDatabase: Tracking is " .. trackingState .. ".")
        print("JokeDatabase: Recently used jokes " .. usedCount .. "/" .. totalCount .. ".")
        print("JokeDatabase: Total jokes posted " .. JokeDatabaseSaved.totalJokesPosted .. ".")
        return
    end

    if command == "help" then
        print("JokeDatabase commands:")
        print("/jokedb tracking on|off  - Enable or disable persistent joke tracking across sessions.")
        print("/jokedb poststatus on|off  - Enable or disable post-status messages after posting a joke.")
        print("/jokedb reset  - Reset recent joke tracking while preserving the total posted counter.")
        print("/jokedb status  - Display the current tracking status and joke usage statistics.")
        print("/jokedb help  - Display this help message.")
        return
    end

    local validCommands = table.concat(slashCommandNames, ", ")
    print("JokeDatabase: Unknown command. Valid commands: " .. validCommands)
end

-----------------------------------
-- Event Wiring
-----------------------------------
-- Initializes slash commands, saved variables, and event routing for addon behavior.
local function initializeAddon()
    jokePool.initializeSavedVariables()
    jokePool.rebuildAvailableJokePool()

    SLASH_JOKEDATABASE1 = "/jokedb"
    SLASH_JOKEDATABASE2 = "/jokedatabase"
    SlashCmdList.JOKEDATABASE = processSlashCommand


    JokeDatabase:RegisterEvent("ENCOUNTER_END")
    JokeDatabase:RegisterEvent("CHAT_MSG_PARTY")
    JokeDatabase:RegisterEvent("CHAT_MSG_PARTY_LEADER")
    JokeDatabase:RegisterEvent("CHAT_MSG_GUILD")
    JokeDatabase:RegisterEvent("CHAT_MSG_RAID")
    JokeDatabase:RegisterEvent("CHAT_MSG_RAID_LEADER")
    JokeDatabase:RegisterEvent("CHAT_MSG_INSTANCE_CHAT")
    JokeDatabase:RegisterEvent("CHAT_MSG_INSTANCE_CHAT_LEADER")

    print("JokeDatabase loaded. Use /jokedb help for commands.")
end

JokeDatabase:RegisterEvent("ADDON_LOADED")
JokeDatabase:SetScript("OnEvent", function(_, eventName, ...)
    if eventName == "ADDON_LOADED" then
        local loadedAddonName = ...
        if loadedAddonName == addonName then
            initializeAddon()
        end
        return
    end

    if eventName == "ENCOUNTER_END" then
        local _, _, _, _, successValue = ...
        processEncounterEnd(successValue)
        return
    end

    if eventName == "CHAT_MSG_PARTY"
        or eventName == "CHAT_MSG_PARTY_LEADER"
        or eventName == "CHAT_MSG_GUILD"
        or eventName == "CHAT_MSG_RAID"
        or eventName == "CHAT_MSG_RAID_LEADER"
        or eventName == "CHAT_MSG_INSTANCE_CHAT"
        or eventName == "CHAT_MSG_INSTANCE_CHAT_LEADER" then
        local messageText = ...
        processChatRequest(eventName, messageText)
    end
end)
