--[[

Quest Map
by CaptainBlagbird
https://github.com/CaptainBlagbird

--]]

local zones = {
    ["therift/therift_base"] = {
        ["therift/nimalten_base"] = {
            x = 0.1542975008,
            y = 0.3061524928,
            zoom_factor = 0.1757825017,
        },
        ["therift/shorsstone_base"] = {
            x = 0.6059575081,
            y = 0.2280274928,
            zoom_factor = 0.1406250000,
        },
        ["therift/riften_base"] = {
            x = 0.6059575081,
            y = 0.4189450145,
            zoom_factor = 0.1416025162,
        },
    },
    ["bangkorai/bangkorai_base"] = {
        ["bangkorai/hallinsstand_base"] = {
            x = 0.1551392376,
            y = 0.6440171599,
            zoom_factor = 0.2170779407,
        },
        ["bangkorai/evermore_base"] = {
            x = 0.3253151774,
            y = 0.2724003494,
            zoom_factor = 0.1725804806,
        },
    },
    ["craglorn/craglorn_base"] = {
        ["craglorn/craglorn_dragonstar"] = {
            x = 0.1167204976,
            y = 0.2383198738,
            zoom_factor = 0.0979347825,
        },
        ["craglorn/belkarth_base"] = {
            x = 0.4866428673,
            y = 0.6149037480,
            zoom_factor = 0.1406832039,
        },
    },
    ["cyrodiil/ava_whole"] = {
        ["cyrodiil/southmorrowgate_base"] = {
            x = 0.8904289007,
            y = 0.2728511095,
            zoom_factor = 0.0705088973,
        },
        ["cyrodiil/westelsweyrgate_base"] = {
            x = 0.3632799983,
            y = 0.8671844602,
            zoom_factor = 0.0453133285,
        },
        ["cyrodiil/eastelsweyrgate_base"] = {
            x = 0.5771466494,
            y = 0.8583955765,
            zoom_factor = 0.0609378219,
        },
        ["cyrodiil/northhighrockgate_base"] = {
            x = 0.1304666698,
            y = 0.0673800036,
            zoom_factor = 0.0539066643,
        },
        ["cyrodiil/southhighrockgate_base"] = {
            x = 0.0363266654,
            y = 0.2605444491,
            zoom_factor = 0.0498044454,
        },
        ["cyrodiil/northmorrowgate_base"] = {
            x = 0.8035155535,
            y = 0.0765622258,
            zoom_factor = 0.0705088973,
        },
    },
    ["rivenspire/rivenspire_base"] = {
        ["rivenspire/shornhelm_base"] = {
            x = 0.3514492512,
            y = 0.4778127968,
            zoom_factor = 0.1549828649,
        },
        ["rivenspire/northpoint_base"] = {
            x = 0.7167208195,
            y = 0.1344073862,
            zoom_factor = 0.1562702656,
        },
    },
    ["alikr/alikr_base"] = {
        ["alikr/bergama_base"] = {
            x = 0.4657132328,
            y = 0.5828379393,
            zoom_factor = 0.1329798400,
        },
        ["alikr/kozanset_base"] = {
            x = 0.6922902465,
            y = 0.3944286704,
            zoom_factor = 0.1254443526,
        },
        ["alikr/sentinel_base"] = {
            x = 0.1676649302,
            y = 0.3574757278,
            zoom_factor = 0.2059123665,
        },
    },
    ["glenumbra/glenumbra_base"] = {
        ["glenumbra/daggerfall_base"] = {
            x = 0.1760335714,
            y = 0.6615520716,
            zoom_factor = 0.2057888359,
        },
        ["glenumbra/crosswych_base"] = {
            x = 0.7236845493,
            y = 0.0615800843,
            zoom_factor = 0.1668418646,
        },
        ["glenumbra/aldcroft_base"] = {
            x = 0.5031582117,
            y = 0.4910534918,
            zoom_factor = 0.1342113018,
        },
    },
    ["glenumbra/betnihk_base"] = {
        ["glenumbra/stonetoothfortress_base"] = {
            x = 0.3742717206,
            y = 0.3294491172,
            zoom_factor = 0.3335171044,
        },
    },
    ["glenumbra/strosmkai_base"] = {
        ["glenumbra/porthunding_base"] = {
            x = 0.4483701885,
            y = 0.2100436538,
            zoom_factor = 0.4183864892,
        },
    },
    ["coldharbor/coldharbour_base"] = {
        ["coldharbor/hollowcity_base"] = {
            x = 0.4355244935,
            y = 0.6221156120,
            zoom_factor = 0.1166611016,
        },
    },
    ["stormhaven/stormhaven_base"] = {
        ["stormhaven/koeglinvillage_base"] = {
            x = 0.1082599983,
            y = 0.3448657095,
            zoom_factor = 0.1177457199,
        },
        ["stormhaven/alcairecastle_base"] = {
            x = 0.1043514311,
            y = 0.1880571395,
            zoom_factor = 0.1244428605,
        },
        ["stormhaven/wayrest_base"] = {
            x = 0.4614942968,
            y = 0.5016742945,
            zoom_factor = 0.1981028616,
        },
    },
    ["stonefalls/bleakrock_base"] = {
        ["bleakrock/bleakrockvillage_base"] = {
            x = 0.2955851257,
            y = 0.4459653497,
            zoom_factor = 0.3027249873,
        },
    },
    ["greenshade/greenshade_base"] = {
        ["greenshade/woodhearth_base"] = {
            x = 0.0320213959,
            y = 0.5050055981,
            zoom_factor = 0.2621758059,
        },
        ["greenshade/marbruk_base"] = {
            x = 0.6280838847,
            y = 0.4539694488,
            zoom_factor = 0.1517694592,
        },
    },
    ["grahtwood/grahtwood_base"] = {
        ["grahtwood/redfurtradingpost_base"] = {
            x = 0.2548025250,
            y = 0.1158190668,
            zoom_factor = 0.1028252542,
        },
        ["grahtwood/haven_base"] = {
            x = 0.6604512930,
            y = 0.6271192431,
            zoom_factor = 0.2039554119,
        },
        ["grahtwood/eldenrootgroundfloor_base"] = {
            x = 0.4553677440,
            y = 0.3889003098,
            zoom_factor = 0.2192084193,
        },
    },
    ["eastmarch/eastmarch_base"] = {
        ["eastmarch/fortamol_base"] = {
            x = 0.2172850072,
            y = 0.5683599710,
            zoom_factor = 0.1230475008,
        },
        ["eastmarch/windhelm_base"] = {
            x = 0.4291999936,
            y = 0.2221675068,
            zoom_factor = 0.1333000064,
        },
    },
    ["auridon/auridon_base"] = {
        ["auridon/skywatch_base"] = {
            x = 0.5966799855,
            y = 0.4235824943,
            zoom_factor = 0.1699225307,
        },
        ["auridon/vulkhelguard_base"] = {
            x = 0.5236799717,
            y = 0.8146975040,
            zoom_factor = 0.1989750266,
        },
        ["auridon/firsthold_base"] = {
            x = 0.2097174972,
            y = 0.1108400002,
            zoom_factor = 0.1638175100,
        },
    },
    ["stonefalls/stonefalls_base"] = {
        ["stonefalls/davonswatch_base"] = {
            x = 0.7579386830,
            y = 0.2434296608,
            zoom_factor = 0.2004368305,
        },
        ["stonefalls/kragenmoor_base"] = {
            x = 0.1369107813,
            y = 0.5484675169,
            zoom_factor = 0.1675802916,
        },
        ["stonefalls/ebonheart_base"] = {
            x = 0.4438665211,
            y = 0.3713033497,
            zoom_factor = 0.2111170590,
        },
    },
    ["auridon/khenarthisroost_base"] = {
        ["auridon/mistral_base"] = {
            x = 0.3891625106,
            y = 0.3125124872,
            zoom_factor = 0.2719750106,
        },
    },
    ["shadowfen/shadowfen_base"] = {
        ["shadowfen/stormhold_base"] = {
            x = 0.3743500113,
            y = 0.1940100044,
            zoom_factor = 0.1582033038,
        },
        ["shadowfen/altencorimont_base"] = {
            x = 0.5839833617,
            y = 0.4850266576,
            zoom_factor = 0.2024732828,
        },
    },
    ["malabaltor/malabaltor_base"] = {
        ["malabaltor/baandaritradingpost_base"] = {
            x = 0.7590574026,
            y = 0.2596602738,
            zoom_factor = 0.1473419666,
        },
        ["malabaltor/vulkwasten_base"] = {
            x = 0.4679938555,
            y = 0.4027757943,
            zoom_factor = 0.1654598713,
        },
        ["malabaltor/velynharbor_base"] = {
            x = 0.0060382513,
            y = 0.3955286741,
            zoom_factor = 0.2294690134,
        },
    },
    ["reapersmarch/reapersmarch_base"] = {
        ["reapersmarch/rawlkha_base"] = {
            x = 0.3992359936,
            y = 0.4866148233,
            zoom_factor = 0.1259196103,
        },
        ["reapersmarch/dune_base"] = {
            x = 0.6643127799,
            y = 0.2827309072,
            zoom_factor = 0.1971175075,
        },
        ["reapersmarch/arenthia_base"] = {
            x = 0.4769050479,
            y = 0.0429543220,
            zoom_factor = 0.1876999736,
        },
    },
    ["deshaan/deshaan_base"] = {
        ["deshaan/narsis_base"] = {
            x = 0.1208704337,
            y = 0.4710605443,
            zoom_factor = 0.1189569756,
        },
        ["deshaan/mournhold_base"] = {
            x = 0.3402201235,
            y = 0.4104852378,
            zoom_factor = 0.2066458166,
        },
    },
    ["stonefalls/balfoyen_base"] = {
        ["stonefalls/dhalmora_base"] = {
            x = 0.4718720019,
            y = 0.4531199932,
            zoom_factor = 0.2375039756,
        },
    },
    ["wrothgar/wrothgar_base"] = {
        ["wrothgar/orsinium_base"] = {
            x = 0.6082857251,
            y = 0.5285714269,
            zoom_factor = 0.1917142868,
        },
        ["wrothgar/morkul_base"] = {
            x = 0.4524457157,
            y = 0.4147485793,
            zoom_factor = 0.1026799977,
        },
    },
    ["summerset/summerset_base"] = {
        ["summerset/alinor_base"] = {
            x = 0.2424361110,
            y = 0.5480698347,
            zoom_factor = 0.1036754847,
        },
        ["summerset/sunhold_base"] = {
            x = 0.3514192700,
            y = 0.6601553559,
            zoom_factor = 0.0585562289,
        },
        ["summerset/shimmerene_base"] = {
            x = 0.5313938856,
            y = 0.3680678904,
            zoom_factor = 0.1482407451,
        },
        ["summerset/lillandrill_base"] = {
            x = 0.1188169122,
            y = 0.3517273962,
            zoom_factor = 0.0896723717,
        },
    },
    ["clockwork/clockwork_base"] = {
        ["clockwork/brassfortress_base"] = {
            x = 0.3214252889,
            y = 0.1615778059,
            zoom_factor = 0.3572255075,
        },
    },
    ["thievesguild/hewsbane_base"] = {
        ["thievesguild/abahslanding_base"] = {
            x = 0.4762502909,
            y = 0.2592564523,
            zoom_factor = 0.3547124267,
        },
    },
}

function QuestMap:GetSubzoneList(zone)
    if type(zone) == "string" and zones[zone] ~= nil then
        return zones[zone]
    else
        return {}
    end
end