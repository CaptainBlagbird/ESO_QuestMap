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
local PIN_TYPE_QUEST_STARTED     = QuestMap.pinType.started
local PIN_TYPE_QUEST_CADWELL     = QuestMap.pinType.cadwell
local PIN_TYPE_QUEST_SKILL       = QuestMap.pinType.skill
-- Local variables
local completedQuests = {}
local startedQuests = {}


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

-- Function to check for empty table
local function isEmpty(t)
	if next(t) == nil then
		return true
	else
		return false
	end
end

-- Function to print text to the chat window including the addon name
local function p(s)
	-- Add addon name to message
	s = "|c70C0DE["..QuestMap.name.."]|r "..s
	-- Replace regular color (yellow) with ESO golden in this string
	s = s:gsub("|r", "|cC5C29E")
	-- Replace newline character with newline + ESO golden (because newline resets color to default yellow)
	s = s:gsub("\n", "\n|cC5C29E")
	-- Display message
	d(s)
end

-- Function to update the list of completed quests and also clean up the lists of started/hidden quests
local function UpdateQuestData()
	completedQuests = {}
	local id
	-- There currently are < 6000 quests, but some can be completed multiple times.
	-- 10000 should be more than enough to get all completed quests and still avoid an endless loop.
	for i=0, 10000 do
		-- Get next completed quest. If it was the last, break loop
		id = GetNextCompletedQuestId(id)
		if id == nil then break end
		-- Add the quest to the list
		completedQuests[id] = true
		-- Clean up list of started quests
		if startedQuests[id] ~= nil then startedQuests[id] = nil end
		-- Clean up list of hidden quests
		if QuestMap.settings.hiddenQuests[id] ~= nil then QuestMap.settings.hiddenQuests[id] = nil end
	end
end

-- Function to refresh pins
function QuestMap:RefreshPins()
	LMP:RefreshPins(PIN_TYPE_QUEST_COMPLETED)
	LMP:RefreshPins(PIN_TYPE_QUEST_UNCOMPLETED)
	LMP:RefreshPins(PIN_TYPE_QUEST_HIDDEN)
	LMP:RefreshPins(PIN_TYPE_QUEST_STARTED)
end

