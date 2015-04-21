--[[

Quest Map
by CaptainBlagbird
https://github.com/CaptainBlagbird

--]]

-- General
SafeAddString( QUESTMAP_COMPLETED,             "Erledigt", 1)
SafeAddString( QUESTMAP_UNCOMPLETED,           "Unerledigt", 1)
SafeAddString( QUESTMAP_HIDDEN,                "Manuell ausgeblendet", 1)

SafeAddString( QUESTMAP_HIDE,                  "Quest ausblenden", 1)
SafeAddString( QUESTMAP_UNHIDE,                "Quest einblenden", 1)

SafeAddString( QUESTMAP_MSG_HIDDEN,            "Quest ausgeblendet", 1)
SafeAddString( QUESTMAP_MSG_UNHIDDEN,          "Quest eingeblendet", 1)

SafeAddString( QUESTMAP_QUESTS,                "Quests", 1)

-- Settings menu
SafeAddString( QUESTMAP_MENU_PIN_SIZE,         "Grösse der Kartenmarkierung", 1)
SafeAddString( QUESTMAP_MENU_PIN_SIZE_TT,      "Definiert die Anzeigegrösse der Kartenmarkierungen (Standard: "..QuestMap.savedVarsDefault.pinSize..")", 1)

SafeAddString( QUESTMAP_MENU_PIN_LVL,          "Ebene der Kartenmarkierung", 1)
SafeAddString( QUESTMAP_MENU_PIN_LVL_TT,       "Definiert auf welcher Ebene die Kartenmarkierungen gezeichnet werden (Standard: "..QuestMap.savedVarsDefault.pinLevel..")", 1)

SafeAddString( QUESTMAP_MENU_DISP_MSG,         "Ein-/ausgeblende-Nachricht anzeigen", 1)
SafeAddString( QUESTMAP_MENU_DISP_MSG_TT,      "Ein-/ausschalten der Nachricht die angezeigt wird, wenn Markierungen ein-/ausgeblendet werden", 1)

SafeAddString( QUESTMAP_MENU_NOTE_1,           "Hinweis: 'Standardwerte' setzt die manuell ausgeblendeten Questmarkierungen NICHT zurück.", 1)
SafeAddString( QUESTMAP_MENU_NOTE_2,           "Willst du ALLE ausgeblendeten Markierungen zurücksetzen, dann benütze diese Schaltfläche:", 1)

SafeAddString( QUESTMAP_MENU_RESET_HIDDEN,     "Ausgebl. zurücksetzen", 1)
SafeAddString( QUESTMAP_MENU_RESET_HIDDEN_TT,  "Manuell ausgeblendete Markierungen zurücksetzen", 1)
SafeAddString( QUESTMAP_MENU_RESET_HIDDEN_W,   "Kann nicht rückgängig gemacht werden!", 1)