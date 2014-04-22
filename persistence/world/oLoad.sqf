// WARNING! This is a modified version for use with the GoT Wasteland v2 missionfile!
// This is NOT a default persistantdb script!
// changes by: JoSchaap (GoT2DayZ.nl)
diag_log "oLoad started";
sleep 10;
call sqlite_deleteUncommitedObjects;
_objectscount = call sqlite_countObjects;
diag_log text format ["Loading %1 objects", _objectscount];
if (isNil "_objectscount" || _objectscount == 0) exitWith {isLoadingObjects = false;};

isLoadingObjects = true;

_vehicles = +civilianVehicles + +lightMilitaryVehicles + +mediumMilitaryVehicles + +staticHeliList;

_stepSize = 20;

for "_i" from 0 to (_objectscount) step _stepSize do
{
	_objects = [_i, _stepSize] call sqlite_loadBaseObjects;
	
	{
		_class = _x select 1;
		_pos = call compile (_x select 2);
		_dir = call compile (_x select 3);
		_supplyleft = parseNumber (_x select 4);
		_weapons = call compile (_x select 5);
		_magazines = call compile (_x select 6);
		_items = call compile (_x select 7);
		_isVehicle = parseNumber (_x select 8);
		_generationCount = parseNumber (_x select 11);
		_owner = (_x select 12);
		_damageVal = parseNumber (_x select 13);
		_allowDamage = parseNumber (_x select 14);
	
		
		if (!isNil "_class" && !isNil "_pos" && !isNil "_dir" && !isNil "_supplyleft") then 
		{
			_type = "NONE";
			_placement = 10;
			
			if(!isNil "_isVehicle" && _isVehicle == 0 && ["Box_", _class] call fn_findString != 0) then
			{
				_type = "CAN COLLIDE";
				_placement = 0;
			};
			
			if(["Box_", _class] call fn_findString == 0) then {
				_placement = 0;
				_allowDamage = 0;
			};
			
			_obj = createVehicle [_class, _pos, [], _placement, _type];
			_obj setPosASL _pos;
			_obj setVectorDirAndUp _dir;
			
			//Fix position for more accurate positioning
			_posX = (_pos select 0);
			_posY = (_pos select 1);
			_posZ = (_pos select 2);
			
			_currentPos = getPosASL _obj;
			
			_fixX = (_currentPos select 0) - _posX;
			_fixY = (_currentPos select 1) - _posY;
			_fixZ = (_currentPos select 2) - _posZ;
		
			_obj setPosASL [(_posX - _fixX), (_posY - _fixY), (_posZ - _fixZ)];
			
			if (_allowDamage > 0) then
			{
				_obj setDamage _damageVal;
				_obj setVariable ["allowDamage", true];
			}
			else
			{
				_obj setDamage 0;
				_obj allowDamage false;
				_obj setVariable ["allowDamage", false];
			};

			if (_class == "Land_Sacks_goods_F") then 
			{
				_obj setVariable["food",_supplyleft,true];
			};

			if (_class == "Land_BarrelWater_F") then 
			{
				_obj setVariable["water",_supplyleft,true];
			};

			clearWeaponCargoGlobal _obj;
			clearMagazineCargoGlobal _obj;
			clearItemCargoGlobal _obj;

			// disabled because i dont want to load contents just base parts
			for "_ii" from 0 to (count (_weapons select 0) - 1) do
			{
				_obj addWeaponCargoGlobal [(_weapons select 0) select _ii, (_weapons select 1) select _ii];
			};

			for "_ii" from 0 to (count (_magazines select 0) - 1) do
			{
				_obj addMagazineCargoGlobal [(_magazines select 0) select _ii, (_magazines select 1) select _ii];
			};
			
			for "_ii" from 0 to (count (_items select 0) - 1) do {
				_obj addItemCargoGlobal [(_items select 0) select _ii, (_items select 1) select _ii];
			};
			
			_obj setVariable ["objectLocked", true, true]; //force lock
			_obj setVariable ["ownerUID", _owner, true]; // Set owner id
			_obj setVariable ["generationCount", _generationCount + 1, true];
			
			diag_log text format ["Loaded %1", _class];
		};
	} forEach _objects;
	
	SendMessageToClients = format ["Loaded %1 vehicles and base parts", (_i + _stepSize)];
	publicVariable "SendMessageToClients";
};

isLoadingObjects = false;

diag_log format["A3Wasteland - baseSaving loaded %1 parts from DB", _objectscount];

SendMessageToClients = "Base and Vehicle loading done";
publicVariable "SendMessageToClients";
