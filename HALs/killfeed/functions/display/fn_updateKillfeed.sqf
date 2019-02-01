/*
	Function: HALs_fnc_updateKillfeed
	Author: HallyG, Exile Mod
	Updates the Killfeed.

	Argument(s):
	0: Message <STRING>

	Return Value:
	None

	Example:
	[] call HALs_fnc_updateKillfeed;
__________________________________________________________________*/
if (!hasInterface) exitWith {};
disableSerialization;

params [
	["_message", "ERROR", [""]]
];

private _display = uiNamespace getVariable ["HALs_killfeed_display_id", findDisplay 46];

//--- Create RscStructuredText Control
private _ctrlText = _display ctrlCreate ["RscStructuredText", -1, _display displayCtrl 3200];
_ctrlText ctrlSetFontHeight (((2.2 / 108) * safeZoneH) / (((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25) * 1));
_ctrlText ctrlSetStructuredText (parseText _message);
_ctrlText ctrlSetPosition [
	(ctrlPosition _ctrlText) select 0,
	(ctrlPosition _ctrlText) select 1,
	(0.75 * safezoneW),
	ctrlTextHeight _ctrlText
];
_ctrlText ctrlSetFade 1;
_ctrlText ctrlCommit 0;

//--- Fade in
_ctrlText ctrlSetFade 0;
_ctrlText ctrlCommit 0.25;

//--- Store message
reverse HALs_killfeed_controls;
HALs_killfeed_controls pushBack [_ctrlText, 0, diag_tickTime + 5];
reverse HALs_killfeed_controls;

private _position = 0;
{
	_x params ["_ctrlText", ["_status", 0], "_statusChangeAt"];

	private _ctrlPosition = ctrlPosition _ctrlText;
	_statusChangeAt = _statusChangeAt max (diag_tickTime + 2);

	if (_forEachIndex isEqualTo 0) then {
		_position = 0;
		_ctrlText ctrlSetFade 0;
	} else {
		if (_forEachIndex > HALs_killfeed_size -1) then {
			_ctrlText ctrlSetFade 1;
			_ctrlText ctrlCommit 0.3;
			_status = 1;
			_statusChangeAt = diag_tickTime + 1;
		};
	};

	_ctrlPosition set [1, _position];
	_ctrlText ctrlSetPosition _ctrlPosition;
	_ctrlText ctrlCommit 0.25;
	_position = _position + (ctrlTextHeight _ctrlText) + pixelH*3;

	HALs_killfeed_controls set [_forEachIndex, [_ctrlText, _status, _statusChangeAt]];
} forEach HALs_killfeed_controls;
