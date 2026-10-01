#define MAX_PLAYERS 1000
#define GTA_MINUTE_MS 1000

#include <open.mp>
#include <YSI_Data/y_iterate.inc>
#include <omp_gta_weather>


new gWorldHour = 0;
new gWorldMinute = 0;
new gWorldClockTimer = INVALID_TIMER;


main() {
    print("----------\nWeather cycler loaded.\n----------");
}

public OnFilterScriptInit() {

	print("+---------------------------------------------+");
	print("|  Loading Weather Cycler                     |");
	print("+---------------------------------------------+");

    //Set a random time each time script is loaded
    gWorldHour = random(24);
    gWorldMinute = random(60);
    
    //Set a random weather stage each time script is loaded
    GTAWeather_SetStage(random(GTA_WEATHER_CYCLE_LENGTH));

    SetWorldTime(gWorldHour);

    gWorldClockTimer = SetTimer("WorldClock_Update", GTA_MINUTE_MS, true);
    return true;
}

public OnFilterScriptExit() {
	print("+---------------------------------------------+");
	print("|  Unloading Weather cycler                   |");
	print("+---------------------------------------------+");
    if(gWorldClockTimer != INVALID_TIMER) {
        KillTimer(gWorldClockTimer);
    }
	return true;
}

public OnPlayerConnect(playerid) {
    if(IsPlayerNPC(playerid)) return true; //NPCs don't care about time or weather

    //Set default values for each player
    GTAWeather_ResetPlayer(playerid);

    SetPlayerTime(playerid, gWorldHour, gWorldMinute);
    TogglePlayerClock(playerid, true);
    return true;
}

//Basic time progression
forward WorldClock_Update();
public WorldClock_Update() {
    gWorldMinute++;
    if (gWorldMinute == 60) {
        gWorldMinute = 0;
        gWorldHour++;
        if (gWorldHour == 24)
            gWorldHour = 0;
        OnWorldHourChange(gWorldHour);
    }
    OnWorldMinuteChange(gWorldHour, gWorldMinute);
    return true;
}

forward OnWorldMinuteChange(hour, minute);
public OnWorldMinuteChange(hour, minute) {
    foreach(new i : Player) {
        if(IsPlayerNPC(i)) continue; //NPCs don't care about time or weather
        SetPlayerTime(i, hour, minute);
        
        //Updates the weather in case player is moving between weather regions
        GTAWeather_UpdatePlayer(i);
    }
    return true;
}

forward OnWorldHourChange(hour);
public OnWorldHourChange(hour) {
    GTAWeather_Advance();

    foreach(new i : Player) {
        if(IsPlayerNPC(i)) continue; //NPCs don't care about time or weather

        //Force a weather update when hour changes to match GTA weather progression
        GTAWeather_UpdatePlayer(i, true);
    }
    return true;
}

public OnPlayerSpawn(playerid) {
    if(IsPlayerNPC(playerid)) return true; //NPCs don't care about time or weather

    //Force a weather update on spawn
    GTAWeather_UpdatePlayer(playerid, true);

    return true;
}
