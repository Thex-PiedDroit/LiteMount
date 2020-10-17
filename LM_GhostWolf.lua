--[[----------------------------------------------------------------------------

  LiteMount/LM_GhostWolf.lua

  Copyright 2011-2020 Mike Battersby

----------------------------------------------------------------------------]]--

local _, LM = ...

--@debug@
if LibDebug then LibDebug() end
--@end-debug@

local TABLET_OF_GHOST_WOLF_AURA = GetSpellInfo(168799)

LM.GhostWolf = setmetatable({ }, LM.Spell)
LM.GhostWolf.__index = LM.GhostWolf

function LM.GhostWolf:IsCancelable()
    return false
end

function LM.GhostWolf:IsCastable()
    if LM.UnitAura('player', self.spellID) then
        return false
    end
    return LM.Spell.IsCastable(self)
end

function LM.GhostWolf:CurrentFlags()
    local flags = LM.Mount.CurrentFlags(self)

    -- Ghost Wolf is also 100% speed if the Rehgar Earthfury bodyguard
    -- is following you around in Lost Isles (Legion). Unfortunately there's
    -- no way to detect him as far as I can tell.

    if flags.WALK then
        local hasAura
        hasAura = LM.UnitAura('player', TABLET_OF_GHOST_WOLF_AURA)
        if hasAura then
            flags = CopyTable(flags)
            flags.WALK = nil
            flags.RUN = true
        end
    end

    return flags
end
