extends Node2D
class_name PatternSpawner

const ENEMY = {
	SLIME: preload("res://enemies/scenes/Slime_Mob.tscn"),
	BAT: preload("res://enemies/scenes/Bat_Mob.tscn")
}
const ENEMY_NAME = {
	SLIME: "Slime",
	BAT: "Bat"
}

enum {SLIME, BAT}
enum DIRECTION {PLAYER, MIDDLE, HOVER, UP, RIGHT, DOWN, LEFT}

var distance = 0.0	# The total distance between point a and point b
var step = 0.01226 		# The space between each spawned mobType

#Pass array and mob to this function to override base stat
#Array should be two dimensional with name like ["SPEED", 2000]
func _set_stats(spawn, newStats):
	for stat in newStats:
		spawn.STATS[stat[0]] = stat[1]

#region Random spawning pattern
func Random(amount, delay): 
	for x in amount:
		RandomFullSpawner(randi_range(0, ENEMY.size() -1), [], 1, 0.00)
		if delay > 0.00:
			await get_tree().create_timer(delay).timeout

func RandomFullSpawner(mobType: int, newStats, amount: int, delay: float):
	for x in range(amount):
		var spawn = ENEMY[mobType].instantiate()
		spawn.mobName = ENEMY_NAME[mobType]
		if newStats.size() != 0:
			_set_stats(spawn, newStats)
		%SpawnCircleFollow.progress_ratio = randf()
		spawn.global_position = %SpawnCircleFollow.global_position
		add_child(spawn)
		if delay > 0.00:
			await get_tree().create_timer(delay).timeout
#endregion

#CircleFullSpawner(MobType, null, 0, 0.00, 0, 360, true, false)
#region Circle sparning pattern
func Circle(mobType, amount, newStat, delay): 
	CircleFullSpawner(mobType, newStat, amount, delay, 0, 360, true, false)

func CircleFill(mobType, newStat, delay): 
	CircleFullSpawner(mobType, newStat, 0, delay, 0, 360, false, true)

func CircleDefine(mobType, amount, mobStat, delay, startDeg, endDeg): 
	CircleFullSpawner(mobType, mobStat, amount, delay, startDeg, endDeg, true, false)

func CircleFillDefine(mobType, mobStat, delay, startDeg, endDeg): 
	CircleFullSpawner(mobType, mobStat, 0, delay, startDeg, endDeg, false, true)

func CircleDefineHole(mobType, mobStat, delay, startHole, endHole): 
	CircleFullSpawner(mobType, mobStat, 0, delay, endHole, startHole, false, true)

#region 180 degree definitions
func CircleLeft(mobType, amount, newStat, delay): 
	CircleFullSpawner(mobType, newStat, amount, delay, 180, 360, true, false)
	
func CircleLeftFill(mobType, newStat, delay): 
	CircleFullSpawner(mobType, newStat, 0, delay, 180, 360, false, true)

func CircleRight(mobType, amount, newStat, delay): 
	CircleFullSpawner(mobType, newStat, amount, delay, 0, 180, true, false)
	
func CircleRightFill(mobType, newStat, delay): 
	CircleFullSpawner(mobType, newStat, 0, delay, 0, 180, false, true)

func CircleTop(mobType, amount, newStat, delay): 
	CircleFullSpawner(mobType, newStat, amount, delay, 270, 90, true, false)
	
func CircleFillTop(mobType, newStat, delay): 
	CircleFullSpawner(mobType, newStat, 0, delay, 270, 90, false, true)

func CircleBottom(mobType, amount, newStat, delay): 
	CircleFullSpawner(mobType, newStat, amount, delay, 90, 270, true, false)
	
func CircleFillBottom(mobType, newStat, delay): 
	CircleFullSpawner(mobType, newStat, 0, delay, 90, 270, false, true)

func CircleTopRight(mobType, amount, newStat, delay): 
	CircleFullSpawner(mobType, newStat, amount, delay, 315, 135, true, false)
	
func CircleFillTopRight(mobType, amount, newStat, delay): 
	CircleFullSpawner(mobType, newStat, amount, delay, 315, 135, false, true)

