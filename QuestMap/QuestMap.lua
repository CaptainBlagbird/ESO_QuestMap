--[[

Quest Map
by CaptainBlagbird
https://github.com/CaptainBlagbird

--]]

-- Libraries
local LMP = LibStub("LibMapPins-1.0")

-- Constants
local PIN_TYPE_QUEST_GIVER = "QuestGiver"
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
		
		-- TODO: Handle doubles
		
		completed[id] = true
	end
	
	return completed
end

-- Callback function which is called every time another map is viewed, creates quest pins
local function MapCallback()
	if not LMP:IsEnabled(PIN_TYPE_QUEST_GIVER) or (GetMapType() > MAPTYPE_ZONE) then return end
	
	-- Get completed quests
	local completed = GetCompletedQuests()
	-- Get currently displayed zone and subzone from texture
	local zone = LMP:GetZoneAndSubzone(LMP_FORMAT_ZONE_SINGLE_STRING)
	-- Get quest list for that zone from database
	local questslist = QuestMap:GetQuestList(zone)
	-- For each uncompleted quest, create a map pin with the quest name
	for _, quests in ipairs(questslist) do
		if not completed[quests.id] then
			local name = QuestMap:GetQuestName(quests.id)
			if name ~= "" then
				LMP:CreatePin(PIN_TYPE_QUEST_GIVER, {name}, quests.x, quests.y)
			end
		end
	end
end

-- Event handler function for EVENT_PLAYER_ACTIVATED
local function OnPlayerActivated(event)	
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
	-- Pin display style
	local pinLayout = { level = 40, texture = "QuestMap/icons/pin.dds", size = 38 }
	-- Add a new pin type for quest givers with previously defined style
	LMP:AddPinType(PIN_TYPE_QUEST_GIVER, MapCallback, nil, pinLayout, pinTooltipCreator)
	-- Add checkbox to map filters
	LMP:AddPinFilter(PIN_TYPE_QUEST_GIVER, "Quest givers")
	
	EVENT_MANAGER:UnregisterForEvent(QuestMap.name, EVENT_PLAYER_ACTIVATED)
end


-- Registering the event handler functions for the events
EVENT_MANAGER:RegisterForEvent(QuestMap.name, EVENT_PLAYER_ACTIVATED, OnPlayerActivated)