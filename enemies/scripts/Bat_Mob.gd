extends Mob_Behavior

func ApplyDefaultStats():
	DEFAULT_STATS = {
		"HEALTH" : 60,
		"DAMAGE": 2,
		"RANGE": 0,
		"SPEED": 600,
		"MOVE_TYPE": DIRECTION.PLAYER,
		"LIFETIME": 0.00 # in seconds
	}
