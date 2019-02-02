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

params [
	["_display", displayNull, [displayNull]]
];

//--- Create Killfeed
[_display, 3200] call HALs_fnc_createKillfeed;

//--- EntityKilled EVH
addMissionEventHandler ["EntityKilled", {
	params ["_killed", "_killer", "_instigator"];

	if ((typeOf _killed iskindOf "CAManBase")) then {
		private _projectile = _killed getVariable ["HALs_killfeed_lastDamageSource", ""];

		[_killed, _killer, _instigator, _projectile] call HALs_fnc_parseKill;
	};
}];

//--- UI Variables
HALs_killfeed_controls = [];
HALs_killfeed_queue = [];
HALs_killfeed_units = [];
HALs_killfeed_updateDelay = 0.25;
HALs_killfeed_nextUpdate = diag_tickTime;

addMissionEventHandler ["EachFrame", {
	_display = uiNamespace getVariable ["HALs_tdm_display_id", findDisplay 46];

	if (isNull _display) then {
		removeMissionEventHandler ["EachFrame", _thisEventhandler];
	};

	if (diag_tickTime > HALs_killfeed_nextUpdate) then {
		if !(HALs_killfeed_units isEqualTo allUnits) then {
			[] call HALs_fnc_unitSpawned;
			HALs_killfeed_units = allUnits;
		};

		_idc = uiNamespace getVariable ["HALs_killfeed_display_idc", 3200];
		if (HALs_killfeed_showKillfeed) then {
			(_display displayCtrl _idc) ctrlShow true;

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
								_x = -1;
							};
						};
					};
				};
				_x
			};

			//--- Remove old messages
			HALs_killfeed_controls = _ctrlsArr select {_x isEqualType []};

			//--- Show next message
			if (count HALs_killfeed_queue > 0) then {
				[HALs_killfeed_queue deleteAt 0] call HALs_fnc_updateKillfeed;
			};
		} else {
			(_display displayCtrl _idc) ctrlShow false;
		};

		HALs_killfeed_nextUpdate = diag_tickTime + HALs_killfeed_updateDelay;
	};
}];
