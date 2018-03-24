/*
	Function: HALs_fnc_parseKill
	Author: HallyG
	Formats the killfeed message.
	
	Argument(s):
	0: None
	
	Return Value:
	None
	
	Example:
	[] call HALs_fnc_parseKill;
__________________________________________________________________*/
params [
	["_killed", objNull, [objNull]],
	["_killer", objNull, [objNull]],
	["_instigator", objNull, [objNull]],
	["_projectile", "", [""]]
];

if (isNull _killed) exitWith {};

private _uav = objNull;
if (isNull _instigator) then {
	_uav = _killer;
	_instigator = UAVControl vehicle _killer select 0;
};

if (!HALs_killfeed_showAIKills && {!isPlayer _killed && !isPlayer _instigator && !isPlayer _killer}) exitWith {};

try {
	if (_killed isEqualTo _killer) then {
		["%1 [%3] %2", _killed, _killed, "SUICIDE"]
	};
	
	if (isNull _killer && isNull _instigator) then {
		throw ["%1 [%3] %2", _killed, _killed, "SUICIDE"]
	};
	
	if ((vehicle _killed) isEqualTo _killer) then {
		throw ["%1 [%3] %2", _killed, _killed, "SUICIDE"]
	};
	
	if (isNull _instigator && {!alive _killer}) then {
		throw ["%1 [%3] %2", _killed, _killed, "KILLED"] //"EXP{LOSION"
	};
	
	if (isNull _instigator) then {
		throw ["%1 [%3] %2", _killer, _killed, "ROADKILL"]
	};

	//--- Find who actually killed the unit
	if (!isNull _instigator && !(_killer isEqualTo _instigator)) then {
		if (isNull _uav) then {
			// systemChat format ["%1", [_killer, _instigator]];
			// error when player is gunner of uav or gunner in chopper
			if (isNil {vehicle _instigator currentWeaponTurret (assignedVehicleRole _instigator select 1)}) then {
				throw ["%1 [%3] %2", _instigator, _killed, toUpper (getText (configFile >> "CfgVehicles" >> typeOf vehicle _instigator >> "displayName"))]
			} else {
				throw ["%1 [%3] %2", _instigator, _killed, toUpper (getText (configFile >> "CfgWeapons" >> vehicle _instigator currentWeaponTurret (assignedVehicleRole _instigator select 1) >> "displayName"))]
			};
		} else {
			if (((assignedVehicleRole _killer) select 0) == "driver") then {
				throw ["%1 [%3] %2", _instigator, _killed, "ROADKILL"]
			};
		};
	};

	//--- No killer? Must be from a gun or projectile.
	if (!isNull _instigator) then {
		_projectileType = call {
			_projectileSimul = toUpper getText (configFile >> "CfgAmmo" >> _projectile >> "simulation");
			
			if (_projectileSimul == "SHOTGRENADE") exitWith {"GRENADE"};
			if (_projectileSimul == "SHOTSHELL") exitWith {"EGLM HE"};
			if (_projectileSimul in ["SHOTMINE", "SHOTDIRECTIONALBOMB", "SHOTBOUNDINGMINE"]) exitWith {"EXPLOSIVE"};
			
			if (isClass (configFile >> "cfgWeapons" >> currentWeapon _instigator)) exitWith {
				getText (configFile >> "cfgWeapons" >> [currentWeapon _instigator] call BIS_fnc_baseWeapon >> "displayName")
				// "<img image='" + getText (configFile >> 'CfgWeapons' >> [currentWeapon _instigator] call BIS_fnc_baseWeapon >> 'picture') + "' size='1' />";
			};

			"KILLED"
		};
		
		throw ["%1 [%3] %2", _instigator, _killed, toUpper _projectileType]
	};

	throw ["%1 [%3] %2", _instigator, _killed, "KILLED"];
} catch {
	_exception params ["", "_killer", "_killed"];

	{
		_exception set [
			_forEachIndex + 1,
			format ["<t color='%2'>%1</t>", [getText (configFile >> "cfgVehicles" >> typeOf _x >> "displayName"), name _x] select (isPlayer _x), HALs_killfeed_sideColourArray select ([group _x] call HALs_fnc_getSideColour)]
		];
	} forEach [_killer, _killed];

	HALs_killfeed_queue pushBack (format ["<t align='left' shadow='2' shadowColor='#ff0000' font='RobotoCondensed'>%1</t>", format _exception]);
};