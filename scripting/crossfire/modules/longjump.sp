#define CROSSFIRE_LONGJUMP_ON_SOUND "/powermove_on.mp3"

int	clientLastButtons[ MAXPLAYERS + 1 ];
int clientJumpCounter[ MAXPLAYERS + 1 ];
int clientLastFlags[ MAXPLAYERS + 1 ];
int clientLongJumpHas[ MAXPLAYERS + 1 ] = { false , ...};

Handle longJumpRespawn_Timer = INVALID_HANDLE;

float longJumpRespawnCoordinate[3] = { 835.00 , 457.00 , -1845.00 };

void BBCrossFireJongJump_OnMapStart()
{

	AddFileToDownloadsTable("models/weapons/w_longjump_mp.dx80.vtx");
	AddFileToDownloadsTable("models/weapons/w_longjump_mp.dx90.vtx");
	AddFileToDownloadsTable("models/weapons/w_longjump_mp.mdl");
	AddFileToDownloadsTable("models/weapons/w_longjump_mp.phy");
	AddFileToDownloadsTable("models/weapons/w_longjump_mp.sw.vtx");
	AddFileToDownloadsTable("models/weapons/w_longjump_mp.vvd");

	AddFileToDownloadsTable("materials/models/world_models/longjump_mp.vmt");
	AddFileToDownloadsTable("materials/models/humans/hev_suit/longjump_diffuse.vmt");
	AddFileToDownloadsTable("materials/models/humans/hev_suit/longjump_diffuse.vtf");
	AddFileToDownloadsTable("materials/models/humans/hev_suit/longjump_metal.vmt");
	AddFileToDownloadsTable("materials/models/humans/hev_suit/longjump_normals.vtf");
	AddFileToDownloadsTable("materials/models/humans/hev_suit/longjump_rubber.vmt");
	
	PrecacheModel("models/weapons/w_longjump_mp.mdl");	

	downloadAndPrecacheSoundFile( CROSSFIRE_LONGJUMP_ON_SOUND );

}

void BBCrossFireJongJump_OnPlayerSpawn( int userid )
{

	int client = GetClientOfUserId( userid );
	if( client > 0 )
		clientLongJumpHas[ client ] = false;

}

void BBCrossFireLongJump_OnClientDisconnect( int client )
{

	clientLongJumpHas[ client ] = false;

}

void BBCrossFireLongJump_OnPlayerRunCmd( int client )
{

	int clientFlag   = GetEntityFlags(client);
	int clientButton = GetClientButtons(client);

	if( !clientLongJumpHas[ client ] )
	{

		if (clientLastFlags[client] & FL_ONGROUND)
		{

			if (!(clientFlag & FL_ONGROUND) && !(clientLastButtons[client] & IN_JUMP) && clientButton & IN_JUMP)
			{

				OriginalJump(client);

			}

		}
		else if (clientFlag & FL_ONGROUND)
		{

			Landed(client);

		}
		else if (!(clientLastButtons[client] & IN_JUMP) && clientButton & IN_JUMP)
		{

			ReJump(client);

		}

	}

	if( clientLongJumpHas[ client ] && !(clientLastButtons[client] & IN_JUMP) && clientLastButtons[ client ] & IN_DUCK && clientButton & IN_JUMP )
	{

		LongJump(client);

	}

	clientLastFlags[client]   = clientFlag;
	clientLastButtons[client] = clientButton;

}

void BBCrossFireLongJump_RoundStart()
{

	if( longJumpRespawn_Timer != INVALID_HANDLE )
	{

		KillTimer( longJumpRespawn_Timer );
		longJumpRespawn_Timer = INVALID_HANDLE;

	}

	createLongJumpModule( longJumpRespawnCoordinate );

}


void OriginalJump( int client)
{
	clientJumpCounter[client]++;
}

void Landed( int client)
{
	clientJumpCounter[client] = 0;
}

void ReJump( int client)
{

	if ( 1 <= clientJumpCounter[client] <= 1)
	{

		clientJumpCounter[client]++;

		float vVel[3];
		GetEntPropVector(client, Prop_Data, "m_vecVelocity", vVel);
		vVel[2] = 375.00;
		TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vVel);

	}
}

void LongJump(int client)
{

    float vPlayerVelocity[3];
    float vPlayerEyeAngles[3];
    float vPlayerForward[3] , origin[3];
    
    GetEntPropVector(client, Prop_Data, "m_vecVelocity", vPlayerVelocity);
    
    GetClientEyeAngles(client, vPlayerEyeAngles);
    GetAngleVectors(vPlayerEyeAngles, vPlayerForward, NULL_VECTOR, NULL_VECTOR);
    
    origin[0] = ( vPlayerVelocity[0] * 0.30 - vPlayerForward[0] * 650.00 ) * -1;
    origin[1] = ( vPlayerVelocity[1] * 0.30 - vPlayerForward[1] * 650.00 ) * -1;
    origin[2] = vPlayerVelocity[2];

	TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, origin);
}

void createLongJumpModule( float coordinate[3] )
{

	int entity = CreateEntityByName("prop_dynamic");
    DispatchKeyValue(entity, "model", "models/weapons/w_longjump_mp.mdl");
	DispatchKeyValue(entity, "solid", "6");
	DispatchSpawn(entity);

    SetEntProp (entity, Prop_Send, "m_usSolidFlags", 12); // FSOLID_NOT_SOLID | FSOLID_TRIGGER
    SetEntProp (entity, Prop_Data, "m_nSolidType", 6); // SOLID_VPHYSICS
    SetEntProp (entity, Prop_Send, "m_CollisionGroup", 1); // COLLISION_GROUP_DEBRIS
    SDKHook(entity, SDKHook_StartTouch, LongJumpModule);

    float angle[3];
    angle[0] = -90.0;
    angle[1] = 0.0;
    angle[2] = 0.0;

  	TeleportEntity(entity, coordinate, angle, NULL_VECTOR);

}

public void LongJumpModule(int entity, int client)
{

    SDKUnhook(entity, SDKHook_StartTouch, LongJumpModule);
    RemoveEdict( entity );
	clientLongJumpHas[ client ] = true;

    CPrintToChat( client , "%s %T" , CROSSFIRE_BB_TAG , "LongJumpEquiped" , client );
	EmitSoundToClientAny( client , CROSSFIRE_LONGJUMP_ON_SOUND , _ , 6);

    longJumpRespawn_Timer = CreateTimer( 20.0 , respawnLongJump );

}  

public Action respawnLongJump( Handle timer , int args )
{

	createLongJumpModule( longJumpRespawnCoordinate );
	longJumpRespawn_Timer = INVALID_HANDLE;
	return Plugin_Stop;
}