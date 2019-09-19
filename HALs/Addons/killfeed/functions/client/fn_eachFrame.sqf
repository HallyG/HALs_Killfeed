/*
	Function: HALs_killfeed_fnc_eachFrame
	Author: HallyG
	Eachframe Eventhandler.

	Argument(s):
	0: None

	Return Value:
	None

	Example:
	[] call HALs_killfeed_fnc_eachFrame;
__________________________________________________________________*/
#define DELAY 0.25

_display = uiNamespace getVariable ["HALs_killfeed_idd", findDisplay 46];
_ctrlGroup = uiNamespace getVariable ["HALs_killfeed_idc", controlNull];

if (isNull _display) then {
    uiNamespace setVariable ["HALs_killfeed_idd", nil];
    uiNamespace setVariable ["HALs_killfeed_idc", nil];
    removeMissionEventHandler ["EachFrame", _thisEventhandler];
};

if (diag_tickTime > HALs_killfeed_nextUpdate) then {
    _units = allUnits select {isNil {_x getVariable "HALs_killfeed_handleDamageEVH"}};
    if (count _units > 0) then {{_x call HALs_killfeed_handleDamageCode} count _units};

    _ctrls = _ctrlGroup getVariable ["ctrls", []];
    if (count _ctrls > 0) then {
        {
            private _status = _x getVariable ["status", 0];
            private _lifetime = _x getVariable ["lifetime", diag_tickTime];

            switch _status do {
                case 0: {
                    _x ctrlSetFade 0;
                    _status = 1;
                    _lifetime = diag_tickTime + 3;
                };

                case 1:	{
                    if (diag_tickTime > _lifetime) then {
                        _x ctrlSetFade 1;
                        _status = 2;
                        _lifetime = diag_tickTime + 0.5;
                    };
                };

                case 2: {
                    if (diag_tickTime > _lifetime) then {
                        ctrlDelete _x;
                    };
                };
            };

            _x setVariable ["status", _status];
            _x setVariable ["lifetime", _lifetime];
            _x ctrlCommit 0.2;
            isNull _x
        } count _ctrls;

        _ctrlGroup setVariable ["ctrls", _ctrls select {!isNull _x}];
    };

    if (count HALs_killfeed_queue > 0) then {
        [HALs_killfeed_queue deleteAt 0] call HALs_killfeed_fnc_updateKillfeed;
    };

    HALs_killfeed_nextUpdate = HALs_killfeed_nextUpdate + DELAY;
};
