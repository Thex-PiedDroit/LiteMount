--[[----------------------------------------------------------------------------

  LiteMount/CombatMacro.lua

  Options frame to plug in to the Blizzard interface menu.

  Copyright 2011-2017 Mike Battersby

----------------------------------------------------------------------------]]--

function LiteMountOptionsCombatMacro_OnLoad(self)
    self.name = MACRO .. " : " .. COMBAT
    LiteMountOptionsPanel_OnLoad(self)
end

function LiteMountOptionsCombatMacro_OnTextChanged(self)
    local c = strlen(self:GetText() or "")
    LiteMountOptionsCombatMacroCount:SetText(format(MACROFRAME_CHAR_LIMIT, c))
    LiteMountOptionsControl_OnChanged(self)
end