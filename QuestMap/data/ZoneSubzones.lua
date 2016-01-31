--[[

Quest Map
by CaptainBlagbird
https://github.com/CaptainBlagbird

--]]

local zones = {
	["therift/therift_base"] = {
		["therift/nimalten_base"] = {
			zoom_factor = 0.1757825017,
			y = 0.3061524928,
			x = 0.1542975008,
		},
		["therift/shorsstone_base"] = {
			zoom_factor = 0.1406250000,
			y = 0.2280274928,
			x = 0.6059575081,
		},
		["therift/riften_base"] = {
			zoom_factor = 0.1416025162,
			y = 0.4189450145,
			x = 0.6059575081,
		},
	},
	["bangkorai/bangkorai_base"] = {
		["bangkorai/hallinsstand_base"] = {
			zoom_factor = 0.2170779407,
			y = 0.6440171599,
			x = 0.1551392376,
		},
		["bangkorai/evermore_base"] = {
			zoom_factor = 0.1725804806,
			y = 0.2724003494,
			x = 0.3253151774,
		},
	},
	["craglorn/craglorn_base"] = {
		["craglorn/craglorn_dragonstar"] = {
			zoom_factor = 0.0979347825,
			y = 0.2383198738,
			x = 0.1167204976,
		},
		["craglorn/belkarth_base"] = {
			zoom_factor = 0.1406832039,
			y = 0.6149037480,
			x = 0.4866428673,
		},
	},
	["cyrodiil/ava_whole"] = {
		["cyrodiil/southmorrowgate_base"] = {
			zoom_factor = 0.0705088973,
			y = 0.2728511095,
			x = 0.8904289007,
		},
		["cyrodiil/westelsweyrgate_base"] = {
			zoom_factor = 0.0453133285,
			y = 0.8671844602,
			x = 0.3632799983,
		},
		["cyrodiil/eastelsweyrgate_base"] = {
			zoom_factor = 0.0609378219,
			y = 0.8583955765,
			x = 0.5771466494,
		},
		["cyrodiil/northhighrockgate_base"] = {
			zoom_factor = 0.0539066643,
			y = 0.0673800036,
			x = 0.1304666698,
		},
		["cyrodiil/southhighrockgate_base"] = {
			zoom_factor = 0.0498044454,
			y = 0.2605444491,
			x = 0.0363266654,
		},
		["cyrodiil/northmorrowgate_base"] = {
			zoom_factor = 0.0705088973,
			y = 0.0765622258,
			x = 0.8035155535,
		},
	},
	["rivenspire/rivenspire_base"] = {
		["rivenspire/shornhelm_base"] = {
			zoom_factor = 0.1549828649,
			y = 0.4778127968,
			x = 0.3514492512,
		},
		["rivenspire/northpoint_base"] = {
			zoom_factor = 0.1562702656,
			y = 0.1344073862,
			x = 0.7167208195,
		},
	},
	["alikr/alikr_base"] = {
		["alikr/bergama_base"] = {
			zoom_factor = 0.1329798400,
			x = 0.4657132328,
			y = 0.5828379393,
		},
		["alikr/kozanset_base"] = {
			zoom_factor = 0.1254443526,
			y = 0.3944286704,
			x = 0.6922902465,
		},
		["alikr/sentinel_base"] = {
			zoom_factor = 0.2059123665,
			y = 0.3574757278,
			x = 0.1676649302,
		},
	},
	["glenumbra/glenumbra_base"] = {
		["glenumbra/daggerfall_base"] = {
			zoom_factor = 0.2057888359,
			y = 0.6615520716,
			x = 0.1760335714,
		},
		["glenumbra/crosswych_base"] = {
			zoom_factor = 0.1668418646,
			y = 0.0615800843,
			x = 0.7236845493,
		},
		["glenumbra/aldcroft_base"] = {
			zoom_factor = 0.1342113018,
			y = 0.4910534918,
			x = 0.5031582117,
		},
	},
	["glenumbra/betnihk_base"] = {
		["glenumbra/stonetoothfortress_base"] = {
			zoom_factor = 0.3335171044,
			y = 0.3294491172,
			x = 0.3742717206,
		},
	},
	["glenumbra/strosmkai_base"] = {
		["glenumbra/porthunding_base"] = {
			zoom_factor = 0.4183864892,
			y = 0.2100436538,
			x = 0.4483701885,
		},
	},
	["coldharbor/coldharbour_base"] = {
		["coldharbor/hollowcity_base"] = {
			zoom_factor = 0.1166611016,
			y = 0.6221156120,
			x = 0.4355244935,
		},
	},
	["stormhaven/stormhaven_base"] = {
		["stormhaven/koeglinvillage_base"] = {
			zoom_factor = 0.1177457199,
			y = 0.3448657095,
			x = 0.1082599983,
		},
		["stormhaven/alcairecastle_base"] = {
			zoom_factor = 0.1244428605,
			y = 0.1880571395,
			x = 0.1043514311,
		},
		["stormhaven/wayrest_base"] = {
			zoom_factor = 0.1981028616,
			y = 0.5016742945,
			x = 0.4614942968,
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
}

function QuestMap:GetSubzoneList(zone)
	if type(zone) == "string" and zones[zone] ~= nil then
		return zones[zone]
	else
		return {}
	end
end