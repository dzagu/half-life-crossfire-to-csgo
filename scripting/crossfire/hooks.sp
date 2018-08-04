void BBCrossFire_OnPluginStart()
{

	BBCrossFireAutoTeamT_OnPluginStart();

}

void BBCrossFire_OnClientPostAdminCheck( int client )
{

	BBCrossFireAutoTeamT_OnClientPostAdminCheck( client );

}

void BBCrossFire_OnMapStart()
{

	BBCrossFireCore_OnMapStart();
	BBCrossFireJongJump_OnMapStart();
	
}

void BBCrossFire_RoundStart()
{

	BBCrossFireCore_RoundStart();
	BBCrossFireLongJump_RoundStart();

}

void BBCrossFire_OnPlayerSpawn( int userid )
{

	BBCrossFireCore_OnPlayerSpawn( userid );
	BBCrossFireJongJump_OnPlayerSpawn( userid );

}


void BBCrossFire_OnClientDisconnect( int client )
{

	BBCrossFireLongJump_OnClientDisconnect( client );

}


void BBCrossFire_OnPlayerRunCmd( int client )
{

	BBCrossFireLongJump_OnPlayerRunCmd( client );

}

public Action CS_OnCSWeaponDrop(int client, int weapon) 
{ 

	if( IsValidEdict( weapon ) )
	    AcceptEntityInput(weapon, "Kill"); 

	return Plugin_Continue;
}  

public void OnEntityCreated( int entity , const char[] classname )
{

	if( StrEqual( classname , "weapon_negev") )
	{

		CreateTimer( 0.1 , Timer_removeWeapon , entity , TIMER_FLAG_NO_MAPCHANGE);

	}	
	else if( StrContains(classname, "weapon_", false) == 0 )
	{

		CreateTimer( 0.1 , Timer_AmbientWeaponSound , entity , TIMER_FLAG_NO_MAPCHANGE);

	}

}

public void OnClientPutInServer(int client)
{

    SDKHook(client, SDKHook_WeaponEquip, Weapon_Pickup);

}

public Action Weapon_Pickup(int client, int entity)
{

	EmitSoundToClientAny( client , CROSSFIRE_PICKUP_WEAPON_SOUND , _ , 6);
	return Plugin_Continue;
}

public Action Function_ButtonPress(const char[] output, int caller,int activator, float delay)
{

	if( !IsValidClient( activator ) ) 
		return;

	char buttonName[64];
	GetEntPropString(caller, Prop_Data, "m_iName", buttonName, sizeof(buttonName));

	if( StrEqual( buttonName , "button5" ) )
	{

		char username[MAX_NAME_LENGTH];
		GetClientName(activator, username, sizeof(username));		
		CPrintToChatAll("%s %T" , CROSSFIRE_BB_TAG , "NukleerStarted" , activator , username);

		EmitSoundToAllAny( CROSSFIRE_START_SOUND , _ , 7);
		AcceptEntityInput( NUKLEER_CONSOLE_BUTTON , "Lock");
		_Timer_NukleerStarted = CreateTimer( 48.0 , Timer_NukleerStarted );

	}

}