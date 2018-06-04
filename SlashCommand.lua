--[[----------------------------------------------------------------------------

  LiteMount/SlashCommand.lua

  Chat slash command (/litemount or /lmt) and macro maintenance.

  Copyright 2011-2018 Mike Battersby

----------------------------------------------------------------------------]]--

local L = LM_Localize

local TOP_LEVEL_MAP_ID = 946

local MacroName = "LiteMount"
local MacroText = [[
# Auto-created by LiteMount addon, it is safe to delete or edit this macro.
# To re-create it run "/litemount macro"
/click LM_B1
]]

local function CreateOrUpdateMacro()
    local index = GetMacroIndexByName(MacroName)
    if index == 0 then
        index = CreateMacro(MacroName, "ABILITY_MOUNT_MECHASTRIDER", MacroText)
    else
        EditMacro(index, nil, nil, MacroText)
    end
    return index
end

local function UpdateActiveMount(arg)
    local m = LM_PlayerMounts:GetMountFromUnitAura("player")
    if not m then return end

    local mDisabled = LM_Options:IsExcludedMount(m)

    if arg == "enable" or (arg == "toggle" and mDisabled) then
        LM_Print(format(L.LM_ENABLING_MOUNT, m.name))
        LM_Options:RemoveExcludedMount(m)
    elseif arg == "disable" or (arg == "toggle" and not mDisabled) then
        LM_Print(format(L.LM_DISABLING_MOUNT, m.name))
        LM_Options:AddExcludedMount(m)
    end
end

local function IsTrue(x)
    if x == nil or x == false or x == "0" or x == "off" then
        return false
    else
        return true
    end
end

local function PrintUsage()
    LM_Print(GAMEMENU_HELP .. ":")
    LM_Print("  /litemount enable | disable | toggle")
    LM_Print("  /litemount mounts [<substring>]")
    LM_Print("  /litemount maps [<substring>]")
    LM_Print("  /litemount continents [<substring>]")
    LM_Print("  /litemount location")
    LM_Print("  /litemount macro")
    LM_Print("  /litemount flags add <flagname>")
    LM_Print("  /litemount flags del <flagname>")
    LM_Print("  /litemount flags rename <oldname> <newname>")
    LM_Print("  /litemount xmog <slotnumber>")
end

local function PrintMaps(str)
    if not C_Map then return end -- Pre-BfA test

    local searchStr = string.lower(str or "")

    local allMaps = C_Map.GetMapChildrenInfo(TOP_LEVEL_MAP_ID, nil, true)

    sort(allMaps, function (a,b) return a.mapID < b.mapID end)

    for _, info in ipairs(allMaps) do
        local searchName = string.lower(info.name)
        if info.mapID == tonumber(str) or searchName:find(searchStr) then
            LM_Print(format("% 4d : %s (parent %d)", info.mapID, info.name, info.parentMapID))
        end
    end
end

local function PrintContinents(str)
    if not C_Map then return end -- Pre-BfA test

    local searchStr = string.lower(str or "")

    local allContinents = C_Map.GetMapChildrenInfo(TOP_LEVEL_MAP_ID, Enum.UIMapType.Continent, true)
    sort(allContinents, function (a,b) return a.mapID < b.mapID end)

    for _, info in ipairs(allContinents) do
        local searchName = string.lower(info.name)
        if info.mapID == tonumber(str) or searchName:find(searchStr) then
            LM_Print(format("% 4d : %s", info.mapID, info.name))
        end
    end
end

_G.LiteMount_SlashCommandFunc = function (argstr)

    -- Look, please stop doing this, ok? Nothing good can come of it.
    if InCombatLockdown() then
        LM_PrintError(ERR_NOT_IN_COMBAT)
        return true
    end

    local args = { strsplit(" ", argstr) }
    local cmd = table.remove(args, 1)

    if cmd == "macro" or cmd == strlower(MACRO) then
        local i = CreateOrUpdateMacro()
       if i then PickupMacro(i) end
        return true
    elseif cmd == "toggle" or cmd == "enable" or cmd == "disable" then
        UpdateActiveMount(cmd)
        return true
    elseif cmd == "location" then
        LM_Location:Dump()
        return true
    elseif cmd == "maps" then
        PrintMaps(table.concat(args, ' '))
        return true
    elseif cmd == "continents" then
        PrintContinents(table.concat(args, ' '))
        return true
    elseif cmd == "mounts" then
        local m
        if not args[1] then
            m = LM_PlayerMounts:GetMountFromUnitAura("player")
            if m then m:Dump() end
        else
            local n = string.lower(table.concat(args, ' '))
            local mounts = LM_PlayerMounts.mounts:Search(function (m) return string.match(strlower(m.name), n) end)
            for _,m in ipairs(mounts) do
                m:Dump()
            end
        end
        return true
    elseif cmd == "flags" then
        if args[1] == "add" and #args == 2 then
            LM_Options:CreateFlag(args[2])
            return true
        elseif args[1] == "del" and #args == 2 then
            LM_Options:DeleteFlag(args[2])
            return true
        elseif args[1] == "rename" and #args == 3 then
            LM_Options:RenameFlag(args[2], args[3])
            return true
        elseif args[1] == "list" and #args == 1 then
            local flags = LM_Options:GetAllFlags()
            for i = 1, #flags do
                if LM_Options:IsPrimaryFlag(flags[i]) then
                    flags[i] = ORANGE_FONT_COLOR_CODE .. flags[i] .. FONT_COLOR_CODE_CLOSE
                end
            end
            LM_Print(table.concat(flags, ' '))
            return true
        end
    elseif cmd == "xmog" then
        local slotID = tonumber(args[1])
        if slotID then
            local ok, _, _, _, id = pcall(C_Transmog.GetSlotVisualInfo, slotID, LE_TRANSMOG_TYPE_APPEARANCE)
            if ok == true then
                LM_Print(format("Transmog appearance ID for slot %d = %s", slotID, tostring(id)))
            else
                LM_Print("Bad transmog slot number: " .. slotID)
            end
            return true
        end
    elseif cmd == "debug" then
        if IsTrue(args[1]) then
            LM_Print(L.LM_DEBUGGING_ENABLED)
            LM_Options.db.char.debugEnabled = true
        else
            LM_Print(L.LM_DEBUGGING_DISABLED)
            LM_Options.db.char.debugEnabled = false
        end
        return true
--@debug@
    elseif cmd == "usable" then
        LM_Developer:Initialize()
        LM_Developer:UpdateUsability()
        return true
--@end-debug@
    elseif cmd == "" then
        return LiteMountOptionsPanel_Open()
    end

    PrintUsage()
    return true
end

