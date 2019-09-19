/*
	Function: HALs_killfeed_fnc_parseKill
	Author: HallyG, beno_83au
	Formats the killfeed message.

	Argument(s):
	0: Killed <OBJECT>
	1: Killer <OBJECT>
	2: Instigator <OBJECT>

	Return Value:
	None

	Example:
	[] call HALs_killfeed_fnc_parseKill;
__________________________________________________________________*/
params [
	["_killed", objNull],
	["_killer", objNull],
	["_instigator", objNull]
];

// Only show kills involving players
if (!HALs_killfeed_showAIKills && {!isPlayer _killed /*&& !isPlayer _killer && !isPlayer _instigator*/}) exitWith {};

private _projectile = _killed getVariable ["HALs_lastDamageSource", ""];
private _killData = switch (true) do {
	case (_killed isEqualTo _killer);
	case (_killed isEqualTo _instigator);
	case (isNull _killer && isNull _instigator);
	case ((vehicle _killed) isEqualTo _killer): {[_killed, _killed, "Suicide"]};
	case (!isNull _killer && isNull _instigator && _projectile isEqualTo ""): {
		if (isNull (UAVControl vehicle _killer select 0)) then {
			[_killer, _killed, "Roadkill"]
		} else {
			[UAVControl vehicle _killer select 0, _killed, "Roadkill"]
		};
	};

	case (_projectile != ""): {
		private _cause = switch (toUpper getText (configFile >> "CfgAmmo" >> _projectile >> "simulation")) do {
			case "SHOTGRENADE": {"Grenade"};
			case "SHOTSHELL": {"Grenade Launcher"};
			case "SHOTMINE";
			case "SHOTDIRECTIONALBOMB";
			case "SHOTBOUNDINGMINE": {"Mine"};
			case "ROCKET": {"Rocket"};
			default {""};
		};

		if (isNull _instigator) then {
			_instigator = _killer
		};

		if (_cause isEqualTo "") then {
			_cause = "Killed";

			if (_killer != _instigator) then {
				if (isNil {vehicle _instigator currentWeaponTurret (assignedVehicleRole _instigator select 1)}) then {
					_cause = getText (configfile >> "CfgVehicles" >> typeOf vehicle _instigator >> "displayName")
				} else {
					_cause = getText (configfile >> "CfgWeapons" >> vehicle _instigator currentWeaponTurret (assignedVehicleRole _instigator select 1) >> "displayName");
				};
			} else {
				if (isClass (configfile >> "cfgWeapons" >> currentWeapon _instigator)) then {
					_cause = getText (configfile >> "cfgWeapons" >> [currentWeapon _instigator] call BIS_fnc_baseWeapon >> "displayName");
				};
			};
		};

		[_instigator, _killed, _cause]
	};

	default {[]};
};

if (count _killData > 0) then {
	private _colourName = {
		format ["<t color='%2'>%1</t>",
			[getText (configFile >> "cfgVehicles" >> typeOf _this >> "displayName"), name _this] select (isPlayer _this),

			if (HALs_killfeed_sideColour) then {
				HALs_killfeed_colours select ([side group _this] call BIS_fnc_sideID)
			} else {
				private _grp = group _this;
				private _isGroup = _grp isEqualTo (group player);
				private _isSide = (side _grp) isEqualTo (side group player);

				HALs_killfeed_colours select ([2, [0, 1] select _isGroup] select _isSide);
			}
		]
	};

	HALs_killfeed_queue pushBack format ["%1 [%3] %2", (_killData#0) call _colourName, (_killData#1) call _colourName, _killData select 2];
};
