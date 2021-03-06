//	@file Version: 1.1
//	@file Name: hiddenMissionController.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap, Sanjo, AgentRev
//	@file Created: 08/12/2012 15:19

if (!isServer) exitWith {};
#include "hiddenMissions\hiddenMissionDefines.sqf";

private ["_hiddenMissions", "_hiddenMissionsOdds", "_missionType", "_nextMission", "_missionRunning1", "_missionRunning2", "_missionRunning3", "_hint"];
// private ["_mission", "_notPlayedhiddenMissions", "_nextMissionIndex"];

diag_log "WASTELAND SERVER - Started Side Mission State";

_hiddenMissions =
[			// increase the number behind the mission (weight) to increase the chance of the mission to be selected
	["mission_HostileHelicopter",0.5], 
	["mission_MiniConvoy", 1],
	["mission_Truck", 1],
	["mission_HostileSquad", 1],
	["mission_RoadBlock",1.5]
]; 

// _notPlayedhiddenMissions = +_hiddenMissions;

_hiddenMissionsOdds = [];
{
	_hiddenMissionsOdds set [_forEachIndex, if (count _x > 1) then { _x select 1 } else { 1 }];
	
	// Attempt to compile every mission for early bug detection
	compile preprocessFileLineNumbers format ["server\missions\hiddenMissions\%1.sqf", _x select 0];
} forEach _hiddenMissions;

//initialize missions
_nextMission = [_hiddenMissions, _hiddenMissionsOdds] call fn_selectRandomWeighted;
_missionType = _nextMission select 0;

_missionRunning1 = execVM format ["server\missions\hiddenMissions\%1.sqf", _missionType];

diag_log format["WASTELAND SERVER - Execute New Side Mission: %1",_missionType];

/*_nextMission = [_hiddenMissions, _hiddenMissionsOdds] call fn_selectRandomWeighted;
_missionType = _nextMission select 0;

_missionRunning2 = execVM format ["server\missions\hiddenMissions\%1.sqf", _missionType];

diag_log format["WASTELAND SERVER - Execute New Side Mission2: %1",_missionType];

_nextMission = [_hiddenMissions, _hiddenMissionsOdds] call fn_selectRandomWeighted;
_missionType = _nextMission select 0;

_missionRunning3 = execVM format ["server\missions\hiddenMissions\%1.sqf", _missionType];

diag_log format["WASTELAND SERVER - Execute New Side Mission3: %1",_missionType];*/

while {true} do
{
	if(scriptDone _missionRunning1) then 
	{
		_nextMission = [_hiddenMissions, _hiddenMissionsOdds] call fn_selectRandomWeighted;
		_missionType = _nextMission select 0;
		
		_missionRunning1 = execVM format ["server\missions\hiddenMissions\%1.sqf", _missionType];
		
		diag_log format["WASTELAND SERVER - Execute New Side Mission: %1",_missionType];
	};
	
	/*if(scriptDone _missionRunning2) then 
	{
		_nextMission = [_hiddenMissions, _hiddenMissionsOdds] call fn_selectRandomWeighted;
		_missionType = _nextMission select 0;
		
		_missionRunning2 = execVM format ["server\missions\hiddenMissions\%1.sqf", _missionType];
		
		diag_log format["WASTELAND SERVER - Execute New Side Mission: %1",_missionType];
		
	};
	
	if(scriptDone _missionRunning3) then 
	{
		_nextMission = [_hiddenMissions, _hiddenMissionsOdds] call fn_selectRandomWeighted;
		_missionType = _nextMission select 0;
		
		_missionRunning3 = execVM format ["server\missions\hiddenMissions\%1.sqf", _missionType];
		
		diag_log format["WASTELAND SERVER - Execute New Side Mission: %1",_missionType];

	};*/
	
	sleep 30;
};
