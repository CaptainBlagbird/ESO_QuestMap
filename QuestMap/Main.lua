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
local PIN_TYPE_QUEST_COMPLETED = QuestMap.pinType.completed
local PIN_TYPE_QUEST_HIDDEN = QuestMap.pinType.hidden


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
	return completed
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
	local questslist = QuestMap:GetQuestList(zone)
	-- For each quest, create a map pin with the quest name
	for _, quests in ipairs(questslist) do
		-- Get quest name and only continue if string isn't empty
		local name = QuestMap:GetQuestName(quests.id)
		if name ~= "" then
			-- Create table with name and id (only name will be visible in tooltip because key for id is "id" and not index
			local pinInfo = {"|cFFFFFF"..name}			
			pinInfo.id = quests.id
			-- Create pins for corresponding category
			if completed[quests.id] then
				if pinType == PIN_TYPE_QUEST_COMPLETED or pinType == nil then
					pinInfo[2] = "["..GetString(QUESTMAP_COMPLETED).."]"
					LMP:CreatePin(PIN_TYPE_QUEST_COMPLETED, pinInfo, quests.x, quests.y)
				end
			else
				if QuestMap.settings.hiddenQuests[quests.id] == nil then
					if pinType == PIN_TYPE_QUEST_UNCOMPLETED or pinType == nil then
						pinInfo[2] = "["..GetString(QUESTMAP_UNCOMPLETED).."]"
						LMP:CreatePin(PIN_TYPE_QUEST_UNCOMPLETED, pinInfo, quests.x, quests.y)
					end
				else
					if pinType == PIN_TYPE_QUEST_HIDDEN or pinType == nil then
						pinInfo[2] = "["..GetString(QUESTMAP_HIDDEN).."]"
						LMP:CreatePin(PIN_TYPE_QUEST_HIDDEN, pinInfo, quests.x, quests.y)
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
	-- Add a new pin types for quests
	local pinLayout = {level = QuestMap.settings.pinLevel, texture = "QuestMap/icons/pinQuestUncompleted.dds", size = QuestMap.settings.pinSize}
	LMP:AddPinType(PIN_TYPE_QUEST_UNCOMPLETED, function() MapCallbackQuestPins(PIN_TYPE_QUEST_UNCOMPLETED) end, nil, pinLayout, pinTooltipCreator)
	pinLayout = {level = QuestMap.settings.pinLevel, texture = "QuestMap/icons/pinQuestCompleted.dds", size = QuestMap.settings.pinSize}
	LMP:AddPinType(PIN_TYPE_QUEST_COMPLETED, function() MapCallbackQuestPins(PIN_TYPE_QUEST_COMPLETED) end, nil, pinLayout, pinTooltipCreator)
	LMP:AddPinType(PIN_TYPE_QUEST_HIDDEN, function() MapCallbackQuestPins(PIN_TYPE_QUEST_HIDDEN) end, nil, pinLayout, pinTooltipCreator)
	-- Add map filters
	LMP:AddPinFilter(PIN_TYPE_QUEST_UNCOMPLETED, "Quests ("..GetString(QUESTMAP_UNCOMPLETED)..")", true, QuestMap.settings.pinFilters)
	LMP:AddPinFilter(PIN_TYPE_QUEST_COMPLETED, "Quests ("..GetString(QUESTMAP_COMPLETED)..")", true, QuestMap.settings.pinFilters)
	LMP:AddPinFilter(PIN_TYPE_QUEST_HIDDEN, "Quests ("..GetString(QUESTMAP_HIDDEN)..")", true, QuestMap.settings.pinFilters)
	QuestMap:RefreshPinFilters()
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
	LMP:RefreshPins(PIN_TYPE_QUEST_UNCOMPLETED)
	LMP:RefreshPins(PIN_TYPE_QUEST_COMPLETED)
	LMP:RefreshPins(PIN_TYPE_QUEST_HIDDEN)
	-- Clean up list with hidden quests
	RemoveQuestsCompletedFromHidden()
end


-- Registering the event handler functions for the events
EVENT_MANAGER:RegisterForEvent(QuestMap.name, EVENT_PLAYER_ACTIVATED, OnPlayerActivated)
EVENT_MANAGER:RegisterForEvent(QuestMap.name, EVENT_QUEST_COMPLETE,   OnQuestComplete)