
#if defined _bbcolors_included
 #endinput
#endif

#define _bbcolors_included
 
#define MAX_MESSAGE_LENGTH 250

#define MAX_COLORS 17

char tagKisayol[][] = {
	"{default}", 
	"{teamcolor}", 
	"{red}", 
	"{lightred}", 
	"{darkred}", 
	"{bluegrey}", 
	"{blue}", 
	"{darkblue}", 
	"{purple}", 
	"{orchid}", 
	"{yellow}", 
	"{gold}", 
	"{lightgreen}", 
	"{green}", 
	"{lime}", 
	"{grey}", 
	"{grey2}", 
};

char tagCode[][] = {
	"\x01", 
	"\x03", 
	"\x07", 
	"\x0F", 
	"\x02", 
	"\x0A", 
	"\x0B", 
	"\x0C", 
	"\x03", 
	"\x0E", 
	"\x09", 
	"\x10", 
	"\x05", 
	"\x04", 
	"\x06", 
	"\x08", 
	"\x0D", 
};

stock void CPrintToChat(int client, const char[] szMessage, any ...)
{
	if (client <= 0 || client > MaxClients)
		ThrowError("Invalid client index %d", client);
	
	if (!IsClientInGame(client))
		ThrowError("Client %d is not in game", client);
	
	char szCMessage[MAX_MESSAGE_LENGTH];

	
	VFormat(szCMessage, sizeof(szCMessage), szMessage, 3);
	
	CFormat(szCMessage, sizeof(szCMessage));
	
	PrintToChat(client, "%s", szCMessage);
}

stock void CPrintToChatAll(const char[] szMessage, any ...)
{
	char szBuffer[MAX_MESSAGE_LENGTH];
	
	for(int i = 1; i <= MaxClients; i++)
	{
		if (i > 0 && IsClientInGame(i) && !IsFakeClient(i))
		{

			VFormat(szBuffer, sizeof(szBuffer), szMessage, 2);
			
			CPrintToChat(i, "%s", szBuffer);
		}
		
	}
}

stock void CFormat(char[] szMessage, int maxlength)
{
	
	Format(szMessage, maxlength, " %s", szMessage);

	for (int i = 0; i < MAX_COLORS; i++)
	{

		ReplaceString(szMessage, maxlength, tagKisayol[i], tagCode[i], false);

	}
	
}