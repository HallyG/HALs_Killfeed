/*
	Function: HALs_fnc_unitSpawned
	Author: HallyG
	UnitSpawned Eventhandler function.

	Argument(s):
	0: None

	Return Value:
	None

	Example:
	[] call HALs_fnc_unitSpawned;
__________________________________________________________________*/
{
	_x setVariable ["HALs_killfeed_handleDamageID",
		_x addEventHandler ["HandleDamage", {
			params ["_soldier", "_selection", "_damage", "_shooter", "_projectile", "_hitPointIndex"];

			if (!isNull _shooter) then {
				_soldier setVariable ["HALs_killfeed_lastDamageSource", _projectile, true];
			};

			_damage
		}]
	];
	false;
} count (allUnits select {isNil {_x getVariable "HALs_killfeed_handleDamageID"}});
