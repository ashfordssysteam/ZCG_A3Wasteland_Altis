//	@file Version: 1.0
//	@file Name: serverPlayerDied.sqf
//	@file Author: [404] Pulse
//	@file Created: 20/11/2012 05:19

if (!isServer) exitWith {};

private ["_corpse", "_backpack"];
_corpse = _this select 0;
_corpse setVariable ["processedDeath", diag_tickTime];
_backpack = unitBackpack _corpse;

if (!isNull _backpack) then
{
	_backpack setVariable ["processedDeath", diag_tickTime];
};

if(!isNil "_corpse" && !isNull _corpse) then {
	diag_log text format ["Corpse: %1", _corpse];
	_nearEntites = _corpse nearEntities ["All", 20];

	if(!isNil "_nearEntites" && {count _nearEntites > 0}) then
	{
		{
			if (owner _x == owner _corpse && {!isNil {_x getVariable "mf_item_id"}}) then
			{
				_x setVariable ["processedDeath", diag_tickTime];
			};
		} forEach (_nearEntites);
	};
};

// Remove any persistent info about the player on death
if ((call config_player_saving_enabled) == 1) then {
	(getPlayerUID _corpse) call sqlite_deletePlayer;
};
