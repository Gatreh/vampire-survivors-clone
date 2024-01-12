extends Node2D

@onready var mobs = {
	0: load("res://Slime_Mob.tscn"),
	1: load("res://Bat_Mob.tscn")
}

var timeSeconds = 0
var timeMinutes = 0

#region Game over handling
func _on_player_health_depleted():
	%GameOver.visible = true
	get_tree().paused = true

func _on_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

#endregion

#region Mob spawning handling

# Random position
func spawn_mob(mob):
	var new_mob = mob.instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)

# $Timer timing out
func _on_timer_timeout():
	spawn_mob(mobs[randi_range(0, mobs.size() - 1)])

# Patterns

#endregion

func _on_stopwatch_timeout():
	timeSeconds += 1
	if timeSeconds == 60:
		timeSeconds = 0
		timeMinutes += 1
	%TimerLabel.text = str(timeMinutes) + ":" + str(timeSeconds)
