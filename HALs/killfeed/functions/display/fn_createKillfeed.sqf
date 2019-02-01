/*
	Function: HALs_fnc_createKillfeed;
	Author: HallyG
    Creates Killfeed.

	Argument(s):
	0: Display <DISPLAY>
    1: IDC <NUMBER>
    2: Position <ARRAY>

	Return Value:
	None

	Example:
	[] call HALs_fnc_createKillfeed;
__________________________________________________________________*/
if (!hasInterface) exitWith {};
disableSerialization;

params [
    ["_display", displayNull, [displayNull]],
    ["_idc", 3200, [0]],
    ["_pos", [
        pixelW * safezoneWAbs + safezoneX,
        pixelH * safezoneH + safezoneY,
        0.75 * safezoneW,
        0.6 * safezoneH
    ], [[]], [2, 4]]
];

private _ctrl = _display ctrlCreate ["RscControlsGroupNoScrollbars", _idc];
_ctrl ctrlSetPosition _pos;
_ctrl ctrlCommit 0;

uiNamespace setVariable ["HALs_killfeed_display_idc", _idc];
