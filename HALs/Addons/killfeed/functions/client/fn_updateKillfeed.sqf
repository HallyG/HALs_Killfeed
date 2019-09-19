/*
	Function: HALs_killfeed_fnc_updateKillfeed
	Author: HallyG
	Animates the Killfeed.

	Argument(s):
	0: Message <STRING>

	Return Value:
	None

	Example:
	[] call HALs_killfeed_fnc_updateKillfeed;
__________________________________________________________________*/
params [
	["_message", "", [""]]
];

if (!hasInterface) exitWith {};

disableSerialization;

private _display = uiNamespace getVariable ["HALs_killfeed_idd", findDisplay 46];
private _ctrlGroup = uiNamespace getVariable ["HALs_killfeed_idc", controlNull];
private _ctrls = _ctrlGroup getVariable ["ctrls", []];

// Create Killfeed message
private _ctrl = _display ctrlCreate ["RscStructuredText", -1, _ctrlGroup];
_ctrl ctrlSetFontHeight (((2.2 / 108) * safeZoneH) / (((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25) * 1));
_ctrl ctrlSetStructuredText parseText format ["<t align='left' shadow='2' shadowColor='#ff0000'>%1</t>", _message];
_ctrl ctrlSetPositionW (ctrlTextWidth _ctrl + pixelW * 5);
_ctrl ctrlSetPositionH ctrlTextHeight _ctrl;
_ctrl ctrlSetFade 1;
_ctrl ctrlCommit 0;
_ctrl ctrlSetFade 0;
_ctrl ctrlCommit 0.25;

// Store new message
reverse _ctrls;
_ctrls pushBack _ctrl;
reverse _ctrls;
_ctrlGroup setVariable ["ctrls", _ctrls];

private _y = 0;
{
	private _status = _x getVariable ["status", 0];
	private _lifetime = (_x getVariable ["lifetime", diag_tickTime + 5]) min (diag_tickTime + 3);

	if (_forEachIndex > HALs_killfeed_size - 1) then {
		_status = 1;
		_lifetime = diag_tickTime;
	};
	_x setVariable ["lifetime", _lifetime];
	_x setVariable ["status", _status];
	_x ctrlSetPositionY _y;
	_x ctrlCommit 0.25;

	_y = _y + ctrlTextHeight _x;
} forEach _ctrls;
