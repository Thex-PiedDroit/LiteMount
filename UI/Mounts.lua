--[[----------------------------------------------------------------------------

  LiteMount/UI/Mounts.lua

  Options frame for the mount list.

  Copyright 2011-2019 Mike Battersby

----------------------------------------------------------------------------]]--

local L = LM_Localize

local NUM_FLAG_BUTTONS = 6

local function tslice(t, first, last)
    local out = { }
    for i = first or 1, last or #t do
        tinsert(out, t[i])
    end
    return out
end

-- Because we get attached inside the blizzard options container, we
-- are size 0x0 on create and even after OnShow, we have to trap
-- OnSizeChanged on the scrollframe to make the buttons correctly.
local function CreateMoreButtons(self)
    HybridScrollFrame_CreateButtons(self, self.buttonTemplate,
                                    0, -1, "TOPLEFT", "TOPLEFT",
                                    0, -1, "TOP", "BOTTOM")

    for _,b in ipairs(self.buttons) do
        b:SetWidth(b:GetParent():GetWidth())
    end
end

local function EnableDisableMount(mount, onoff)
    if onoff == "0" then
        LM_Options:AddExcludedMount(mount)
    else
        LM_Options:RemoveExcludedMount(mount)
    end
end

function LiteMountOptionsMountsFilterDropDown_Initialize(self, level)
    local info = UIDropDownMenu_CreateInfo()
    info.keepShownOnClick = true

    if level == 1 then
        info.isNotRadio = true

        info.text = VIDEO_OPTIONS_ENABLED
        info.arg1 = "ENABLED"
        info.checked = function ()
                return LM_UIFilter.IsFlagChecked("ENABLED")
            end
        info.func = function (_, _, _, v)
                LM_UIFilter.SetFlagFilter("ENABLED", v)
                LiteMountOptionsMounts.refresh()
            end
        UIDropDownMenu_AddButton(info, level)

        info.text = VIDEO_OPTIONS_DISABLED
        info.arg1 = "DISABLED"
        info.checked = function ()
                return LM_UIFilter.IsFlagChecked("DISABLED")
            end
        info.func = function (_, _, _, v)
                LM_UIFilter.SetFlagFilter("DISABLED", v)
                LiteMountOptionsMounts.refresh()
            end
        UIDropDownMenu_AddButton(info, level)

        info.text = COLLECTED
        info.arg1 = "COLLECTED"
        info.checked = function ()
                return LM_UIFilter.IsFlagChecked("COLLECTED")
            end
        info.func = function (_, _, _, v)
                LM_UIFilter.SetFlagFilter("COLLECTED", v)
                LiteMountOptionsMounts.refresh()
            end
        UIDropDownMenu_AddButton(info, level)

        info.text = NOT_COLLECTED
        info.arg1 = "NOT_COLLECTED"
        info.checked = function ()
                return LM_UIFilter.IsFlagChecked("NOT_COLLECTED")
            end
        info.func = function (_, _, _, v)
                LM_UIFilter.SetFlagFilter("NOT_COLLECTED", v)
                LiteMountOptionsMounts.refresh()
            end
        UIDropDownMenu_AddButton(info, level)

        info.text = MOUNT_JOURNAL_FILTER_UNUSABLE
        info.arg1 = "UNUSABLE"
        info.checked = function ()
                return LM_UIFilter.IsFlagChecked("UNUSABLE")
            end
        info.func = function (_, _, _, v)
                LM_UIFilter.SetFlagFilter("UNUSABLE", v)
                LiteMountOptionsMounts.refresh()
            end
        UIDropDownMenu_AddButton(info, level)

        info.checked = nil
        info.func = nil
        info.isNotRadio = nil
        info.hasArrow = true
        info.notCheckable = true

        info.text = L.LM_FLAGS
        info.value = 1
        UIDropDownMenu_AddButton(info, level)

        info.text = SOURCES
        info.value = 2
        UIDropDownMenu_AddButton(info, level)
    elseif level == 2 then
        info.hasArrow = false
        info.isNotRadio = true
        info.notCheckable = true

        if UIDROPDOWNMENU_MENU_VALUE == 2 then -- Sources
            info.text = CHECK_ALL
            info.func = function ()
                    LM_UIFilter.SetAllSourceFilters(true)
                    UIDropDownMenu_Refresh(LiteMountOptionsMounts.FilterDropDown, false, 2)
                    LiteMountOptionsMounts.refresh()
                end
            UIDropDownMenu_AddButton(info, level)

            info.text = UNCHECK_ALL
            info.func = function ()
                    LM_UIFilter.SetAllSourceFilters(false)
                    UIDropDownMenu_Refresh(LiteMountOptionsMounts.FilterDropDown, false, 2)
                    LiteMountOptionsMounts.refresh()
                end
            UIDropDownMenu_AddButton(info, level)

            info.notCheckable = false

            for i = 1,LM_UIFilter.GetNumSources() do
                if LM_UIFilter.IsValidSourceFilter(i) then
                    info.text = LM_UIFilter.GetSourceText(i)
                    info.arg1 = i
                    info.func = function (_, _, _, v)
                            LM_UIFilter.SetSourceFilter(i, v)
                            LiteMountOptionsMounts.refresh()
                        end
                    info.checked = function ()
                            return LM_UIFilter.IsSourceChecked(i)
                        end
                    UIDropDownMenu_AddButton(info, level)
                end
            end

        elseif UIDROPDOWNMENU_MENU_VALUE == 1 then -- Flags
            local flags = LM_UIFilter.GetFlags()

            info.text = CHECK_ALL
            info.func = function ()
                    LM_UIFilter:SetAllFlagFilters(true)
                    UIDropDownMenu_Refresh(LiteMountOptionsMounts.FilterDropDown, false, 2)
                    LiteMountOptionsMounts.refresh()
                end
            UIDropDownMenu_AddButton(info, level)

            info.text = UNCHECK_ALL
            info.func = function ()
                    LM_UIFilter:SetAllFlagFilters(false)
                    UIDropDownMenu_Refresh(LiteMountOptionsMounts.FilterDropDown, false, 2)
                    LiteMountOptionsMounts.refresh()
                end
            UIDropDownMenu_AddButton(info, level)

            info.notCheckable = false

            for _,f in ipairs(flags) do
                info.text = LM_UIFilter.GetFlagText(f)
                info.arg1 = f
                info.func = function (_, _, _, v)
                        LM_UIFilter.SetFlagFilter(f, v)
                        LiteMountOptionsMounts.refresh()
                    end
                info.checked = function ()
                        return LM_UIFilter.IsFlagChecked(f)
                    end
                UIDropDownMenu_AddButton(info, level)
            end
        end
    end
