extends Mob_Behavior

var DEFAULT_STATS = {
	"HEALTH" : 15,
	"SPEED": 300,
	"DAMAGE": 5,
	"RANGE": 0,
	"LIFETIME": 0.00 # in seconds
}

func SetStats():
	for stat in STATS:
		if STATS[stat] == 0:
			STATS[stat] = DEFAULT_STATS[stat]
