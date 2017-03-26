--[[----------------------------------------------------------------------------

  LiteMount/LM_Journal.lua

  Information about a mount from the mount journal.

  Copyright 2011-2016 Mike Battersby

----------------------------------------------------------------------------]]--

LM_Journal = setmetatable({ }, LM_Mount)
LM_Journal.__index = LM_Journal

--  [1] creatureName,
--  [2] spellID,
--  [3] icon,
--  [4] active,
--  [5] isUsable,
--  [6] sourceType,
--  [7] isFavorite,
--  [8] isFactionSpecific,
--  [9] faction,
-- [10] isFiltered,
-- [11] isCollected,
-- [12] mountID = C_MountJournal.GetMountInfoByID(mountID)

--  [1] creatureDisplayID,
--  [2] descriptionText,
--  [3] sourceText,
--  [4] isSelfMount,
--  [5] mountType = C_MountJournal.GetMountInfoExtraByID(mountID)

function LM_Journal:Get(id)
    local name, spellID, icon, _, _, _, _, _, faction, isFiltered, isCollected, mountID = C_MountJournal.GetMountInfoByID(id)
    local modelID, _, _, isSelfMount, mountType = C_MountJournal.GetMountInfoExtraByID(mountID)

    if not name then
        LM_Debug(format("LM_Mount: Failed GetMountInfo for ID = #%d", id))
        return
    end

    -- Exclude mounts not collected and ones Blizzard decide are hidden
    if isFiltered or not isCollected then return end

    if self.cacheByName[name] then
        return self.cacheByName[name]
    end

    local m = setmetatable(LM_Mount:new(), LM_Journal)

    m.journalIndex  = mountIndex
    m.modelID       = modelID
    m.name          = name
    m.spellID       = spellID
    m.spellName     = GetSpellInfo(spellID)
    m.mountID       = mountID
    m.iconTexture   = icon
    m.isSelfMount   = isSelfMount
    m.mountType     = mountType
    m.needsFaction  = PLAYER_FACTION_GROUP[faction]

    -- LM_Debug("LM_Mount: mount type of "..m.name.." is "..m.mountType)

    -- This attempts to set the old-style flags on mounts based on their
    -- new-style "mount type". This list is almost certainly not complete,
    -- and may be mistaken in places. List source:
    --   http://wowpedia.org/API_C_MountJournal.GetMountInfoExtra

    m.flags = { }

    if m.mountType == 230 then -- ground mount
        m.flags[LM_FLAG.RUN] = true
    elseif m.mountType == 231 then -- riding/sea turtle
        m.flags[LM_FLAG.SWIM] = true
    elseif m.mountType == 232 then -- Vashj'ir Seahorse
        m.flags[LM_FLAG.VASHJIR] = true
    elseif m.mountType == 241 then -- AQ-only bugs
        m.flags[LM_FLAG.AQ] = true
    elseif m.mountType == 247 then -- Red Flying Cloud
        m.flags[LM_FLAG.FLY] = true
    elseif m.mountType == 248 then -- Flying mounts
        m.flags[LM_FLAG.FLY] = true
    elseif m.mountType == 254 then -- Subdued Seahorse
        m.flags[LM_FLAG.SWIM] = true
        m.flags[LM_FLAG.VASHJIR] = true
    elseif m.mountType == 269 then -- Water Striders
        m.flags[LM_FLAG.SWIM] = true
        m.flags[LM_FLAG.RUN] = true
        m.flags[LM_FLAG.FLOAT] = true
    elseif m.mountType == 284 then -- Chauffeured Mekgineer's Chopper
        m.flags[LM_FLAG.WALK] = true
    end

    local spellName, _, _, _, _, _, castTime = GetSpellInfo(m.spellID)
    m.spellName = spellName
    m.castTime = castTime

    self.cacheByName[m.name] = m
    self.cacheBySpellID[m.spellID] = m

    return m
end

function LM_Journal:IsUsable()
    local usable = select(5, C_MountJournal.GetMountInfoByID(self.mountID))
    if not usable then return end
    if not IsUsableSpell(self.spellID) then return end
    return LM_Mount.IsUsable(self)
end

function LM_Journal:SetupActionButton(button)
    local t = ""
    if select(2, UnitClass("player")) == "DRUID" then
        t = t .. "/cancelform [form:1/2]\n"
    end

    t = t .. format("/run C_MountJournal.SummonByID(%d)\n", self.mountID)
    button:SetAttribute("type", "macro")
    button:SetAttribute("macrotext", t)
end
