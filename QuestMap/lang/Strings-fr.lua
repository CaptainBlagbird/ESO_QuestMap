--[[

Quest Map
by CaptainBlagbird
https://github.com/CaptainBlagbird

--]]

-- General
SafeAddString( QUESTMAP_COMPLETED,             "Terminée", 1)
SafeAddString( QUESTMAP_UNCOMPLETED,           "Inachevée", 1)
SafeAddString( QUESTMAP_HIDDEN,                "Cachée manuellement", 1)
SafeAddString( QUESTMAP_STARTED,               "Commencée", 1)
SafeAddString( QUESTMAP_CADWELL,               "Almanach de Cadwell", 1)
SafeAddString( QUESTMAP_SKILL,                 "Point de compétence", 1)

SafeAddString( QUESTMAP_HIDE,                  "Cacher les quêtes", 1)
SafeAddString( QUESTMAP_UNHIDE,                "Rendre visible les quêtes", 1)

SafeAddString( QUESTMAP_MSG_HIDDEN,            "Quête cachée", 1)
SafeAddString( QUESTMAP_MSG_UNHIDDEN,          "Quête rendues visible", 1)
SafeAddString( QUESTMAP_MSG_HIDDEN_P,          "Quêtes cachée", 1)
SafeAddString( QUESTMAP_MSG_UNHIDDEN_P,        "Quêtes rendues visible", 1)

SafeAddString( QUESTMAP_QUESTS,                "Quêtes", 1)
SafeAddString( QUESTMAP_QUEST_SUBFILTER,       "Sous-filtre", 1)

SafeAddString( QUESTMAP_SLASH_USAGE,           "Veuillez utiliser un argument après la commande:\n 'hide' - Cacher toutes les quêtes sur la carte actuelle\n 'unhide' - Rendre visible toutes les quêtes sur la carte actuelle", 1)
SafeAddString( QUESTMAP_SLASH_MAPINFO,         "Veuillez ouvrir la carte en premier.", 1)

SafeAddString( QUESTMAP_LIB_REQUIRED,          "n'est pas installée/activée.", 1)

-- Settings menu
SafeAddString( QUESTMAP_MENU_ICON_SET,         "Set d'icônes", 1)

SafeAddString( QUESTMAP_MENU_PIN_SIZE,         "Taille marqueur sur la carte", 1)
SafeAddString( QUESTMAP_MENU_PIN_SIZE_TT,      "Règle la taille des marqueurs sur la carte (par défaut: "..QuestMap.savedVarsDefault.pinSize..")", 1)

SafeAddString( QUESTMAP_MENU_PIN_LVL,          "Marqueur niveau", 1)
SafeAddString( QUESTMAP_MENU_PIN_LVL_TT,       "Règle à quel niveau les marqueurs sont déssinés sur la carte (par défaut: "..QuestMap.savedVarsDefault.pinLevel..")", 1)

SafeAddString( QUESTMAP_MENU_DISP_MSG,         "Affichage message quêtes cacher/rendre visible", 1)
SafeAddString( QUESTMAP_MENU_DISP_MSG_TT,      "Active/Désactive le message qui est affiché quand on cache/rend visible les marqueurs", 1)      

SafeAddString( QUESTMAP_MENU_HIDDEN_QUESTS_T,  "Cacher manuellement les quêtes", 1)
SafeAddString( QUESTMAP_MENU_HIDDEN_QUESTS_1,  "Vous pouvez manuellement cacher/rendre visible les marqueurs de quêtes en cliquant dessus. (Pour voir les marqueurs de quêtes cachés, activer le filtre à droite de la carte.)", 1)
SafeAddString( QUESTMAP_MENU_HIDDEN_QUESTS_2,  "Pour cacher/rendre visible tous les marqueurs présent sur une carte en une seule fois, vous pouvez utiliser la commande '/qm hide' ou '/qm unhide'.", 1)
SafeAddString( QUESTMAP_MENU_HIDDEN_QUESTS_B,  "Si vous voulez effacer simultanément TOUS les marqueurs de quêtes manuellement cachés, vous pouvez utiliser ce bouton:", 1)

SafeAddString( QUESTMAP_MENU_RESET_HIDDEN,     "Réinitialiser les marqueurs cachés", 1)
SafeAddString( QUESTMAP_MENU_RESET_HIDDEN_TT,  "Réinitialiser les marqueurs de quêtes manuellement cachés", 1)
SafeAddString( QUESTMAP_MENU_RESET_HIDDEN_W,   "Ne peut pas être annulé!", 1)

SafeAddString( QUESTMAP_MENU_RESET_NOTE,       "Remarque: Cliquer sur '"..GetString(SI_OPTIONS_DEFAULTS).."' en bas ne réinitialise PAS les marqueurs de quêtes cachés manuellement.", 1)
