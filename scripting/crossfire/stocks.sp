void BBCrossFireCore_OnMapStart()
{

	ReadConfig();

	downloadAndPrecacheSoundFile( CROSSFIRE_START_SOUND );
	downloadAndPrecacheSoundFile( CROSSFIRE_PICKUP_WEAPON_SOUND );
	downloadAndPrecacheSoundFile( CROSSFIRE_RESPAWN_WEAPON_SOUND );

}

void BBCrossFireCore_RoundStart()
{

	clearTimers();

	releaseWeapons();
	releaseRoundStartNukleer();

}

void BBCrossFireCore_OnPlayerSpawn( int userid )
{

	CreateTimer( 0.01 , Timer_SpeedPlayer , userid);

}

void downloadAndPrecacheSoundFile( char[] name )
{

	char text[256];
	Format( text , 256 , "sound%s" , name );
	AddFileToDownloadsTable( text );
	PrecacheSoundAny( name );

}

bool IsValidClient( int client ) 
{ 
    if ( !( 1 <= client <= MaxClients ) || !IsClientInGame(client) || !IsPlayerAlive(client) ) 
        return false; 
     
    return true; 
}

int createWeapon( char[] weaponName , float position[3] )
{

   	int weapon = CreateEntityByName( weaponName ); 
    if( !IsValidEntity( weapon ) ) 
    	return -1;

    DispatchSpawn(weapon); 
    TeleportEntity(weapon, position, NULL_VECTOR, NULL_VECTOR); 
    return weapon;
}

void ReadConfig()
{

	weaponCounter = 0;

	char configPath[256];
	BuildPath(Path_SM, configPath, sizeof(configPath), "configs/crossfire.cfg");
	
	KeyValues kv = new KeyValues("Crossfire Config");

	if(!kv.ImportFromFile(configPath))
		return;

    if(!kv.GotoFirstSubKey(true))
   	{

		CloseHandle(kv);
		return;
   	}
	
	char name[32];
    float vector[3];

	do {

		kv.GetSectionName( name ,  64 );

		if( StrEqual( name , "weapons" ) )
		{

			if( kv.GotoFirstSubKey(true)  )
			{
				do
	    		{

					kv.GetString("weapon", mapWeaponArray[ weaponCounter ][ _weaponName ]  , 32);

			        kv.GetVector("coordinate", vector);
			        mapWeaponArray[ weaponCounter ][ _weaponCoordinate ] = vector;

			        weaponCounter++;
				}
	    		while( kv.GotoNextKey(false) );

	    		kv.GoBack();
			}

		}

	} while (kv.GotoNextKey(false));

	delete kv;	
}

void releaseWeapons()
{	

	float position[3];

	for( int i = 0; i < weaponCounter; i++ )
	{

		position[0] = mapWeaponArray[ i ][ _weaponCoordinate ][0];
		position[1] = mapWeaponArray[ i ][ _weaponCoordinate ][1];
		position[2] = mapWeaponArray[ i ][ _weaponCoordinate ][2];

        createWeapon( mapWeaponArray[ i ][ _weaponName ] , position );

	}

}

void releaseRoundStartNukleer()
{

	kuleGirisKontrol( "Open" );
	AcceptEntityInput( NUKLEER_CONSOLE , "Open");
	AcceptEntityInput( NUKLEER_CONSOLE_BUTTON , "UnLock");

}

void kuleGirisKontrol(char[] command)
{

	AcceptEntityInput( NUKLEER_LEFT_TOWER , command);
	AcceptEntityInput( NUKLEER_RIGHT_TOWER , command);

}

void clearTimers()
{

	if( _Timer_NukleerFinished != INVALID_HANDLE )
	{

		KillTimer( _Timer_NukleerFinished );
		_Timer_NukleerFinished = INVALID_HANDLE;
	}

	if( _Timer_NukleerRestart != INVALID_HANDLE )
	{

		KillTimer( _Timer_NukleerRestart );
		_Timer_NukleerRestart = INVALID_HANDLE;
	}

	if( _Timer_NukleerStarted != INVALID_HANDLE )
	{

		KillTimer( _Timer_NukleerStarted );
		_Timer_NukleerStarted = INVALID_HANDLE;
	}

}