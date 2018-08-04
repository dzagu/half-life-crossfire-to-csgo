void developersCrossFireFile()
{

	RegAdminCmd("sm_silah" , Command_Silah , ADMFLAG_ROOT );
	RegAdminCmd("sm_nesne" , Command_Nesne , ADMFLAG_ROOT );

}

public Action Command_Nesne( int client , int args )
{

	int aim = GetClientAimTarget( client, false );
	char modelname[128];
	GetEntPropString(aim, Prop_Data, "m_ModelName", modelname, 128);
    AcceptEntityInput(134, "Lock"); 
    AcceptEntityInput(134, "UnLock"); 

	PrintToChatAll("Nesne => %d" , aim );
	PrintToChatAll("Model => %s" , modelname );

}

public Action Command_Silah( int client , int args )
{

	char arg1[32] , arg2[8] , arg3[8] , arg4[8];
	GetCmdArg( 1 , arg1 , 32 );
	GetCmdArg( 2 , arg2 , 8 );
	GetCmdArg( 3 , arg3 , 8 );
	GetCmdArg( 4 , arg4 , 8 );

	float position[3];
	position[0] = StringToFloat( arg2 );
	position[1] = StringToFloat( arg3 );
	position[2] = StringToFloat( arg4 );

    createWeapon(  arg1 , position );

}