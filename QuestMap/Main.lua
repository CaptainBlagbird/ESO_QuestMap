--[[

Quest Map
by CaptainBlagbird
https://github.com/CaptainBlagbird

--]]

-- Libraries
local LMP = LibStub("LibMapPins-1.0")

-- Constants
local LMP_FORMAT_ZONE_TWO_STRINGS = false
local LMP_FORMAT_ZONE_SINGLE_STRING = true
-- Transfer from init
local PIN_TYPE_QUEST_UNCOMPLETED = QuestMap.pinType.uncompleted
local PIN_TYPE_QUEST_COMPLETED   = QuestMap.pinType.completed
local PIN_TYPE_QUEST_HIDDEN      = QuestMap.pinType.hidden
local PIN_TYPE_QUEST_CADWELL     = QuestMap.pinType.cadwell
local PIN_TYPE_QUEST_SKILL       = QuestMap.pinType.skill


-- Library hack to be able to detect when a map pin filter gets unchecked (overwrite RemovePins function)
local function SetFilterToggleCallback(pinType, positiveToggle, func)
	if type(func) ~= "function" or (type(pinType) ~= "string" and type(pinType) ~= "number") then return end
	-- Convert pinTypeString to pinTypeId
	if type(pinType) == "string" then
		pinType = _G[pinType]
	end
	
	local isFirstRun = false
	if LMP.FilterToggleHandlers == nil then
		isFirstRun = true
		LMP.FilterToggleHandlers = {}
		LMP.FilterToggleHandlers.positiveToggle = {}
		LMP.FilterToggleHandlers.negativeToggle = {}
	end
	
	-- Add to list
	if positiveToggle then
		LMP.FilterToggleHandlers.positiveToggle[pinType] = func
	else
		LMP.FilterToggleHandlers.negativeToggle[pinType] = func
	end
	
	if isFirstRun then
		-- Update SetCustomPinEnabled function
		local oldSetCustomPinEnabled = LMP.pinManager.SetCustomPinEnabled
		local function newSetCustomPinEnabled(t, pinTypeId, enabled)
			oldSetCustomPinEnabled(t, pinTypeId, enabled)
			-- Run callback function
			if enabled then
				-- Filter enabled
				if LMP.FilterToggleHandlers.positiveToggle[pinType] ~= nil then
					LMP.FilterToggleHandlers.positiveToggle[pinType]()
				end
			else
				-- Filter disabled
				if LMP.FilterToggleHandlers.negativeToggle[pinType] ~= nil then
					LMP.FilterToggleHandlers.negativeToggle[pinType]()
				end
			end
		end
		LMP.pinManager.SetCustomPinEnabled = newSetCustomPinEnabled
	end
end

-- Function to print text to the chat window including the addon name
local function p(s)
	-- Add addon name to message
	s = "|c70C0DE["..QuestMap.name.."]|r "..s
	-- Replace regular color (yellow) with ESO golden in this string
	s = s:gsub("|r", "|cC5C29E")
	-- Display message
	d(s)
end

-- Function to get an id list of all the completed quests
local function GetCompletedQuests()
	local completed = {}
	local id
	-- Get all completed quests
	while true do
		-- Get next completed quest. If it was the last, break loop
		id = GetNextCompletedQuestId(id)
		if id == nil then break end
		completed[id] = true
	end
	return completed
end

-- Function to remove completed quests from list of manually hidden quests
local function RemoveQuestsCompletedFromHidden()
	local id
	-- Get all completed quests
	while true do
		-- Get next completed quest. If it was the last, break loop
		id = GetNextCompletedQuestId(id)
		if id == nil then break end
		-- If current quest was in the list of manually hidden quests, remove it from there
		if QuestMap.settings.hiddenQuests[id] ~= nil then QuestMap.settings.hiddenQuests[id] = nil end
	end
end

-- Function to refresh pins
function QuestMap:RefreshPins()
	LMP:RefreshPins(PIN_TYPE_QUEST_COMPLETED)
	LMP:RefreshPins(PIN_TYPE_QUEST_UNCOMPLETED)
	LMP:RefreshPins(PIN_TYPE_QUEST_HIDDEN)
end

