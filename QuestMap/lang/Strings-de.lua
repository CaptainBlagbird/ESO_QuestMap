--[[

Quest Map
by CaptainBlagbird
https://github.com/CaptainBlagbird

--]]

-- General
SafeAddString( QUESTMAP_COMPLETED,             "Erledigt", 1)
SafeAddString( QUESTMAP_UNCOMPLETED,           "Unerledigt", 1)
SafeAddString( QUESTMAP_HIDDEN,                "Manuell ausgeblendet", 1)
SafeAddString( QUESTMAP_STARTED,               "Begonnen", 1)
SafeAddString( QUESTMAP_CADWELL,               "Cadwells Almanach", 1)
SafeAddString( QUESTMAP_SKILL,                 "Fertigkeitspunkt", 1)

SafeAddString( QUESTMAP_HIDE,                  "Quest ausblenden", 1)
SafeAddString( QUESTMAP_UNHIDE,                "Quest einblenden", 1)

SafeAddString( QUESTMAP_MSG_HIDDEN,            "Quest ausgeblendet", 1)
SafeAddString( QUESTMAP_MSG_UNHIDDEN,          "Quest eingeblendet", 1)
SafeAddString( QUESTMAP_MSG_HIDDEN_P,          "Quests ausgeblendet", 1)
SafeAddString( QUESTMAP_MSG_UNHIDDEN_P,        "Quests eingeblendet", 1)

SafeAddString( QUESTMAP_QUESTS,                "Quests", 1)
SafeAddString( QUESTMAP_QUEST_SUBFILTER,       "Subfilter", 1)

SafeAddString( QUESTMAP_SLASH_USAGE,           "Bitte verwende ein Argument nach dem Befehl:\n 'hide' - Alle quests in der aktuellen Karte ausblenden\n 'unhide' - Alle quests in der aktuellen Karte einblenden", 1)
SafeAddString( QUESTMAP_SLASH_MAPINFO,         "Bitte erst die Karte öffnen.", 1)

SafeAddString( QUESTMAP_LIB_REQUIRED,          "nicht installiert/aktiviert.", 1)

-- Settings menu
SafeAddString( QUESTMAP_MENU_ICON_SET,         "Icon-Set", 1)

SafeAddString( QUESTMAP_MENU_PIN_SIZE,         "Grösse der Kartenmarkierung", 1)
SafeAddString( QUESTMAP_MENU_PIN_SIZE_TT,      "Definiert die Anzeigegrösse der Kartenmarkierungen (Standard: "..QuestMap.savedVarsDefault.pinSize..")", 1)

SafeAddString( QUESTMAP_MENU_PIN_LVL,          "Ebene der Kartenmarkierung", 1)
SafeAddString( QUESTMAP_MENU_PIN_LVL_TT,       "Definiert auf welcher Ebene die Kartenmarkierungen gezeichnet werden (Standard: "..QuestMap.savedVarsDefault.pinLevel..")", 1)

SafeAddString( QUESTMAP_MENU_DISP_MSG,         "Ein-/ausblende-Nachricht anzeigen", 1)
SafeAddString( QUESTMAP_MENU_DISP_MSG_TT,      "Ein-/ausschalten der Nachricht die angezeigt wird, wenn Markierungen ein-/ausgeblendet werden", 1)

SafeAddString( QUESTMAP_MENU_HIDDEN_QUESTS_T,  "Quests manuell ausblenden", 1)
SafeAddString( QUESTMAP_MENU_HIDDEN_QUESTS_1,  "Du kannst Questmarkierungen manuell ausblenden indem du sie anklickst. (Um ausgeblendete Questmarkierungen zu sehen, aktiviere den Filter für Kartenmarkierungen rechts neben der Karte.)", 1)
SafeAddString( QUESTMAP_MENU_HIDDEN_QUESTS_2,  "Zum gleichzeitigen ein-/ausblenden aller Kartenmarkierung einer bestimmten Karte kannst du den Chat-Befehl '/qm hide' oder '/qm unhide' verwenden.", 1)
SafeAddString( QUESTMAP_MENU_HIDDEN_QUESTS_B,  "Willst du ALLE ausgeblendeten Markierungen zurücksetzen, dann benütze diese Schaltfläche:", 1)

SafeAddString( QUESTMAP_MENU_RESET_HIDDEN,     "Ausgebl. zurücksetzen", 1)
SafeAddString( QUESTMAP_MENU_RESET_HIDDEN_TT,  "Manuell ausgeblendete Markierungen zurücksetzen", 1)
SafeAddString( QUESTMAP_MENU_RESET_HIDDEN_W,   "Kann nicht rückgängig gemacht werden!", 1)

SafeAddString( QUESTMAP_MENU_RESET_NOTE,       "Hinweis: Unten auf '"..GetString(SI_OPTIONS_DEFAULTS).."' klicken setzt die manuell ausgeblendeten Questmarkierungen NICHT zurück.", 1)