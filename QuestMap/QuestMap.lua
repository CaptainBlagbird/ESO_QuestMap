--[[

Quest Map
by CaptainBlagbird
https://github.com/CaptainBlagbird

--]]

-- Libraries
local LMP = LibStub("LibMapPins-1.0")

-- Constants
local PIN_TYPE_QUEST_GIVER = "QuestGiver"
local PIN_TYPE_QUEST_GIVER_HIDDEN = "QuestGiver_hidden"
local LMP_FORMAT_ZONE_TWO_STRINGS = 1
local LMP_FORMAT_ZONE_SINGLE_STRING = 2

-- Addon info
QuestMap = {}
QuestMap.name = "Quest Map"

local function GetCompletedQuests()
	local completed = {}
	
	-- Get all completed quests
	while true do
		-- Get next completed quest. If it was the last, break loop
		id = GetNextCompletedQuestId(id)
		if id == nil then break end
		
		completed[id] = true
	end
	
	return completed
end

-- Callback function which is called every time another map is viewed, creates quest pins
local function MapCallbackQuestPins(pinType)
	if not LMP:IsEnabled(PIN_TYPE_QUEST_GIVER) and not LMP:IsEnabled(PIN_TYPE_QUEST_GIVER_HIDDEN) then return end
	if GetMapType() > MAPTYPE_ZONE then return end
	
	-- Get completed quests
	local completed = GetCompletedQuests()
	-- Get currently displayed zone and subzone from texture
	local zone = LMP:GetZoneAndSubzone(LMP_FORMAT_ZONE_SINGLE_STRING)
	-- Get quest list for that zone from database
	local questslist = QuestMap:GetQuestList(zone)
	-- For each uncompleted quest, create a map pin with the quest name
	for _, quests in ipairs(questslist) do
		if not completed[quests.id] then
			-- Get quest name and only continue if string isn't empty
			local name = QuestMap:GetQuestName(quests.id)
			if name ~= "" then
				-- Create table with name and id (only name will be visible in tooltip because key for id is "id" and not index
				local pinInfo = {name}
				pinInfo.id = quests.id
				-- Create pins for both categorys, visible and hidden
				if QuestMap.settings.hiddenQuests[quests.id] == nil then
					if pinType == PIN_TYPE_QUEST_GIVER then
						LMP:CreatePin(PIN_TYPE_QUEST_GIVER, pinInfo, quests.x, quests.y)
					end
				else
					if pinType == PIN_TYPE_QUEST_GIVER_HIDDEN then
						LMP:CreatePin(PIN_TYPE_QUEST_GIVER_HIDDEN, pinInfo, quests.x, quests.y)
					end
				end
			end
		end
	end
end

-- Function to refresh pin appearance (e.g. from settings menu)
function QuestMap:RefreshPinLayout()
	LMP:SetLayoutKey(PIN_TYPE_QUEST_GIVER, "size", QuestMap.settings.pinSize)
	LMP:SetLayoutKey(PIN_TYPE_QUEST_GIVER, "level", QuestMap.settings.pinLevel)
	LMP:RefreshPins(PIN_TYPE_QUEST_GIVER)
	LMP:SetLayoutKey(PIN_TYPE_QUEST_GIVER_HIDDEN, "size", QuestMap.settings.pinSize)
	LMP:SetLayoutKey(PIN_TYPE_QUEST_GIVER_HIDDEN, "level", QuestMap.settings.pinLevel)
	LMP:RefreshPins(PIN_TYPE_QUEST_GIVER_HIDDEN)
end

-- Event handler function for EVENT_PLAYER_ACTIVATED
local function OnPlayerActivated(event)
	-- Set up SavedVariables table
	QuestMap.settings = ZO_SavedVars:New("QuestMapSettings", 1, nil, {})
	if QuestMap.settings.pinSize == nil then QuestMap.settings.pinSize = 25 end
	if QuestMap.settings.pinLevel == nil then QuestMap.settings.pinLevel = 40 end
	if QuestMap.settings.hiddenQuests == nil then QuestMap.settings.hiddenQuests = {} end
	if QuestMap.settings.pinFilters == nil then QuestMap.settings.pinFilters = {[PIN_TYPE_QUEST_GIVER] = true, [PIN_TYPE_QUEST_GIVER_HIDDEN] = false} end
	if QuestMap.settings.displayClickMsg == nil then QuestMap.settings.displayClickMsg = true end
	
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
	-- Add a new pin types for quest givers
	local pinLayout = {level = QuestMap.settings.pinLevel, texture = "QuestMap/icons/pinQuestUncompleted.dds", size = QuestMap.settings.pinSize}
	LMP:AddPinType(PIN_TYPE_QUEST_GIVER, function() MapCallbackQuestPins(PIN_TYPE_QUEST_GIVER) end, nil, pinLayout, pinTooltipCreator)
	pinLayout = {level = QuestMap.settings.pinLevel, texture = "QuestMap/icons/pinQuestCompleted.dds", size = QuestMap.settings.pinSize}
	LMP:AddPinType(PIN_TYPE_QUEST_GIVER_HIDDEN, function() MapCallbackQuestPins(PIN_TYPE_QUEST_GIVER_HIDDEN) end, nil, pinLayout, pinTooltipCreator)
	-- Add checkboxes to map filters
	LMP:AddPinFilter(PIN_TYPE_QUEST_GIVER, "Quest givers", false, QuestMap.settings.pinFilters)
	if not QuestMap.settings.pinFilters[PIN_TYPE_QUEST_GIVER] then LMP:Disable(PIN_TYPE_QUEST_GIVER) end
	LMP:AddPinFilter(PIN_TYPE_QUEST_GIVER_HIDDEN, "Quest givers (manually hidden)", false, QuestMap.settings.pinFilters)
	if not QuestMap.settings.pinFilters[PIN_TYPE_QUEST_GIVER_HIDDEN] then LMP:Disable(PIN_TYPE_QUEST_GIVER_HIDDEN) end
	-- Add click action for pins
	LMP:SetClickHandlers(PIN_TYPE_QUEST_GIVER, {[1] = {name = function(pin) return zo_strformat("Hide quest |cFFFFFF<<1>>|r", QuestMap:GetQuestName(pin.m_PinTag.id)) end,
		show = function(pin) return true end,
		duplicates = function(pin1, pin2) return pin1.m_PinTag.id == pin2.m_PinTag.id end,
		callback = function(pin)
			-- Add to table which holds all the hidden quests
			QuestMap.settings.hiddenQuests[pin.m_PinTag.id] = QuestMap:GetQuestName(pin.m_PinTag.id)
			if QuestMap.settings.displayClickMsg then d("Quest hidden ("..QuestMap:GetQuestName(pin.m_PinTag.id)..")") end
			LMP:RefreshPins(PIN_TYPE_QUEST_GIVER)
			LMP:RefreshPins(PIN_TYPE_QUEST_GIVER_HIDDEN)
		end}})
	LMP:SetClickHandlers(PIN_TYPE_QUEST_GIVER_HIDDEN, {[1] = {name = function(pin) return zo_strformat("Unhide quest |cFFFFFF<<1>>|r", QuestMap:GetQuestName(pin.m_PinTag.id)) end,
		show = function(pin) return true end,
		duplicates = function(pin1, pin2) return pin1.m_PinTag.id == pin2.m_PinTag.id end,
		callback = function(pin)
			-- Remove from table which holds all the hidden quests
			QuestMap.settings.hiddenQuests[pin.m_PinTag.id] = nil
			if QuestMap.settings.displayClickMsg then d("Quest unhidden ("..QuestMap:GetQuestName(pin.m_PinTag.id)..")") end
			LMP:RefreshPins(PIN_TYPE_QUEST_GIVER)
			LMP:RefreshPins(PIN_TYPE_QUEST_GIVER_HIDDEN)
		end}})
	
	EVENT_MANAGER:UnregisterForEvent(QuestMap.name, EVENT_PLAYER_ACTIVATED)
end

-- Event handler function for EVENT_QUEST_COMPLETE
local function OnQuestComplete(event, name, lvl, pXP, cXP, rnk, pPoints, cPoints)
	-- Refresh map pins
	MapCallbackQuestPins()
	LMP:RefreshPins(PIN_TYPE_QUEST_GIVER)
	LMP:RefreshPins(PIN_TYPE_QUEST_GIVER_HIDDEN)
end


-- Registering the event handler functions for the events
EVENT_MANAGER:RegisterForEvent(QuestMap.name, EVENT_PLAYER_ACTIVATED, OnPlayerActivated)
EVENT_MANAGER:RegisterForEvent(QuestMap.name, EVENT_QUEST_COMPLETE,   OnQuestComplete)