end

function LiteMountOptionsMountsFilterDropDown_OnLoad(self)
    UIDropDownMenu_Initialize(self, LiteMountOptionsMountsFilterDropDown_Initialize, "MENU")
end

local function UpdateAllSelected(mounts)

    if not mounts then
        mounts = LM_UIFilter.GetFilteredMountList()
    end

    local allEnabled = 1
    local allDisabled = 1

    for _,m in ipairs(mounts) do
        if LM_Options:IsExcludedMount(m) then
            allEnabled = 0
        else
            allDisabled = 0
        end
    end

    local checkedTexture = LiteMountOptionsMounts.AllSelect:GetCheckedTexture()
    if allDisabled == 1 then
        LiteMountOptionsMounts.AllSelect:SetChecked(false)
    else
        LiteMountOptionsMounts.AllSelect:SetChecked(true)
        if allEnabled == 1 then
            checkedTexture:SetDesaturated(false)
        else
            checkedTexture:SetDesaturated(true)
        end
    end
end

local function UpdateMountButton(button, mount)
    button.mount = mount
    button.Icon:SetTexture(mount.icon)
    button.Name:SetText(mount.name)

    if not InCombatLockdown() then
        for k,v in pairs(mount:GetSecureAttributes()) do
            button.DragButton:SetAttribute(k, v)
        end
    end

    if not mount.isCollected then
        button.Name:SetFontObject("GameFontDisable")
        button.Icon:SetDesaturated(true)
    else
        button.Name:SetFontObject("GameFontNormal")
        button.Icon:SetDesaturated(false)
    end

    if LM_Options:IsExcludedMount(mount) then
        button.Enabled:SetChecked(false)
    else
        button.Enabled:SetChecked(true)
    end

    button.Enabled.SetValue =
        function (self, setting)
            EnableDisableMount(button.mount, setting)
            self:GetScript("OnEnter")(self)
            UpdateAllSelected()
        end

    if GameTooltip:GetOwner() == button.Enabled then
        button.Enabled:GetScript("OnEnter")(button.Enabled)
    end

end

function LiteMountOptions_AllSelect_OnClick(self)
    local mounts = LM_UIFilter.GetFilteredMountList()

    local on

    if self:GetChecked() then
        on = "1"
    else
        on = "0"
    end

    for _,m in ipairs(mounts) do
        EnableDisableMount(m, on)
    end

    self:GetScript("OnEnter")(self)
    LiteMountOptionsMounts.refresh()

end

