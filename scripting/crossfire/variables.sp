#define NUKLEER_LEFT_TOWER 130
#define NUKLEER_RIGHT_TOWER 131
#define NUKLEER_CONSOLE 108
#define NUKLEER_CONSOLE_BUTTON 134

#define CROSSFIRE_START_SOUND "/bb-crossfire-sound.mp3"
#define CROSSFIRE_PICKUP_WEAPON_SOUND "/bb-reload1.mp3"
#define CROSSFIRE_RESPAWN_WEAPON_SOUND "/suitchargeok1.wav"

#define CROSSFIRE_BB_TAG "{red}[BB CrossFire]{default}"

enum mapWeapons
{

	String:_weaponName[ 32 ],
	Float:_weaponCoordinate[3]

}

int mapWeaponArray[64][ mapWeapons ] , weaponCounter;
Handle _Timer_NukleerFinished = INVALID_HANDLE;
Handle _Timer_NukleerRestart  = INVALID_HANDLE;
Handle _Timer_NukleerStarted  = INVALID_HANDLE;