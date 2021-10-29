public Plugin myinfo =
{
	name = "Panorama Text",
	description = "Panorama Text",
	author = "mat3",
	version = "1.0.0",
	url = "https://github.com/mat3e1245"
};

bool g_bPanorama[MAXPLAYERS + 1];


public void ClientConVar(QueryCookie hCookie, int iClient, ConVarQueryResult hResult, const char[] sCvarName, const char[] sCvarValue)
{
   if(hResult == ConVarQuery_Okay) g_bPanorama[iClient] = true; 
}

public void OnClientDisconnect(int iClient)
{
	g_bPanorama[iClient] = false;
}

public void OnClientPutInServer(int iClient) 
{
   QueryClientConVar(iClient, "@panorama_debug_overlay_opacity", ClientConVar);
}

public void OnMapStart() 
{
	CreateTimer(1.0, Timer_UPDATE, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

public Action Timer_UPDATE(Handle timer)
{
	int timeleft;
	char sBuf[255];
	GetMapTimeLeft(timeleft);
	if(timeleft > 0) FormatEx(sBuf, sizeof sBuf, "Timeleft - %d:%02d", timeleft / 60, timeleft % 60);
	else sBuf = "| starwand |";
	SetHudTextParams(-1.0, 0.99, 1.5, 100, 100, 250, 0);
	for(int iClient = 1; iClient <= MaxClients; iClient++)
	{
		if(g_bPanorama[iClient])
		{			
			ShowHudText(iClient, 4, sBuf);
		}
	}
	return Plugin_Continue; 
}