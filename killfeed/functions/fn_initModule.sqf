/*
	Function: HALs_fnc_initModule
	Author: HallyG
	TDM Module Init.
	
	Argument(s):
	0: None
	
	Return Value:
	None
	
	Example:
	[] spawn HALs_fnc_initModule;
__________________________________________________________________*/
if (!hasInterface) exitWith {};
if (!isNil "HALs_killfeed_show") exitWith {};

private _fnc_getConfigValue = {
	params [
		["_class", configNull, [configNull]],
		["_return", nil]
	];

	call {
		if (isText _class) exitWith {getText _class};
		if (isNumber _class) exitWith {getNumber _class};
		if (isArray _class) exitWith  {getArray _class};
		_return
	};
};

HALs_killfeed_debug = ([missionConfigFile >> "cfgHALsKillfeed" >> "debug", 0] call _fnc_getConfigValue) isEqualTo 1;
HALs_killfeed_showKillfeed = ([missionConfigFile >> "cfgHALsKillfeed" >> "showKillfeed", 1] call _fnc_getConfigValue) isEqualTo 1;
HALs_killfeed_showAIKills = ([missionConfigFile >> "cfgHALsKillfeed" >> "showAIKills", 1] call _fnc_getConfigValue) isEqualTo 1;
HALs_killfeed_size = ([missionConfigFile >> "cfgHALsKillfeed" >> "size", 5] call _fnc_getConfigValue) min 10 max 1;
HALs_killfeed_sideColour = ([missionConfigFile >> "cfgHALsKillfeed" >> "sideColour", 1] call _fnc_getConfigValue) isEqualTo 1;
HALs_killfeed_sideColourArray = [
	["#1a66b3", "#1a991a", "#991a1a"],
	["#1a66b3", "#991a1a", "#1a991a", "#660080"]
] select HALs_killfeed_sideColour;

[] spawn {
	waitUntil {!isNull (findDisplay 46)};
	[] call HALs_fnc_createKillfeed;
	[] call HALs_fnc_initKillfeed;
};