func CircleTopLeft(mobType, amount, newStat, delay): 
	CircleFullSpawner(mobType, newStat, amount, delay, 225, 45, true, false)
	
func CircleFillTopLeft(mobType, amount, newStat, delay): 
	CircleFullSpawner(mobType, newStat, amount, delay, 225, 45, false, true)

func CircleBottomRight(mobType, amount, newStat, delay): 
	CircleFullSpawner(mobType, newStat, amount, delay, 45, 225, true, false)
	
func CircleFillBottomRight(mobType, amount, newStat, delay): 
	CircleFullSpawner(mobType, newStat, amount, delay, 45, 225, false, true)

func CircleBottomLeft(mobType, amount, newStat, delay): 
	CircleFullSpawner(mobType, newStat, amount, delay, 135, 315, true, false)
	
func CircleFillBottomLeft(mobType, amount, newStat, delay): 
	CircleFullSpawner(mobType, newStat, amount, delay, 135, 315, false, true)
#endregion

#region 90 degree definitions or "corners"
func CircleTopCorner(mobType, amount, newStat, delay): 
	CircleFullSpawner(mobType, newStat, amount, delay, 315, 45, true, false)
	
func CircleFillTopCorner(mobType, newStat, delay): 
	CircleFullSpawner(mobType, newStat, 0, delay, 315, 45, false, true)

func CircleTopRightCorner(mobType, amount, newStat, delay): 
	CircleFullSpawner(mobType, newStat, amount, delay, 0, 90, true, false)
	
func CircleFillTopRightCorner(mobType, newStat, delay): 
	CircleFullSpawner(mobType, newStat, 0, delay, 0, 90, false, true)

func CircleRightCorner(mobType, amount, newStat, delay): 
	CircleFullSpawner(mobType, newStat, amount, delay, 45, 135, true, false)
	
func CircleFillRightCorner(mobType, newStat, delay): 
	CircleFullSpawner(mobType, newStat, 0, delay, 45, 135, false, true)

func CircleBottomRightCorner(mobType, amount, newStat, delay): 
	CircleFullSpawner(mobType, newStat, amount, delay, 90, 180, true, false)
	
func CircleFillBottomRightCorner(mobType, newStat, delay): 
	CircleFullSpawner(mobType, newStat, 0, delay, 90, 180, false, true)

func CircleBottomCorner(mobType, amount, newStat, delay): 
	CircleFullSpawner(mobType, newStat, amount, delay, 135, 225, true, false)
	
func CircleFillBottomCorner(mobType, newStat, delay): 
	CircleFullSpawner(mobType, newStat, 0, delay, 135, 225, false, true)

func CircleBottomLeftCorner(mobType, amount, newStat, delay): 
	CircleFullSpawner(mobType, newStat, amount, delay, 180, 270, true, false)
	
func CircleFillBottomLeftCorner(mobType, newStat, delay): 
	CircleFullSpawner(mobType, newStat, 0, delay, 180, 270, false, true)

func CircleLeftCorner(mobType, amount, newStat, delay): 
	CircleFullSpawner(mobType, newStat, amount, delay, 225, 315, true, false)
	
func CircleFillLeftCorner(mobType, newStat, delay): 
	CircleFullSpawner(mobType, newStat, 0, delay, 225, 315, false, true)

func CircleTopLeftCorner(mobType, amount, newStat, delay): 
	CircleFullSpawner(mobType, newStat, amount, delay, 270, 360, true, false)
	
func CircleFillTopLeftCorner(mobType, newStat, delay): 
	CircleFullSpawner(mobType, newStat, 0, delay, 270, 360, false, true)
#endregion

#region Extra helpers
func CircleCorners(mobType, amount, newStat, delay):
	CircleTopRightCorner(mobType, amount, newStat, delay)
	CircleTopLeftCorner(mobType, amount, newStat, delay)
	CircleBottomRightCorner(mobType, amount, newStat, delay)
	CircleBottomLeftCorner(mobType, amount, newStat, delay)

