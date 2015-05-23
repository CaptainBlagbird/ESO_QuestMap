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
	version = "1.5",
	slashCommand = "/questmap",	--(optional) will register a keybind to open to this panel
	registerForRefresh = true,	--boolean (optional) (will refresh all options controls when a setting is changed and when the panel is shown)
	registerForDefaults = true,	--boolean (optional) (will set all options controls back to default values)
	resetFunc = function()
					-- Also reset pin filters. The only thing in the saved variables will be the hidden quests (QuestMap.settings.hiddenQuests)
					QuestMap.settings.pinFilters = QuestMap.savedVarsDefault.pinFilters
					QuestMap:RefreshPinFilters()
				end,	--function (optional) if registerForDefaults is true, this custom function will run after settings are reset to defaults
}

local function ChangePinSize(value)
	QuestMap.settings.pinLevel = value
	QuestMap:InitPins()
end

local optionsTable = {
	[1] = {
		type = "slider",
		name = GetString(QUESTMAP_MENU_PIN_SIZE),
		tooltip = GetString(QUESTMAP_MENU_PIN_SIZE_TT),
		min = 5,
		max = 70,
		step = 1,
		getFunc = function() return QuestMap.settings.pinSize end,
		setFunc = function(value)
						QuestMap.settings.pinSize = value
						QuestMap:RefreshPinLayout()
					end,
		width = "full",
		default = QuestMap.savedVarsDefault.pinSize,
	},
	[2] = {
		type = "slider",
		name = GetString(QUESTMAP_MENU_PIN_LVL),
		tooltip = GetString(QUESTMAP_MENU_PIN_LVL_TT),
		min = 10,
		max = 200,
		step = 1,
		getFunc = function() return QuestMap.settings.pinLevel end,
		setFunc = function(value)
						QuestMap.settings.pinLevel = value
						QuestMap:RefreshPinLayout()
					end,
		width = "full",
		default = QuestMap.savedVarsDefault.pinLevel,
	},
	[3] = {
		type = "checkbox",
		name = GetString(QUESTMAP_MENU_DISP_MSG),
		tooltip = GetString(QUESTMAP_MENU_DISP_MSG_TT),
		getFunc = function() return QuestMap.settings.displayClickMsg end,
		setFunc = function(value) QuestMap.settings.displayClickMsg = value end,
		default = QuestMap.savedVarsDefault.displayClickMsg,
		width = "full",
	},
	[4] = {
		type = "header",
		name = "",
		width = "full",
	},
	[5] = {
		type = "description",
		title = GetString(QUESTMAP_MENU_NOTE_1),
		text = "",
		width = "full",
	},
	[6] = {
		type = "description",
		title = GetString(QUESTMAP_MENU_NOTE_2),
		text = "",
		width = "half",
	},
	[7] = {
		type = "button",
		name = GetString(QUESTMAP_MENU_RESET_HIDDEN),
		tooltip = GetString(QUESTMAP_MENU_RESET_HIDDEN_TT),
		func = function()
					QuestMap.settings.hiddenQuests = {}
					QuestMap:RefreshPinLayout()
				end,
		width = "half",
		warning = GetString(QUESTMAP_MENU_RESET_HIDDEN_W),
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