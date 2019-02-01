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
if (!isNil "HALs_killfeed_size") exitWith {};

//--- Fetch Settings
private _cfgPath = missionConfigFile >> "cfgHALsKillfeed";
HALs_killfeed_size = ([_cfgPath >> "size", 5] call HALs_fnc_getConfigValue) min 10 max 1;
HALs_killfeed_showAIKills = ([_cfgPath >> "showAIKills", 1] call HALs_fnc_getConfigValue) isEqualTo 1;
HALs_killfeed_showKillfeed = ([_cfgPath >> "showKillfeed", 1] call HALs_fnc_getConfigValue) isEqualTo 1;
HALs_killfeed_sideColour = ([_cfgPath >> "sideColour", 1] call HALs_fnc_getConfigValue) isEqualTo 1;
HALs_killfeed_sideColourArray = [
	["#1a66b3", "#1a991a", "#991a1a"],
	["#1a66b3", "#991a1a", "#1a991a", "#660080"]
] select HALs_killfeed_sideColour;

//--- Create Killfeed
[] spawn {
	waitUntil {!isNull findDisplay 46};

	private _display = if (false) then {
		findDisplay 46
	} else {
		"HALs_killfeed_display_layer" cutRsc ["RscTitleDisplayEmpty", "PLAIN"];
		uiNamespace getVariable "RscTitleDisplayEmpty"
	};

	uiNamespace setVariable ["HALs_killfeed_display_id", _display];

	[_display] call HALs_fnc_initKillfeed;
};