func CircleDirections(mobType, amount, newStat, delay):
	CircleTop(mobType, amount, newStat, delay)
	CircleRight(mobType, amount, newStat, delay)
	CircleBottom(mobType, amount, newStat, delay)
	CircleLeft(mobType, amount, newStat, delay)

func CircleSpiral(mobType, amountPerTurn, delay, startDeg, turns):
	var turnDelay = delay * amountPerTurn
	var endDeg = startDeg - 1
	if endDeg <= -1:
		endDeg = 360
	for turn in turns:
		CircleFullSpawner(mobType, null, amountPerTurn, delay, startDeg, endDeg, true, false)
		await get_tree().create_timer(turnDelay).timeout

#TODO spawn in a spiral, can already be done but this would help with that.
#func CircleSpiral(mobType, amount, delay, startDeg, endDeg, turns): pass
#endregion
func CircleFullSpawner(mobType:int, newStats, amount:int, delay:float, 
						startDeg:float, endDeg:float, separate:bool, fill:bool):
	if startDeg < 0: startDeg = 0
	if endDeg < 0: endDeg = 360
	if startDeg < endDeg:	distance = (endDeg - startDeg) / 360.0
	if startDeg > endDeg:	distance = (360 - (startDeg - endDeg)) / 360.0
	
	if fill:	amount = distance / step # Places as many enemies as will fit in the area specified
	if separate: step = distance / (amount + 1)
	%SpawnCircleFollow.progress_ratio = (startDeg / 360.0) + step
	for x in amount:
		var spawn = ENEMY[mobType].instantiate()
		spawn.mobName = ENEMY_NAME[mobType]
		if newStats.size() != 0:
			_set_stats(spawn, newStats)
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
#region Line Spawning Helpers
func LineTop(mobType:int, newStats, amount:int, delay:float):
	LineSpawner(mobType, newStats, amount, delay, DIRECTION.DOWN, true, false)

func LineTopFill(mobType:int, newStats, delay:float):
	LineSpawner(mobType, newStats, 0, delay, DIRECTION.DOWN, false, true)

func LineRight(mobType, newStats, amount:int, delay:float):
	LineSpawner(mobType, newStats, amount, delay, DIRECTION.LEFT, true, false)

func LineRightFill(mobType:int, newStats, delay:float):
	LineSpawner(mobType, newStats, 0, delay, DIRECTION.LEFT, false, true)

func LineBottom(mobType, newStats, amount:int, delay:float):
	LineSpawner(mobType, newStats, amount, delay, DIRECTION.UP, true, false)

func LineBottomFill(mobType:int, newStats, delay:float):
	LineSpawner(mobType, newStats, 0, delay, DIRECTION.UP, false, true)

func LineLeft(mobType, newStats, amount:int, delay:float):
	LineSpawner(mobType, newStats, amount, delay, DIRECTION.RIGHT, true, false)

func LineLeftFill(mobType:int, newStats, delay:float):
	LineSpawner(mobType, newStats, 0, delay, DIRECTION.RIGHT, false, true)
#endregion
func LineSpawner(mobType:int, newStats, amount:int, delay:float, direction:DIRECTION, separate:bool, fill:bool):
	var LINE = {
		DIRECTION.UP : %SpawnBelowFollow,
		DIRECTION.RIGHT : %SpawnLeftFollow,
		DIRECTION.DOWN : %SpawnAboveFollow,
		DIRECTION.LEFT : %SpawnRightFollow
	}
	distance = 1.0
	if fill: amount = distance / step
	if separate: step = distance / (amount + 1)
	newStats.append(["MOVE_TYPE", direction])
	for x in amount:
		var spawn = ENEMY[mobType].instantiate()
		spawn.mobName = ENEMY_NAME[mobType]
		if newStats.size() != 0:
			_set_stats(spawn, newStats)
		spawn.global_position = LINE[direction].global_position
		add_child(spawn)
		LINE[direction].progress_ratio += step
		if delay > 0.00:
			await get_tree().create_timer(delay).timeout
#endregion
