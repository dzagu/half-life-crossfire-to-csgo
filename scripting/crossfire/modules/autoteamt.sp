
void BBCrossFireAutoTeamT_OnPluginStart() 
{     

    AddCommandListener(OnJoinTeam, "jointeam"); 

} 

void BBCrossFireAutoTeamT_OnClientPostAdminCheck(int client)
{

	ClientCommand(client, "jointeam 02");

}

public Action OnJoinTeam(int client, char[] commands, int args) 
{ 

    if( client <= 0 ) 
        return Plugin_Continue; 
     
    ChangeClientTeam(client , 2);
    return Plugin_Handled; 
}  