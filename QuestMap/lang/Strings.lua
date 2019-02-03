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
    QUESTMAP_STARTED              = "Started",
    QUESTMAP_CADWELL              = "Cadwell's Almanac",
    QUESTMAP_SKILL                = "Skill point",
    
    QUESTMAP_HIDE                 = "Hide quest",
    QUESTMAP_UNHIDE               = "Unhide quest",
    
    QUESTMAP_MSG_HIDDEN           = "Quest hidden",
    QUESTMAP_MSG_UNHIDDEN         = "Quest unhidden",
    QUESTMAP_MSG_HIDDEN_P         = "Quests hidden",
    QUESTMAP_MSG_UNHIDDEN_P       = "Quests unhidden",
    
    QUESTMAP_QUESTS               = "Quests",
    QUESTMAP_QUEST_SUBFILTER      = "Subfilter",
    
    QUESTMAP_SLASH_USAGE          = "Please use an argument after the command:\n 'hide' - Hide all quests on the current map\n 'unhide' - Unhide all quests on the current map",
    QUESTMAP_SLASH_MAPINFO        = "Please open the map first.",
    
    QUESTMAP_LIB_REQUIRED         = "not installed.",
    
    -- Settings menu
    QUESTMAP_MENU_ICON_SET        = "Icon set",
    
    QUESTMAP_MENU_PIN_SIZE        = "Map pin size",
    QUESTMAP_MENU_PIN_SIZE_TT     = "Defines the display size of the map pins (default: "..QuestMap.savedVarsDefault.pinSize..")",
    
    QUESTMAP_MENU_PIN_LVL         = "Map pin level",
    QUESTMAP_MENU_PIN_LVL_TT      = "Defines on which level the map pins are drawn (default: "..QuestMap.savedVarsDefault.pinLevel..")",
    
    QUESTMAP_MENU_DISP_MSG        = "Display quest (un)hidden message",
    QUESTMAP_MENU_DISP_MSG_TT     = "Enable/disable message that is displayed when (un)hiding pins",
    
    QUESTMAP_MENU_HIDDEN_QUESTS_T = "Manually hide quests",
    QUESTMAP_MENU_HIDDEN_QUESTS_1 = "You can manually (un)hide quest pins by clicking on them. (To see hidden quest pins, activate the map pin filter to the right of the map.)",
    QUESTMAP_MENU_HIDDEN_QUESTS_2 = "To (un)hide all quest pins in a map at once, you can use the chat command '/qm hide' or '/qm unhide'.",
    QUESTMAP_MENU_HIDDEN_QUESTS_B = "If you want to clear ALL manually hidden quest pins at once, you can use this button:",
    
    QUESTMAP_MENU_RESET_HIDDEN    = "Reset hidden pins",
    QUESTMAP_MENU_RESET_HIDDEN_TT = "Reset manually hidden pins",
    QUESTMAP_MENU_RESET_HIDDEN_W  = "Cannot be undone!",
    
    QUESTMAP_MENU_RESET_NOTE      = "Note: Clicking on '"..GetString(SI_OPTIONS_DEFAULTS).."' below does NOT reset manually hidden quest pins.",
}

for key, value in pairs(strings) do
   ZO_CreateStringId(key, value)
   SafeAddVersion(key, 1)
end