-- Callback function which is called every time another map is viewed, creates quest pins
local function MapCallbackQuestPins(pinType)
	if not LMP:IsEnabled(PIN_TYPE_QUEST_UNCOMPLETED)
	and not LMP:IsEnabled(PIN_TYPE_QUEST_COMPLETED)
	and not LMP:IsEnabled(PIN_TYPE_QUEST_HIDDEN)
	and not LMP:IsEnabled(PIN_TYPE_QUEST_STARTED) then
		return
	end
	if GetMapType() > MAPTYPE_ZONE then return end
	
	-- Get currently displayed zone and subzone from texture
	local zone = LMP:GetZoneAndSubzone(LMP_FORMAT_ZONE_SINGLE_STRING)
	-- Get quest list for that zone from database
	local questlist = QuestMap:GetQuestList(zone)
	
	-- Also get quests from subzones
	local subzone_questlist = {}
	local subzone_questlist_offset = 0
	local subzonelist = QuestMap:GetSubzoneList(zone)
	for subzone_name, subzone in pairs(subzonelist) do
		subzone_questlist_offset = #subzone_questlist
		-- Get each quest of the subzone
		local ql = QuestMap:GetQuestList(subzone_name)
		for i, q in ipairs(ql) do
			-- Add offset so we don't overwrite the quests of the previous subzone in the big table
			i = i + subzone_questlist_offset
			-- Prepare entry in big table
			subzone_questlist[i] = {}
			-- Copy values to big table
			if not isEmpty(q) then
				subzone_questlist[i].id = q.id
				-- Convert to correct position (subzone --> zone)
				subzone_questlist[i].x = (q.x * subzone.zoom_factor) + subzone.x
				subzone_questlist[i].y = (q.y * subzone.zoom_factor) + subzone.y
			end
		end
	end
	
	-- For each quest, create a map pin with the quest name
	for i=1,#questlist+#subzone_questlist do
		local quest
		if i <= #questlist then
			quest = questlist[i]
		else
			quest = subzone_questlist[i-#questlist]
		end
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
			if completedQuests[quest.id] then
				if pinType == PIN_TYPE_QUEST_COMPLETED then
					if not LMP:IsEnabled(PIN_TYPE_QUEST_CADWELL) and not LMP:IsEnabled(PIN_TYPE_QUEST_SKILL)
					or LMP:IsEnabled(PIN_TYPE_QUEST_CADWELL) and isCadwellQuest
					or LMP:IsEnabled(PIN_TYPE_QUEST_SKILL) and isSkillQuest then
						pinInfo[1] = pinInfo[1].." |c888888(X)"
						LMP:CreatePin(PIN_TYPE_QUEST_COMPLETED, pinInfo, quest.x, quest.y)
					end
				end
			else  -- Uncompleted
				if startedQuests[quest.id] ~= nil then  -- Started
					if pinType == PIN_TYPE_QUEST_STARTED then
						if not LMP:IsEnabled(PIN_TYPE_QUEST_CADWELL) and not LMP:IsEnabled(PIN_TYPE_QUEST_SKILL)
						or LMP:IsEnabled(PIN_TYPE_QUEST_CADWELL) and isCadwellQuest
						or LMP:IsEnabled(PIN_TYPE_QUEST_SKILL) and isSkillQuest then
							pinInfo[1] = pinInfo[1].." |c888888(  )"
							LMP:CreatePin(PIN_TYPE_QUEST_STARTED, pinInfo, quest.x, quest.y)
						end
					end
				elseif QuestMap.settings.hiddenQuests[quest.id] ~= nil then  -- Hidden
					if pinType == PIN_TYPE_QUEST_HIDDEN then
						if not LMP:IsEnabled(PIN_TYPE_QUEST_CADWELL) and not LMP:IsEnabled(PIN_TYPE_QUEST_SKILL)
						or LMP:IsEnabled(PIN_TYPE_QUEST_CADWELL) and isCadwellQuest
						or LMP:IsEnabled(PIN_TYPE_QUEST_SKILL) and isSkillQuest then
							pinInfo[1] = pinInfo[1].." |c888888(+)"
							LMP:CreatePin(PIN_TYPE_QUEST_HIDDEN, pinInfo, quest.x, quest.y)
						end
					end
				else
					if pinType == PIN_TYPE_QUEST_UNCOMPLETED then  -- Uncompleted only
						if not LMP:IsEnabled(PIN_TYPE_QUEST_CADWELL) and not LMP:IsEnabled(PIN_TYPE_QUEST_SKILL)
						or LMP:IsEnabled(PIN_TYPE_QUEST_CADWELL) and isCadwellQuest
						or LMP:IsEnabled(PIN_TYPE_QUEST_SKILL) and isSkillQuest then
							pinInfo[1] = pinInfo[1].." |c888888(  )"
							LMP:CreatePin(PIN_TYPE_QUEST_UNCOMPLETED, pinInfo, quest.x, quest.y)
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
	LMP:SetLayoutKey(PIN_TYPE_QUEST_STARTED, "size", QuestMap.settings.pinSize)
	LMP:SetLayoutKey(PIN_TYPE_QUEST_STARTED, "level", QuestMap.settings.pinLevel)
	LMP:RefreshPins(PIN_TYPE_QUEST_STARTED)
end

-- Function to refresh pin filters (e.g. from settings menu)
function QuestMap:RefreshPinFilters()
	LMP:SetEnabled(PIN_TYPE_QUEST_UNCOMPLETED, QuestMap.settings.pinFilters[PIN_TYPE_QUEST_UNCOMPLETED])
	LMP:SetEnabled(PIN_TYPE_QUEST_COMPLETED,   QuestMap.settings.pinFilters[PIN_TYPE_QUEST_COMPLETED])
	LMP:SetEnabled(PIN_TYPE_QUEST_HIDDEN,      QuestMap.settings.pinFilters[PIN_TYPE_QUEST_HIDDEN])
	LMP:SetEnabled(PIN_TYPE_QUEST_STARTED,     QuestMap.settings.pinFilters[PIN_TYPE_QUEST_STARTED])
	LMP:SetEnabled(PIN_TYPE_QUEST_SKILL,       QuestMap.settings.pinFilters[PIN_TYPE_QUEST_SKILL])
	LMP:SetEnabled(PIN_TYPE_QUEST_CADWELL,     QuestMap.settings.pinFilters[PIN_TYPE_QUEST_CADWELL])
end

-- Function to (un)hide all quests on the currently displayed map
local function SetQuestsInZoneHidden(str)
	usage = GetString(QUESTMAP_SLASH_USAGE)
	if type(str) ~= "string" then return end
	if ZO_WorldMap:IsHidden() then p(GetString(QUESTMAP_SLASH_MAPINFO)); return end
	local map = LMP:GetZoneAndSubzone(LMP_FORMAT_ZONE_SINGLE_STRING)
	
	-- Trim whitespaces from input string
	argument = str:gsub("^%s*(.-)%s*$", "%1")
	-- Convert string to lower case
	argument = str:lower()
	
	if str ~= "unhide" and str ~= "hide" then p(usage); return end
	
	-- Get quest list for that zone from database
	local questlist = QuestMap:GetQuestList(map)
	
	if str == "unhide" then
		for _, quest in ipairs(questlist) do
			-- Remove from list that holds hidden quests
			QuestMap.settings.hiddenQuests[quest.id] = nil
		end
		if QuestMap.settings.displayClickMsg then p(GetString(QUESTMAP_MSG_UNHIDDEN_P).." @ |cFFFFFF"..LMP:GetZoneAndSubzone(LMP_FORMAT_ZONE_SINGLE_STRING)) end
	elseif str == "hide" then
		for _, quest in ipairs(questlist) do
			-- Hiding only necessary for uncompleted quests
			if not completedQuests[quest.id] then
				-- Add to list that holds hidden quests
				QuestMap.settings.hiddenQuests[quest.id] = QuestMap:GetQuestName(quest.id)
			end
		end
		if QuestMap.settings.displayClickMsg then p(GetString(QUESTMAP_MSG_HIDDEN_P).." @ |cFFFFFF"..LMP:GetZoneAndSubzone(LMP_FORMAT_ZONE_SINGLE_STRING)) end
	else
		p(usage)
		return
	end
end

-- Event handler function for EVENT_PLAYER_ACTIVATED
local function OnPlayerActivated(event)
	-- Set up SavedVariables table
	QuestMap.settings = ZO_SavedVars:New("QuestMapSettings", 1, nil, QuestMap.savedVarsDefault)
	
	-- Get saved variables table for current user/char directly (without metatable), so it is possible to use pairs()
	local sv = QuestMapSettings.Default[GetDisplayName()][GetUnitName("player")]
	-- Clean up saved variables (from previous versions)
	for key, val in pairs(sv) do
		-- Delete key-value pair if the key can't also be found in the default settings (except for version)
		if key ~= "version" and QuestMap.savedVarsDefault[key] == nil then
			sv[key] = nil
		end
	end
	
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
	LMP:AddPinType(PIN_TYPE_QUEST_STARTED, function() MapCallbackQuestPins(PIN_TYPE_QUEST_STARTED) end, nil, pinLayout, pinTooltipCreator)
	pinLayout = {level = QuestMap.settings.pinLevel, texture = "QuestMap/icons/pinQuestCompleted.dds", size = QuestMap.settings.pinSize}
	LMP:AddPinType(PIN_TYPE_QUEST_COMPLETED, function() MapCallbackQuestPins(PIN_TYPE_QUEST_COMPLETED) end, nil, pinLayout, pinTooltipCreator)
	LMP:AddPinType(PIN_TYPE_QUEST_HIDDEN, function() MapCallbackQuestPins(PIN_TYPE_QUEST_HIDDEN) end, nil, pinLayout, pinTooltipCreator)
	-- Add map filters
	LMP:AddPinFilter(PIN_TYPE_QUEST_UNCOMPLETED, GetString(QUESTMAP_QUESTS).." ("..GetString(QUESTMAP_UNCOMPLETED)..")", true, QuestMap.settings.pinFilters)
	LMP:AddPinFilter(PIN_TYPE_QUEST_COMPLETED, GetString(QUESTMAP_QUESTS).." ("..GetString(QUESTMAP_COMPLETED)..")", true, QuestMap.settings.pinFilters)
	LMP:AddPinFilter(PIN_TYPE_QUEST_STARTED, GetString(QUESTMAP_QUESTS).." ("..GetString(QUESTMAP_STARTED)..")", true, QuestMap.settings.pinFilters)
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
	
	-- Get names of started quests from quest journal, get quest ID from lookup table
	startedQuests = {}
	for i = 1, GetNumJournalQuests(), 1 do
		local name = GetJournalQuestName(i)
		local id = QuestMap:GetQuestId(name)
		if id ~= nil then
			-- Add to list and exit loop
			startedQuests[id] = true
		end
	end
	-- Set up list of completed quests
	UpdateQuestData()
	
	-- Register slash command and link function
	SLASH_COMMANDS["/qm"] = function(str) SetQuestsInZoneHidden(str); QuestMap:RefreshPins() end
	
	EVENT_MANAGER:UnregisterForEvent(QuestMap.name, EVENT_PLAYER_ACTIVATED)
end

-- Event handler function for EVENT_QUEST_ADDED
local function OnQuestAdded(event, index, name, objective)
	-- Get id from name and only continue if found
	local id = QuestMap:GetQuestId(name)
	if id == nil then return end
	
	-- Add to list of started quests and refresh map pins
	startedQuests[id] = true
	QuestMap:RefreshPins()
end

-- Event handler function for EVENT_QUEST_REMOVED
local function OnQuestRemoved(event, isComplete, index, name, zone, poi)
	if isComplete then
		UpdateQuestData()
	else -- Abandoned
		-- Get id from name and only continue if found
		local id = QuestMap:GetQuestId(name)
		if id == nil then return end
		-- Remove from list of started quests
		startedQuests[id] = nil
	end
	QuestMap:RefreshPins()
end


-- Registering the event handler functions for the events
EVENT_MANAGER:RegisterForEvent(QuestMap.name, EVENT_PLAYER_ACTIVATED, OnPlayerActivated)
EVENT_MANAGER:RegisterForEvent(QuestMap.name, EVENT_QUEST_ADDED,      OnQuestAdded)
EVENT_MANAGER:RegisterForEvent(QuestMap.name, EVENT_QUEST_REMOVED,    OnQuestRemoved)