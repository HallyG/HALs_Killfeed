/*
	Function: HALs_fnc_initKillfeed
	Author: HallyG
	Killfeed Initialization.
	
	Argument(s):
	0: None
	
	Return Value:
	None
	
	Example:
	[] call HALs_fnc_initKillfeed;
__________________________________________________________________*/
if !(hasInterface) exitWith {};
if !(isNil "HALs_killfeed_nextUpdate") exitWith {};


addMissionEventHandler ["EntityKilled", {
	params ["_killed", "_killer", "_instigator"];

	if ((typeOf _killed iskindOf "CAManBase")) then {
		[_killed, _killer, _instigator, _killed getVariable ["HALs_killfeed_lastDamageSource", ""]] call HALs_fnc_parseKill;
	};
}];



//--- EachFrame Update Handler
HALs_killfeed_controls = [];
HALs_killfeed_queue = [];
HALs_killfeed_units = [];

HALs_kilfeed_updateDelay = 0.25;
HALs_killfeed_nextUpdate = diag_tickTime;

addMissionEventHandler ["EachFrame", {
	if (diag_tickTime > HALs_killfeed_nextUpdate) then {
		if !(HALs_killfeed_units isEqualTo allUnits) then {
			[] call HALs_fnc_onUnitSpawned;
			HALs_killfeed_units = allUnits;
		};
		
		_ctrlKillfeed = uiNamespace getVariable ["HALs_ctrlKillfeed", controlNull];
		if (HALs_killfeed_showKillfeed) then {
			_ctrlKillfeed ctrlSetFade 0;
			_ctrlKillfeed ctrlCommit 0;
			
			_ctrlsArr = HALs_killfeed_controls apply {
				_x params ["_ctrlText", "_status", "_statusChangeAt"];

				if (diag_tickTime >= _statusChangeAt) then {
					switch (_status) do {
						case 0: {
							_ctrlText ctrlSetFade 1;
							_ctrlText ctrlCommit 0.25;
							_x = [_ctrlText, 1, diag_tickTime + 1];
						};
						case 1:	{
							if (ctrlFade _ctrlText isEqualTo 1) then {
								ctrlDelete _ctrlText;
							};
						};
					};
				};
				_x
			};
			
			HALs_killfeed_controls = _ctrlsArr select {!isNull (_x select 0)};
			
			if (count HALs_killfeed_queue > 0) then {
				[HALs_killfeed_queue deleteAt 0] call HALs_fnc_updateKillfeed;
			};
		} else {
			_ctrlKillfeed ctrlSetFade 1;
			_ctrlKillfeed ctrlCommit 0;
		};
		
		HALs_killfeed_nextUpdate = diag_tickTime + HALs_kilfeed_updateDelay;
	}; 
}];
