/*
	Function: HALs_fnc_getSideColour
	Author: HallyG
	Returns the colour associated with a unit.

	Argument(s):
	0: Group <GROUP>

	Return Value:
	<NUMBER>

	Example:
	[] call HALs_fnc_getSideColour;
__________________________________________________________________*/
params [
	["_groupObject", grpNull, [grpNull]]
];

if (!HALs_killfeed_sideColour) exitWith {
	_groupPlayer = group player;
	_sideObject = side _groupObject;
	_sidePlayer = side _groupPlayer;

	_isPlayerGroup = _groupObject isEqualTo _groupPlayer;
	_isPlayerSide = _sideObject isEqualTo _sidePlayer;

	([2, [0, 1] select _isPlayerGroup] select _isPlayerSide)
};

([west, east, resistance, civilian] find (side _groupObject)) max 0
