/*
	Function: HALs_killfeed_fnc_initModule
	Author: HallyG
	Killfeed: Module init.

	Argument(s):
	0: None

	Return Value:
	None

	Example:
	[] call HALs_killfeed_fnc_initModule;
__________________________________________________________________*/
if (!isNil "HALs_killfeed_moduleInit") exitWith {};
HALs_killfeed_moduleInit = true;

if (hasInterface) then {
    call HALs_killfeed_fnc_initClient
};
