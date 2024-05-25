extends Node2D
class_name PatternSpawner
## Test

const ENEMY = {
	SLIME: preload("res://enemies/scenes/Slime_Mob.tscn"),
	BAT: preload("res://enemies/scenes/Bat_Mob.tscn")
}
const ENEMY_NAME = {
	SLIME: "Slime",
	BAT: "Bat"
}

enum {SLIME, BAT}
enum MOVEMENT_DIRECTION {PLAYER, MIDDLE, HOVER, UP, RIGHT, DOWN, LEFT}

enum AREA { ## Areas of a circle you can spawn things in. Corresponds to the CircleAreaDefinitions to manage the degrees in a circle.
	FULL,
	TOP,			TOP_QUARTER,
	TOP_RIGHT,		TOP_RIGHT_QUARTER,
	RIGHT,			RIGHT_QUARTER,
	BOTTOM_RIGHT,	BOTTOM_RIGHT_QUARTER,
	BOTTOM,			BOTTOM_QUARTER,
	BOTTOM_LEFT,	BOTTOM_LEFT_QUARTER,
	LEFT,			LEFT_QUARTER,
	TOP_LEFT,		TOP_LEFT_QUARTER
}
## I use x as the starting position and y for the end position of the circle. It can be used in the opposite way if you need to inverse the selection.
var CircleAreaDefinitions = { 
	AREA.FULL: Vector2(0, 360),
	AREA.TOP: Vector2(270, 90),			AREA.TOP_QUARTER: Vector2(315, 45),
	AREA.TOP_RIGHT: Vector2(315, 135),	AREA.TOP_RIGHT_QUARTER: Vector2(0, 90),
	AREA.RIGHT: Vector2(0, 180),			AREA.RIGHT_QUARTER: Vector2(45, 135),
	AREA.BOTTOM_RIGHT: Vector2(45, 225),	AREA.BOTTOM_RIGHT_QUARTER: Vector2(90, 180),
	AREA.BOTTOM: Vector2(90, 270),		AREA.BOTTOM_QUARTER: Vector2(135, 225),
	AREA.BOTTOM_LEFT: Vector2(135, 315),	AREA.BOTTOM_LEFT_QUARTER: Vector2(180, 270),
	AREA.LEFT: Vector2(180, 360),		AREA.LEFT_QUARTER: Vector2(225, 315),
	AREA.TOP_LEFT: Vector2(225, 45),		AREA.TOP_LEFT_QUARTER: Vector2(270, 360)
}

enum SPAWN_MODE {
	SEPARATE,
	FILL,
	INVERTED_FILL,
	RANDOM
}

var distance := 0.0		## The total distance between point a and b on the spawnpath that's being used.
var step := 0.01226 	## The space between each spawned mobType, The standard value is calculated to be 1 mob wide.

## Pass array and mob to this function to override the base stats.
## Array should be two dimensional with name like ["SPEED", 2000]
func SetNewStats(spawn, newStats:Array):
	for stat in newStats:
		spawn.STATS[stat[0]] = stat[1]

#region Random spawning pattern
func Random(amount:int = 1, delay:float = 0.0, mobType:int = -1, newStats:Array = []):
	if mobType == -1:
		mobType = randi_range(0,1)
	for x in range(amount):
		var spawn = ENEMY[mobType].instantiate()
		spawn.mobName = ENEMY_NAME[mobType]
		if newStats.size() != 0:
			SetNewStats(spawn, newStats)
		%SpawnCircleFollow.progress_ratio = randf()
		spawn.global_position = %SpawnCircleFollow.global_position
		add_child(spawn)
		if delay > 0.00:
			await get_tree().create_timer(delay).timeout
#endregion

# TODO Make more robust documentation for the circle spawner.
#region Circle sparning patterns
func Spiral(mobType, amountPerTurn : int, delay : float, startPoint:AREA, turns:float):
	var turnDelay := delay * amountPerTurn
	var endDeg = CircleAreaDefinitions[startPoint].x - 1
	if endDeg <= -1:
		endDeg = 360
	for turn in turns:
