/*
	Function: HALs_fnc_onUnitSpawned
	Author: HallyG
	Killfeed Module onUnitSpawned script.
	
	Argument(s):
	0: None
	
	Return Value:
	None
	
	Example:
	[] call HALs_fnc_onUnitSpawned;
__________________________________________________________________*/
{
	_x setVariable ["HALs_killfeed_handleDamageID",
		_x addEventHandler ["HandleDamage", {
			params ["_unit", "", "_damage", "_shooter", "_projectile", ""];
			if (!isNull _shooter) then {
				_unit setVariable ["HALs_killfeed_lastDamageSource", _projectile, true];
			};
			_damage
		}]
	];
} forEach (allUnits select {isNil {_x getVariable "HALs_killfeed_handleDamageID"}});
