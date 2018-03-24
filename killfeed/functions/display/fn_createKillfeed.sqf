/*
	Function: HALs_fnc_createKillfeed;
	Author: HallyG
	Creates the Killfeed control group.
	
	Argument(s):
	0: None
	
	Return Value:
	None
	
	Example:
	[] call HALs_fnc_createKillfeed;
__________________________________________________________________*/
if (!hasInterface) exitWith {};
disableSerialization;

ctrlDelete ((findDisplay 46) displayCtrl 3200);

private _ctrlGroup = (findDisplay 46) ctrlCreate ["RscControlsGroupNoScrollbars", 3200];
uiNamespace setVariable ["HALs_ctrlKillfeed", _ctrlGroup];

_ctrlGroup ctrlSetPosition [(pixelW * safezoneWAbs + safezoneX), safezoneY + pixelH * safezoneH, (0.75 * safezoneW), (0.6 * safezoneH)];
_ctrlGroup ctrlCommit 0;