-- Callback function which is called every time another map is viewed, creates quest pins
-- pinType = nil for all quest pin types
local function MapCallbackQuestPins(pinType)
	if not LMP:IsEnabled(PIN_TYPE_QUEST_UNCOMPLETED)
	and not LMP:IsEnabled(PIN_TYPE_QUEST_COMPLETED)
	and not LMP:IsEnabled(PIN_TYPE_QUEST_HIDDEN) then
		return
	end
	if GetMapType() > MAPTYPE_ZONE then return end
	
	-- Get completed quests
	local completed = GetCompletedQuests()
	-- Get currently displayed zone and subzone from texture
	local zone = LMP:GetZoneAndSubzone(LMP_FORMAT_ZONE_SINGLE_STRING)
	-- Get quest list for that zone from database
	local questlist = QuestMap:GetQuestList(zone)
	-- For each quest, create a map pin with the quest name
	for _, quest in ipairs(questlist) do
		-- Get quest name and only continue if string isn't empty
		local name = QuestMap:GetQuestName(quest.id)
		if name ~= "" then
			-- Get quest type info
			local isSkillQuest, isCadwellQuest = QuestMap:GetQuestType(quest.id)
			-- Create table with name and id (only name will be visible in tooltip because key for id is "id" and not index
			local pinInfo = {"|cFFFFFF"..name}
			pinInfo.id = quest.id
			-- Add quest type info to tooltip data
			if isSkillQuest or isCadwellQuest then
				pinInfo[2] = "["
				if isSkillQuest then pinInfo[2] = pinInfo[2]..GetString(QUESTMAP_SKILL) end
				if isSkillQuest and isCadwellQuest then pinInfo[2] = pinInfo[2]..", " end
				if isCadwellQuest then pinInfo[2] = pinInfo[2]..GetString(QUESTMAP_CADWELL) end
				pinInfo[2] = pinInfo[2].."]"
			end
			-- Create pins for corresponding category
			if completed[quest.id] then
				if pinType == PIN_TYPE_QUEST_COMPLETED or pinType == nil then
					if not LMP:IsEnabled(PIN_TYPE_QUEST_CADWELL) and not LMP:IsEnabled(PIN_TYPE_QUEST_SKILL)
					or LMP:IsEnabled(PIN_TYPE_QUEST_CADWELL) and isCadwellQuest
					or LMP:IsEnabled(PIN_TYPE_QUEST_SKILL) and isSkillQuest then
						pinInfo[1] = pinInfo[1].." |c888888(X)"
						LMP:CreatePin(PIN_TYPE_QUEST_COMPLETED, pinInfo, quest.x, quest.y)
					end
				end
			else  -- Uncompleted
				if QuestMap.settings.hiddenQuests[quest.id] == nil then
					if pinType == PIN_TYPE_QUEST_UNCOMPLETED or pinType == nil then
						if not LMP:IsEnabled(PIN_TYPE_QUEST_CADWELL) and not LMP:IsEnabled(PIN_TYPE_QUEST_SKILL)
						or LMP:IsEnabled(PIN_TYPE_QUEST_CADWELL) and isCadwellQuest
						or LMP:IsEnabled(PIN_TYPE_QUEST_SKILL) and isSkillQuest then
							pinInfo[1] = pinInfo[1].." |c888888(  )"
							LMP:CreatePin(PIN_TYPE_QUEST_UNCOMPLETED, pinInfo, quest.x, quest.y)
						end
					end
				else  -- Manually hidden
					if pinType == PIN_TYPE_QUEST_HIDDEN or pinType == nil then
						if not LMP:IsEnabled(PIN_TYPE_QUEST_CADWELL) and not LMP:IsEnabled(PIN_TYPE_QUEST_SKILL)
						or LMP:IsEnabled(PIN_TYPE_QUEST_CADWELL) and isCadwellQuest
						or LMP:IsEnabled(PIN_TYPE_QUEST_SKILL) and isSkillQuest then
							pinInfo[1] = pinInfo[1].." |c888888(+)"
							LMP:CreatePin(PIN_TYPE_QUEST_HIDDEN, pinInfo, quest.x, quest.y)
						end
					end
				end
			end
		end
	end
end

-- Function to refresh pin appearance (e.g. from settings menu)
function QuestMap:RefreshPinLayout()
	LMP:SetLayoutKey(PIN_TYPE_QUEST_UNCOMPLETED, "size", QuestMap.settings.pinSize)
	LMP:SetLayoutKey(PIN_TYPE_QUEST_UNCOMPLETED, "level", QuestMap.settings.pinLevel)
	LMP:RefreshPins(PIN_TYPE_QUEST_UNCOMPLETED)
	LMP:SetLayoutKey(PIN_TYPE_QUEST_COMPLETED, "size", QuestMap.settings.pinSize)
	LMP:SetLayoutKey(PIN_TYPE_QUEST_COMPLETED, "level", QuestMap.settings.pinLevel)
	LMP:RefreshPins(PIN_TYPE_QUEST_COMPLETED)
	LMP:SetLayoutKey(PIN_TYPE_QUEST_HIDDEN, "size", QuestMap.settings.pinSize)
	LMP:SetLayoutKey(PIN_TYPE_QUEST_HIDDEN, "level", QuestMap.settings.pinLevel)
	LMP:RefreshPins(PIN_TYPE_QUEST_HIDDEN)
end

-- Function to refresh pin filters (e.g. from settings menu)
function QuestMap:RefreshPinFilters()
	LMP:SetEnabled(PIN_TYPE_QUEST_UNCOMPLETED, QuestMap.settings.pinFilters[PIN_TYPE_QUEST_UNCOMPLETED])
	LMP:SetEnabled(PIN_TYPE_QUEST_COMPLETED,   QuestMap.settings.pinFilters[PIN_TYPE_QUEST_COMPLETED])
	LMP:SetEnabled(PIN_TYPE_QUEST_HIDDEN,      QuestMap.settings.pinFilters[PIN_TYPE_QUEST_HIDDEN])
	LMP:SetEnabled(PIN_TYPE_QUEST_SKILL,       QuestMap.settings.pinFilters[PIN_TYPE_QUEST_SKILL])
	LMP:SetEnabled(PIN_TYPE_QUEST_CADWELL,     QuestMap.settings.pinFilters[PIN_TYPE_QUEST_CADWELL])
end

-- Event handler function for EVENT_PLAYER_ACTIVATED
local function OnPlayerActivated(event)
	-- Set up SavedVariables table
	QuestMap.settings = ZO_SavedVars:New("QuestMapSettings", 1, nil, QuestMap.savedVarsDefault)
	
	-- Get tootip of each individual pin
	local pinTooltipCreator = {
		creator = function(pin)
			local _, pinTag = pin:GetPinTypeAndTag()
			for _, lineData in ipairs(pinTag) do
				SetTooltipText(InformationTooltip, lineData)
			end
		end,
		tooltip = 1, -- Delete the line above and uncomment this line for Update 6
	}
	-- Add new pin types for quests
	local pinLayout = {level = QuestMap.settings.pinLevel, texture = "QuestMap/icons/pinQuestUncompleted.dds", size = QuestMap.settings.pinSize}
	LMP:AddPinType(PIN_TYPE_QUEST_UNCOMPLETED, function() MapCallbackQuestPins(PIN_TYPE_QUEST_UNCOMPLETED) end, nil, pinLayout, pinTooltipCreator)
	pinLayout = {level = QuestMap.settings.pinLevel, texture = "QuestMap/icons/pinQuestCompleted.dds", size = QuestMap.settings.pinSize}
	LMP:AddPinType(PIN_TYPE_QUEST_COMPLETED, function() MapCallbackQuestPins(PIN_TYPE_QUEST_COMPLETED) end, nil, pinLayout, pinTooltipCreator)
	LMP:AddPinType(PIN_TYPE_QUEST_HIDDEN, function() MapCallbackQuestPins(PIN_TYPE_QUEST_HIDDEN) end, nil, pinLayout, pinTooltipCreator)
	-- Add map filters
	LMP:AddPinFilter(PIN_TYPE_QUEST_UNCOMPLETED, GetString(QUESTMAP_QUESTS).." ("..GetString(QUESTMAP_UNCOMPLETED)..")", true, QuestMap.settings.pinFilters)
	LMP:AddPinFilter(PIN_TYPE_QUEST_COMPLETED, GetString(QUESTMAP_QUESTS).." ("..GetString(QUESTMAP_COMPLETED)..")", true, QuestMap.settings.pinFilters)
	LMP:AddPinFilter(PIN_TYPE_QUEST_HIDDEN, GetString(QUESTMAP_QUESTS).." ("..GetString(QUESTMAP_HIDDEN)..")", true, QuestMap.settings.pinFilters)
	QuestMap:RefreshPinFilters()
	-- Add subfilters (filters for filters); AddPinType needed or else the filters wont show up
	LMP:AddPinType(PIN_TYPE_QUEST_CADWELL, function() end, nil, pinLayout, pinTooltipCreator)
	LMP:AddPinType(PIN_TYPE_QUEST_SKILL, function() end, nil, pinLayout, pinTooltipCreator)
	LMP:AddPinFilter(PIN_TYPE_QUEST_CADWELL, "|c888888"..GetString(QUESTMAP_QUEST_SUBFILTER).." ("..GetString(QUESTMAP_CADWELL)..")", true, QuestMap.settings.pinFilters)
	LMP:AddPinFilter(PIN_TYPE_QUEST_SKILL, "|c888888"..GetString(QUESTMAP_QUEST_SUBFILTER).." ("..GetString(QUESTMAP_SKILL)..")", true, QuestMap.settings.pinFilters)
	-- Set callback functions for (un)checking subfilters
	SetFilterToggleCallback(PIN_TYPE_QUEST_CADWELL, true,  function() QuestMap:RefreshPins() end)
	SetFilterToggleCallback(PIN_TYPE_QUEST_CADWELL, false, function() QuestMap:RefreshPins() end)
	SetFilterToggleCallback(PIN_TYPE_QUEST_SKILL,   true,  function() QuestMap:RefreshPins() end)
	SetFilterToggleCallback(PIN_TYPE_QUEST_SKILL,   false, function() QuestMap:RefreshPins() end)
	-- Add click action for pins
	LMP:SetClickHandlers(PIN_TYPE_QUEST_UNCOMPLETED, {[1] = {name = function(pin) return zo_strformat(GetString(QUESTMAP_HIDE).." |cFFFFFF<<1>>|r", QuestMap:GetQuestName(pin.m_PinTag.id)) end,
		show = function(pin) return true end,
		duplicates = function(pin1, pin2) return pin1.m_PinTag.id == pin2.m_PinTag.id end,
		callback = function(pin)
			-- Add to table which holds all the hidden quests
			QuestMap.settings.hiddenQuests[pin.m_PinTag.id] = QuestMap:GetQuestName(pin.m_PinTag.id)
			if QuestMap.settings.displayClickMsg then p(GetString(QUESTMAP_MSG_HIDDEN)..": |cFFFFFF"..QuestMap:GetQuestName(pin.m_PinTag.id)) end
			LMP:RefreshPins(PIN_TYPE_QUEST_UNCOMPLETED)
			LMP:RefreshPins(PIN_TYPE_QUEST_HIDDEN)
		end}})
	LMP:SetClickHandlers(PIN_TYPE_QUEST_COMPLETED, {[1] = {name = function(pin) return zo_strformat("Quest |cFFFFFF<<1>>|r", QuestMap:GetQuestName(pin.m_PinTag.id)) end,
		show = function(pin) return true end,
		duplicates = function(pin1, pin2) return pin1.m_PinTag.id == pin2.m_PinTag.id end,
		callback = function(pin)
			-- Do nothing
		end}})
	LMP:SetClickHandlers(PIN_TYPE_QUEST_HIDDEN, {[1] = {name = function(pin) return zo_strformat(GetString(QUESTMAP_UNHIDE).." |cFFFFFF<<1>>|r", QuestMap:GetQuestName(pin.m_PinTag.id)) end,
		show = function(pin) return true end,
		duplicates = function(pin1, pin2) return pin1.m_PinTag.id == pin2.m_PinTag.id end,
		callback = function(pin)
			-- Remove from table which holds all the hidden quests
			QuestMap.settings.hiddenQuests[pin.m_PinTag.id] = nil
			if QuestMap.settings.displayClickMsg then p(GetString(QUESTMAP_MSG_UNHIDDEN)..": |cFFFFFF"..QuestMap:GetQuestName(pin.m_PinTag.id)) end
			LMP:RefreshPins(PIN_TYPE_QUEST_UNCOMPLETED)
			LMP:RefreshPins(PIN_TYPE_QUEST_HIDDEN)
		end}})
	
	EVENT_MANAGER:UnregisterForEvent(QuestMap.name, EVENT_PLAYER_ACTIVATED)
end

-- Event handler function for EVENT_QUEST_COMPLETE
local function OnQuestComplete(event, name, lvl, pXP, cXP, rnk, pPoints, cPoints)
	-- Refresh map pins
	MapCallbackQuestPins()
	QuestMap:RefreshPins()
	-- Clean up list with hidden quests
	RemoveQuestsCompletedFromHidden()
end


-- Registering the event handler functions for the events
EVENT_MANAGER:RegisterForEvent(QuestMap.name, EVENT_PLAYER_ACTIVATED, OnPlayerActivated)
EVENT_MANAGER:RegisterForEvent(QuestMap.name, EVENT_QUEST_COMPLETE,   OnQuestComplete)