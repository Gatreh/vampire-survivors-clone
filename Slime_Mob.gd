extends Mob_Behavior

func SetStats():
	DEFAULT_STATS = {
		"HEALTH" : 130,
		"DAMAGE": 5,
		"RANGE": 0,
		"SPEED": 300,
		"MOVE_TYPE": DIRECTION.PLAYER,
		"LIFETIME": 0.00 # in seconds
	}
