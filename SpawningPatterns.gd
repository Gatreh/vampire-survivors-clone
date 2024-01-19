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

#Pass array and mob to this function to override base stat
#Array should be two dimensional with name like ["SPEED", 2000]
func _set_stats(mob, newStats):
	for stat in newStats:
		mob.STATS[stat[0]] = stat[1]

#region Random spawning pattern
func Random(mob): RandomFullSpawner(mob, null, 1, 0.00)
func RandomWithStat(mob, newStats): RandomFullSpawner(mob, newStats, 1, 0.00)
func RandomMultiple(mob, count): RandomFullSpawner(mob, null, count, 0.00)
func RandomWithStatMultiple(mob, count, newStats): RandomFullSpawner(mob, newStats, count, 0.00)
func RandomDelayed(mob, count, delay): RandomFullSpawner(mob, null, count, delay)
func RandomWithStatDelayed(mob, newStats, count, delay): RandomFullSpawner(mob, newStats, count, delay)

func RandomFullSpawner(mob, newStats, count, delay):
	for x in count:
		var spawn = ENEMY[mob].instantiate()
		spawn.mobName = ENEMY_NAME[mob]
		if newStats != null:
			_set_stats(spawn, newStats)
		%SmallCircleFollow.progress_ratio = randf()
		spawn.global_position = %SmallCircleFollow.global_position
		add_child(spawn)
		if delay > 0.00:
			await get_tree().create_timer(delay).timeout
#endregion
