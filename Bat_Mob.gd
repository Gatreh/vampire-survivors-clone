extends Mob_Behavior

var DEFAULT_STATS = {
	"HEALTH" : 5,
	"SPEED": 600,
	"DAMAGE": 2,
	"RANGE": 0,
	"LIFETIME": 0.00 # in seconds
}

func SetStats():
	
	for stat in STATS:
		if STATS[stat] == 0:
			STATS[stat] = DEFAULT_STATS[stat]
