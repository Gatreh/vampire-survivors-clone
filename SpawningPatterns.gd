extends Node2D
class_name PatternSpawner

const ENEMY = {
	SLIME: preload("res://Slime_Mob.tscn"),
	BAT: preload("res://Bat_Mob.tscn")
}
const ENEMY_NAME = {
	SLIME: "Slime",
	BAT: "Bat"
}
enum {SLIME, BAT}

var distance = 0	# The total distance between point a and point b
var step = 0.0 		# The space between each spawned mobType

#Pass array and mob to this function to override base stat
#Array should be two dimensional with name like ["SPEED", 2000]
func _set_stats(mob, newStats):
	for stat in newStats:
		mob.STATS[stat[0]] = stat[1]

#region Random spawning pattern
func Random(mobType): RandomFullSpawner(mobType, null, 1, 0.00)
func RandomWithStat(mobType, newStats): RandomFullSpawner(mobType, newStats, 1, 0.00)
func RandomMultiple(mobType, amount): RandomFullSpawner(mobType, null, amount, 0.00)
func RandomWithStatMultiple(mobType, amount, newStats): RandomFullSpawner(mobType, newStats, amount, 0.00)
func RandomDelayed(mobType, amount, delay): RandomFullSpawner(mobType, null, amount, delay)
func RandomWithStatDelayed(mobType, newStats, amount, delay): RandomFullSpawner(mobType, newStats, amount, delay)

func RandomFullSpawner(mobType, newStats, amount, delay):
	for x in amount:
		var spawn = ENEMY[mobType].instantiate()
		spawn.mobName = ENEMY_NAME[mobType]
		if newStats != null:
			_set_stats(spawn, newStats)
		%SmallCircleFollow.progress_ratio = randf()
		spawn.global_position = %SmallCircleFollow.global_position
		add_child(spawn)
		if delay > 0.00:
			await get_tree().create_timer(delay).timeout
#endregion
#CircleFullSpawner(1, null, 0, 0.00, 0, 360, true, false)
#region Circle sparning pattern
func Circle(mobType, amount): CircleFullSpawner(mobType, null, amount, 0.00, 0, 360, true, false)

func CircleFullSpawner(mobType:int, newStats, amount:int, delay:float, 
						startDeg:int, endDeg:int, separate:bool, fill:bool):
	if startDeg < endDeg:	distance = (endDeg - startDeg) / 360.0
	if startDeg > endDeg:	distance = (360 - (startDeg - endDeg)) / 360.0
	
	if separate:	step = distance / (amount - 1.0)
	else:	step = 0.01226 # Size of mobType collision box / length of track in pixels
	
	if fill:	amount = distance / step # Places as many enemies as will fit in the area specified
	%SmallCircleFollow.progress_ratio = startDeg / 360.0
	for x in amount:
		var spawn = ENEMY[mobType].instantiate()
		spawn.mobName = ENEMY_NAME[mobType]
		if newStats != null:
			_set_stats(spawn, newStats)
		spawn.global_position = %SmallCircleFollow.global_position
		add_child(spawn)
		if %SmallCircleFollow.progress_ratio + step > 1:
			var leftover = (%SmallCircleFollow.progress_ratio + step) - 1
			%SmallCircleFollow.progress_ratio = leftover
		else:
			%SmallCircleFollow.progress_ratio += step
		if delay > 0.00:
			await get_tree().create_timer(delay).timeout
#endregion
