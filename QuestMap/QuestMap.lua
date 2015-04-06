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

local function MapCallback()
	if not LMP:IsEnabled(PIN_TYPE_QUEST_GIVER) or (GetMapType() > MAPTYPE_ZONE) then return end
	
	-- Get currently displayed zone and subzone from texture
	local zone = LMP:GetZoneAndSubzone(LMP_FORMAT_ZONE_SINGLE_STRING)
	-- Get quest list for that zone from database
	local questslist = QuestMap:GetQuestList(zone)
	-- For each quest, create a map pin with the quest name
	for _, quests in ipairs(questslist) do
		local name = {QuestMap:GetQuestName(quests.id)}
		LMP:CreatePin(PIN_TYPE_QUEST_GIVER, name, quests.x, quests.y)
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