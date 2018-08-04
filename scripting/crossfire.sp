#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>
#include <bbcolors>
#include <emitsoundany>

#pragma semicolon 1
#pragma tabsize 0
#pragma newdecls required

#include "crossfire/variables.sp"
#include "crossfire/hooks.sp"
#include "crossfire/stocks.sp"
#include "crossfire/timer.sp"

/************** MODULES *************/

#include "crossfire/modules/longjump.sp"
#include "crossfire/modules/autoteamt.sp"

/************** MODULES *************/

/**************** DEVELOPERS FILES NOT USING ***********/
#include "crossfire/developers-crossfire-file.sp"
/**************** DEVELOPERS FILES NOT USING ***********/


public Plugin myinfo = {
	name        = "BB CrossFire",
	author      = "BOT Benson",
	description = "Half life crossfire to csgo",
	version     = "0.2.1"
};

public void OnPluginStart()
{

	LoadTranslations("bbcrossfire.phrases");

	HookEntityOutput("func_button", "OnPressed", Function_ButtonPress);
	HookEvent("round_start", RoundStart);
	HookEvent("player_spawn", OnPlayerSpawn);

	BBCrossFire_OnPluginStart();

	developersCrossFireFile();

	for( int i = 1; i <= MaxClients; i++ )
	{

		if( !IsClientInGame( i ) || IsFakeClient( i ) )
			continue;

		OnClientPutInServer( i );
			
	}

}

public void OnMapStart()
{

	BBCrossFire_OnMapStart();

}

public void OnClientPostAdminCheck( int client )
{

	BBCrossFire_OnClientPostAdminCheck( client );	

}

public void OnClientDisconnect( int client )
{

	BBCrossFire_OnClientDisconnect( client );

}

public Action OnPlayerRunCmd( int client, int &buttons )
{

	if( client <= 0 )
		return Plugin_Continue;

	BBCrossFire_OnPlayerRunCmd( client );

	return Plugin_Continue;
}

public Action RoundStart(Event event, const char[] name, bool dontBroadcast)
{

	BBCrossFire_RoundStart();

}

public Action OnPlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{

	BBCrossFire_OnPlayerSpawn( event.GetInt("userid") );

}