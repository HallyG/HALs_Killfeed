/*
	Function: HALs_killfeed_fnc_initClient
	Author: HallyG
	Killfeed: Client init.

	Argument(s):
	0: None

	Return Value:
	None

	Example:
	[] call HALs_killfeed_fnc_initClient;
__________________________________________________________________*/
if (!hasInterface) exitWith {};
if (!isNil "HALs_killfeed_colours") exitWith {};

private _cfg = missionConfigFile >> "CfgHALsKillfeed";
private _prefix = "HALs_killfeed";
missionNamespace setVariable [format ["%1_%2", _prefix, "size"], getNumber (_cfg >> "size") min 10 max 1];
missionNamespace setVariable [format ["%1_%2", _prefix, "messageLifetime"], getNumber (_cfg >> "messageLifetime") min 10 max 1];
missionNamespace setVariable [format ["%1_%2", _prefix, "showAIKills"], getNumber (_cfg >> "showAIKills") isEqualTo 1];
missionNamespace setVariable [format ["%1_%2", _prefix, "sideColour"], getNumber (_cfg >> "sideColour") isEqualTo 1];

HALs_killfeed_colours = [
    ["#1a66b3", "#1a991a", "#991a1a"],
    ["#991a1a", "#1a66b3", "#1a991a", "#660080"]
] select HALs_killfeed_sideColour;

waitUntil {!isNull (findDisplay 46)};
disableSerialization;

// Store display
private _display = findDisplay 46;
uiNamespace setVariable ["HALs_killfeed_idd", _display];

// Create Killfeed
private _ctrlGroup = _display ctrlCreate ["RscControlsGroupNoScrollbars", 40201];
uiNamespace setVariable ["HALs_killfeed_idc", _ctrlGroup];
private _pos = [pixelW * safezoneWAbs + safezoneX, pixelH * safezoneH + safezoneY, 0.75 * safezoneW, 0.6 * safezoneH];
_ctrlGroup ctrlSetPosition _pos;
_ctrlGroup ctrlCommit 0;

HALs_killfeed_queue = [];
HALs_killfeed_nextUpdate = diag_tickTime;
HALs_killfeed_handleDamageCode = compileFinal "
_this setVariable ['HALs_killfeed_handleDamageEVH',
    _this addEventHandler ['HandleDamage', {
        params ['_soldier', '', '_damage', '_shooter', '_projectile', ''];

        if (!isNull _shooter) then {
            _soldier setVariable ['HALs_lastDamageSource', _projectile];
        };
    }]
];";

addMissionEventHandler ["EachFrame", {call HALs_killfeed_fnc_eachFrame}];
addMissionEventHandler ["EntityKilled", {
    params ["_killed", "_killer", "_instigator"];

    if (typeOf _killed isKindOf "CAManBase") then {
        [_killed, _killer, _instigator] call HALs_killfeed_fnc_parseKill
    };
}];
