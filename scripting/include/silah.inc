/***********************************************************/
/**************** CLIENT SET WEAPON AMMO *******************/
/***********************************************************/
stock bool Client_SetWeaponAmmoIndex(int client, int weapon, int primaryAmmo=-1, int secondaryAmmo=-1, int primaryClip=-1, int secondaryClip=-1)
{
	if(weapon ==-1) return false;
	if (primaryClip != -1) 
	{
		Weapon_SetPrimaryClip(weapon, primaryClip);
	}
	if(secondaryClip != -1) 
	{
		Weapon_SetSecondaryClip(weapon, secondaryClip);
	}
	Client_SetWeaponPlayerAmmoEx(client, weapon, primaryAmmo, secondaryAmmo);
	
	return true;
}

/***********************************************************/
/**************** CLIENT SET WEAPON AMMO *******************/
/***********************************************************/
stock bool Client_SetWeaponAmmo(int client, const char[] className, int primaryAmmo=-1, int secondaryAmmo=-1, int primaryClip=-1, int secondaryClip=-1)
{
	int weapon = Client_GetWeapon(client, className);
	
	if (weapon == INVALID_ENT_REFERENCE) 
	{
		return false;
	}
	
	if (primaryClip != -1) 
	{
		Weapon_SetPrimaryClip(weapon, primaryClip);
	}
	if(secondaryClip != -1) 
	{
		Weapon_SetSecondaryClip(weapon, secondaryClip);
	}
	Client_SetWeaponPlayerAmmoEx(client, weapon, primaryAmmo, secondaryAmmo);
	
	return true;
}

/***********************************************************/
/******************* CLIENT GET WEAPON *********************/
/***********************************************************/
stock int Client_GetWeapon(int client, const char[] className)
{
	int offset = Client_GetWeaponsOffset(client) - 4;
	int weapon = INVALID_ENT_REFERENCE;
	for (int i=0; i < MAX_WEAPONS; i++) 
	{
		offset += 4;
		
		weapon = GetEntDataEnt2(client, offset);
		
		if (!Weapon_IsValid(weapon)) 
		{
			continue;
		}
		
		if (Entity_ClassNameMatches(weapon, className)) 
		{
			return weapon;
		}
	}

	return INVALID_ENT_REFERENCE;
}

/***********************************************************/
/*************** ENTITY CLASSNAME MATCHES ******************/
/***********************************************************/
stock bool Entity_ClassNameMatches(int entity, const char[] className, bool partialMatch=false)
{
	char entity_className[64];
	Entity_GetClassName(entity, entity_className, sizeof(entity_className));

	if (partialMatch) 
	{
		return (StrContains(entity_className, className) != -1);
	}

	return StrEqual(entity_className, className);
}

/***********************************************************/
/***************** ENTITY GET CLASSNAME ********************/
/***********************************************************/
stock int Entity_GetClassName(int entity, char[] buffer, int size)
{
	return GetEntPropString(entity, Prop_Data, "m_iClassname", buffer, size);	
}

/***********************************************************/
/******************** WEAPON IS VALID **********************/
/***********************************************************/
stock int Weapon_IsValid(int weapon)
{
	if (!IsValidEdict(weapon)) 
	{
		return false;
	}
	
	return Entity_ClassNameMatches(weapon, "weapon_", true);
}

/***********************************************************/
/*************** GET WEAPON CLIENT OFFSET ******************/
/***********************************************************/
stock int Client_GetWeaponsOffset(int client)
{
	int offset = -1;

	if (offset == -1) 
	{
		offset = FindDataMapOffs(client, "m_hMyWeapons");
	}
	
	return offset;
}

/***********************************************************/
/**************** GET PRIMARY CLIP WEAPON ******************/
/***********************************************************/
stock int Weapon_GetPrimaryClip(int weapon)
{
	return GetEntProp(weapon, Prop_Data, "m_iClip1");
}

/***********************************************************/
/**************** GET PRIMARY CLIP WEAPON ******************/
/***********************************************************/
stock int Weapon_GetSecondaryClip(int weapon)
{
	return GetEntProp(weapon, Prop_Data, "m_iClip2");
}

/***********************************************************/
/**************** SET PRIMARY CLIP WEAPON ******************/
/***********************************************************/
stock int Weapon_SetPrimaryClip(int weapon, int value)
{
	SetEntProp(weapon, Prop_Data, "m_iClip1", value);
}

/***********************************************************/
/************** SET SECONDARY CLIP WEAPON ******************/
/***********************************************************/
stock int Weapon_SetSecondaryClip(int weapon, int value)
{
	SetEntProp(weapon, Prop_Data, "m_iClip2", value);
}

/***********************************************************/
/**************** SET AMMO PLAYER WEAPON *******************/
/***********************************************************/
stock void Client_SetWeaponPlayerAmmoEx(int client, int weapon, int primaryAmmo=-1, int secondaryAmmo=-1)
{
	int offset_ammo = FindDataMapOffs(client, "m_iAmmo");

	if (primaryAmmo != -1) 
	{
		int offset = offset_ammo + (Weapon_GetPrimaryAmmoType(weapon) * 4);
		PrintToChat(client,"TEST => %d",primaryAmmo);
		SetEntData(client, offset, primaryAmmo, 4, true);
	}

	if (secondaryAmmo != -1) 
	{
		int offset = offset_ammo + (Weapon_GetSecondaryAmmoType(weapon) * 4);
		SetEntData(client, offset, secondaryAmmo, 4, true);
	}
}

/***********************************************************/
/***************** GET PRIMARY AMMO TYPE *******************/
/***********************************************************/
stock int Weapon_GetPrimaryAmmoType(int weapon)
{
	return GetEntProp(weapon, Prop_Data, "m_iPrimaryAmmoType");
}

/***********************************************************/
/**************** GET SECONDARY AMMO TYPE ******************/
/***********************************************************/
stock int Weapon_GetSecondaryAmmoType(int weapon)
{
	return GetEntProp(weapon, Prop_Data, "m_iSecondaryAmmoType");
}

/***********************************************************/
/******************** GET PRIMARY AMMO *********************/
/***********************************************************/
stock int GetPrimaryAmmo(int client, int weapon)
{
    int ammotype = Weapon_GetPrimaryAmmoType(weapon);
    if(ammotype == -1) 
	{
		return -1;
	}
    
    return GetEntProp(client, Prop_Send, "m_iAmmo", _, ammotype);
}