local function UpdateMountScroll(self)

    -- Because the Icon is a SecureActionButton and a child of the scroll
    -- buttons, we can't show or hide them in combat. Rather than throw a
    -- LUA error, it's better just not to do anything at all.

    if InCombatLockdown() then return end

    local offset = HybridScrollFrame_GetOffset(self)

    -- UpdateCount = UpdateCount + 1
    -- LM_Debug(format("UpdateCount %d", UpdateCount))

    if not self.buttons then return end

    local mounts = LM_UIFilter.GetFilteredMountList()

    for i, button in ipairs(self.buttons) do
        local index = offset + i
        if index <= #mounts then
            UpdateMountButton(button, mounts[index])
            button:Show()
        else
            button:Hide()
        end
    end

    UpdateAllSelected(mounts)

    local totalHeight = self.buttonHeight * #mounts
    local shownHeight = self.buttonHeight * #self.buttons

    HybridScrollFrame_Update(self, totalHeight, shownHeight)
end

function LiteMountOptionsScrollFrame_OnSizeChanged(self, w, h)
    CreateMoreButtons(self)
    self.stepSize = self.buttonHeight
end

function LiteMountOptionsFlagButton_OnEnter(self)
    if self.flag and rawget(L, self.flag) ~= nil then
        GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
        GameTooltip:AddLine(L[self.flag])
        GameTooltip:Show()
    end
end

function LiteMountOptionsFlagButton_OnLeave(self)
    if GameTooltip:GetOwner() == self then
        GameTooltip:Hide()
    end
end

local function UpdateFlagScroll(self)
    local offset = HybridScrollFrame_GetOffset(self)
    local buttons = self.buttons

    local allFlags = LM_Options:GetAllFlags()
    local totalHeight = (#allFlags + 1) * buttons[1]:GetHeight()
    local displayedHeight = #buttons * buttons[1]:GetHeight()

    local showAddButton

    for i = 1, #buttons do
        button = buttons[i]
        index = offset + i
        if index <= #allFlags then
            local flagText = allFlags[index]
            if LM_Options:IsPrimaryFlag(allFlags[index]) then
                flagText = ITEM_QUALITY_COLORS[2].hex .. flagText .. FONT_COLOR_CODE_CLOSE
                button.DeleteButton:Hide()
            else
                button.DeleteButton:Show()
            end
            button.Text:SetFormattedText(flagText)
            button.Text:Show()
            button:Show()
            button.flag = allFlags[index]
        elseif index == #allFlags + 1 then
            button.Text:Hide()
            button.DeleteButton:Hide()
            button:Show()
            button.flag = nil
            self.AddFlagButton:SetParent(button)
            self.AddFlagButton:ClearAllPoints()
            self.AddFlagButton:SetPoint("CENTER")
            self.AddFlagButton:SetWidth(self:GetWidth())
            button.DeleteButton:Hide()
            showAddButton = true
        else
            button:Hide()
            button.DeleteButton:Hide()
            button.flag = nil
        end
    end

    self.AddFlagButton:SetShown(showAddButton)

    HybridScrollFrame_Update(self, totalHeight, displayedHeight)
end

function LiteMountOptionsMountScroll_OnLoad(self)
    self.buttonTemplate = "LiteMountOptionsMountButtonTemplate"
    self.update = function () UpdateMountScroll(self) end
    local track = _G[self.scrollBar:GetName().."Track"]
    track:Hide()
end

function LiteMountOptionsFlagScroll_OnLoad(self)
    self.buttonTemplate = "LiteMountOptionsFlagButtonTemplate"
    self.update = function () UpdateFlagScroll(self) end
    local track = _G[self.scrollBar:GetName().."Track"]
    track:Hide()
end

function LiteMountOptionsMounts_OnLoad(self)

    -- Because we're the wrong size at the moment we'll only have 1 button
    CreateMoreButtons(self.FlagScroll)
    CreateMoreButtons(self.MountScroll)

    self.FlagScroll.update = UpdateFlagScroll

    self.name = MOUNTS
    self.default = function ()
            for m in LM_PlayerMounts:Iterate() do
                LM_Options:ResetMountFlags(m)
            end
            LM_Options:SetExcludedMounts({})
            self.refresh()
        end

    self.refresh = function ()
        UpdateMountScroll(self.MountScroll)
        UpdateFlagScroll(self.FlagScroll)
    end

    LiteMountOptionsPanel_OnLoad(self)
end

function LiteMountOptionsMounts_OnShow(self)

    -- UpdateCount, FPCount = 0, 0
    LM_PlayerMounts:RefreshMounts()

    self.refresh()

    LiteMountOptionsPanel_OnShow(self)
end

function LiteMountOptionsMounts_OnHide(self)
end

