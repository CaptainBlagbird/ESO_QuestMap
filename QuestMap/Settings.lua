--[[

Quest Map
by CaptainBlagbird
https://github.com/CaptainBlagbird

--]]

local panelData = {
	type = "panel",
	name = QuestMap.name,
	displayName = "|c70C0DE"..QuestMap.name.."|r",
	author = "|c70C0DECaptainBlagbird|r",
	version = "1.1",
	slashCommand = "/questmap",	--(optional) will register a keybind to open to this panel
	registerForRefresh = true,	--boolean (optional) (will refresh all options controls when a setting is changed and when the panel is shown)
	registerForDefaults = true,	--boolean (optional) (will set all options controls back to default values)
	resetFunc = function() QuestMap:ResetPinFilters() end,	--function (optional) if registerForDefaults is true, this custom function will run after settings are reset to defaults
}

local function ChangePinSize(value)
	QuestMap.settings.pinLevel = value
	QuestMap:InitPins()
end

local optionsTable = {
	[1] = {
		type = "slider",
		name = "Map pin size",
		tooltip = "Sets the display size of the map pins (default: 25)",
		min = 5,
		max = 70,
		step = 1,
		getFunc = function() return QuestMap.settings.pinSize end,
		setFunc = function(value)
						QuestMap.settings.pinSize = value
						QuestMap:RefreshPinLayout()
					end,
		width = "full",
		default = 25,
	},
	[2] = {
		type = "slider",
		name = "Map pin level",
		tooltip = "Sets on which level the map pins are drawn (default: 40)",
		min = 10,
		max = 200,
		step = 1,
		getFunc = function() return QuestMap.settings.pinLevel end,
		setFunc = function(value)
						QuestMap.settings.pinLevel = value
						QuestMap:RefreshPinLayout()
					end,
		width = "full",
		default = 40,
	},
	[3] = {
		type = "checkbox",
		name = "Display quest (un)hidden message",
		tooltip = "Enable/disable message that is displayed when (un)hiding markers",
		getFunc = function() return QuestMap.settings.displayClickMsg end,
		setFunc = function(value) QuestMap.settings.displayClickMsg = value end,
		default = true,
		width = "full",
	},
	[4] = {
		type = "header",
		name = "",
		width = "full",
	},
	[5] = {
		type = "description",
		title = "Note: 'Reset to Defaults' does NOT reset manually hidden quest pins.",
		text = "",
		width = "full",
	},
	[6] = {
		type = "description",
		title = "If you want to clear ALL manually hidden quest pins at once, you can use this button:",
		text = "",
		width = "half",
	},
	[7] = {
		type = "button",
		name = "Reset hidden pins",
		tooltip = "Reset manually hidden pins",
		func = function()
				QuestMap.settings.hiddenQuests = {}
				end,
		width = "half",
		warning = "Cannot be undone!",
	},
}


-- Wait until all addons are loaded
local function OnPlayerActivated(event)
	EVENT_MANAGER:UnregisterForEvent(QuestMap.name.."Settings", EVENT_PLAYER_ACTIVATED)
	if LibStub ~= nil then
		local LAM = LibStub("LibAddonMenu-2.0")
		LAM:RegisterAddonPanel(QuestMap.name, panelData)
		LAM:RegisterOptionControls(QuestMap.name, optionsTable)
	end
end
EVENT_MANAGER:RegisterForEvent(QuestMap.name.."Settings", EVENT_PLAYER_ACTIVATED, OnPlayerActivated)