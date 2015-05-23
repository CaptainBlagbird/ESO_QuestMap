--[[

Quest Map
by CaptainBlagbird
https://github.com/CaptainBlagbird

--]]

local strings = {
	-- General
	QUESTMAP_COMPLETED            = "Completed",
	QUESTMAP_UNCOMPLETED          = "Uncompleted",
	QUESTMAP_HIDDEN               = "Manually hidden",
	QUESTMAP_CADWELL              = "Cadwell's Almanac",
	QUESTMAP_SKILL                = "Skill point",
	
	QUESTMAP_HIDE                 = "Hide quest",
	QUESTMAP_UNHIDE               = "Unhide quest",
	
	QUESTMAP_MSG_HIDDEN           = "Quest hidden",
	QUESTMAP_MSG_UNHIDDEN         = "Quest unhidden",
	
	QUESTMAP_QUESTS               = "Quests",
	QUESTMAP_QUEST_SUBFILTER      = "Subfilter",
	
	-- Settings menu
	QUESTMAP_MENU_PIN_SIZE        = "Map pin size",
	QUESTMAP_MENU_PIN_SIZE_TT     = "Defines the display size of the map pins (default: "..QuestMap.savedVarsDefault.pinSize..")",
	
	QUESTMAP_MENU_PIN_LVL         = "Map pin level",
	QUESTMAP_MENU_PIN_LVL_TT      = "Defines on which level the map pins are drawn (default: "..QuestMap.savedVarsDefault.pinLevel..")",
	
	QUESTMAP_MENU_DISP_MSG        = "Display quest (un)hidden message",
	QUESTMAP_MENU_DISP_MSG_TT     = "Enable/disable message that is displayed when (un)hiding pins",
	
	QUESTMAP_MENU_NOTE_1          = "Note: 'Reset to Defaults' does NOT reset manually hidden quest pins.",
	QUESTMAP_MENU_NOTE_2          = "If you want to clear ALL manually hidden quest pins at once, you can use this button:",
	
	QUESTMAP_MENU_RESET_HIDDEN    = "Reset hidden pins",
	QUESTMAP_MENU_RESET_HIDDEN_TT = "Reset manually hidden pins",
	QUESTMAP_MENU_RESET_HIDDEN_W  = "Cannot be undone!",
}

for key, value in pairs(strings) do
   ZO_CreateStringId(key, value)
   SafeAddVersion(key, 1)
end
