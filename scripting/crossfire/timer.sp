public Action Timer_SpeedPlayer( Handle timer , int userid )
{

	int client = GetClientOfUserId( userid );
	if( client > 0 )
		SetEntPropFloat( client , Prop_Data, "m_flLaggedMovementValue", 1.45 );

	return Plugin_Stop;
}

public Action Timer_NukleerStarted( Handle timer )
{

	kuleGirisKontrol( "Close" );
	_Timer_NukleerFinished = CreateTimer( 17.0 , Timer_NukleerFinished );

	_Timer_NukleerStarted = INVALID_HANDLE;
	return Plugin_Stop;
}

public Action Timer_NukleerFinished( Handle timer )
{

	kuleGirisKontrol( "Open" );
	_Timer_NukleerRestart = CreateTimer( 80.0 , Timer_NukleerRestart );

	_Timer_NukleerFinished = INVALID_HANDLE;
	return Plugin_Stop;
}

public Action Timer_NukleerRestart( Handle timer )
{

	AcceptEntityInput( NUKLEER_CONSOLE_BUTTON , "UnLock");
	AcceptEntityInput( NUKLEER_CONSOLE , "Open");
	
	_Timer_NukleerRestart = INVALID_HANDLE;
	return Plugin_Stop;
}

public Action Timer_AmbientWeaponSound( Handle timer , int weapon ) 
{

	if( IsValidEdict( weapon ) )
	{

		float vecAngVectors[3];
		GetEntPropVector(weapon, Prop_Data, "m_vecOrigin", vecAngVectors); 
		EmitAmbientSoundAny( CROSSFIRE_RESPAWN_WEAPON_SOUND , vecAngVectors , _ , _ , _ , 1.0);  

	}

    return Plugin_Stop; 
}  

public Action Timer_removeWeapon( Handle timer , int weapon ) 
{

	if( IsValidEdict( weapon ) )
	{

		RemoveEdict(weapon);
			
	}

    return Plugin_Stop; 
} 