#		Circle(mobType, null, amountPerTurn, delay, startDeg, endDeg, true, false)
		await get_tree().create_timer(turnDelay).timeout

func Circle(mobType:int, spawnArea:AREA, amount:int = 1,
		 spawnMode:SPAWN_MODE = SPAWN_MODE.SEPARATE, newStats:Array = [], delay:float = 0.0):
	var startDeg:int
	var endDeg:int
	# Setting values for the start and end based on what kind of spawn mode and what area has been selected
	if spawnMode != SPAWN_MODE.INVERTED_FILL:
		startDeg = CircleAreaDefinitions[spawnArea].x
		endDeg = CircleAreaDefinitions[spawnArea].y
	else:
		startDeg = CircleAreaDefinitions[spawnArea].y
		endDeg = CircleAreaDefinitions[spawnArea].x
	if endDeg <= -1:
		endDeg += 360
		
	if startDeg < endDeg:	distance = (endDeg - startDeg) / 360.0
	if startDeg > endDeg:	distance = (360 - (startDeg - endDeg)) / 360.0
	if SPAWN_MODE.FILL or SPAWN_MODE.INVERTED_FILL:	amount = distance / step # Places as many enemies as will fit in the area specified
	elif SPAWN_MODE.SEPARATE: step = distance / (amount + 1)  # Spaces the enemies out evenly in the area set
	elif SPAWN_MODE.RANDOM: step = distance * randf() # Places the enemies in a random spot along the area
	
	%SpawnCircleFollow.progress_ratio = (startDeg / 360.0) + step
	for x in amount:
		var spawn = ENEMY[mobType].instantiate()
		spawn.mobName = ENEMY_NAME[mobType]
		if newStats.size() != 0:
			SetNewStats(spawn, newStats)
		spawn.global_position = %SpawnCircleFollow.global_position
		add_child(spawn)
		if %SpawnCircleFollow.progress_ratio + step > 1:
			var leftover = (%SpawnCircleFollow.progress_ratio + step) - 1
			%SpawnCircleFollow.progress_ratio = leftover
		else:
			%SpawnCircleFollow.progress_ratio += step
		if delay > 0.00:
			await get_tree().create_timer(delay).timeout
#endregion

#region Line Spawning patterns
func Line(mobType:int, amount:int, spawnArea:AREA, newStats:Array = [], spawnMode:SPAWN_MODE = SPAWN_MODE.SEPARATE, delay:float = 0):
	var LINE = {
		AREA.BOTTOM : %SpawnBelowFollow,
		AREA.LEFT : %SpawnLeftFollow,
		AREA.TOP : %SpawnAboveFollow,
		AREA.RIGHT : %SpawnRightFollow
	}
	var movementDirection = {
		AREA.BOTTOM : MOVEMENT_DIRECTION.UP,
		AREA.LEFT : MOVEMENT_DIRECTION.RIGHT,
		AREA.TOP : MOVEMENT_DIRECTION.DOWN,
		AREA.RIGHT : MOVEMENT_DIRECTION.LEFT
	}
	distance = 1.0
	if spawnMode == SPAWN_MODE.FILL: amount = distance / step
	if spawnMode == SPAWN_MODE.SEPARATE: step = distance / (amount + 1)
	newStats.append(["MOVE_TYPE", movementDirection[spawnArea]])
	for x in amount:
		var spawn = ENEMY[mobType].instantiate()
		spawn.mobName = ENEMY_NAME[mobType]
		if newStats.size() != 0:
			SetNewStats(spawn, newStats)
		spawn.global_position = LINE[spawnArea].global_position
		add_child(spawn)
		LINE[spawnArea].progress_ratio += step
		if delay > 0.00:
			await get_tree().create_timer(delay).timeout
#endregion
