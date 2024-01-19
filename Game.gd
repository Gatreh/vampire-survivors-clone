extends Node2D

@onready var death_scene = load("res://Restart.tscn")
@onready var mobs = {
	SLIME: load("res://Slime_Mob.tscn"),
	BAT: load("res://Bat_Mob.tscn")
}

enum {SLIME, BAT}

var timeSeconds = 0
var timeMinutes = 0

func _ready():
	updateTimer()

#region Game over handling
func _on_player_health_depleted():
	var deathMenu = death_scene.instantiate()
	add_child(deathMenu)
	deathMenu.get_node("%RestartButton").connect("pressed", Callable(self, "_on_Restart_pressed"))
	deathMenu.get_node("%MainMenuButton").connect("pressed", Callable(self, "_on_MainMenu_pressed"))
	get_tree().paused = true

func _on_Restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_MainMenu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://MainMenu.tscn")

#endregion

#region Mob spawning handling

# Random position
func spawn_mob(mob):
	var new_mob = mobs[mob].instantiate()
	if mob == SLIME:
		new_mob.mobName = "Slime"
	elif mob == BAT:
		new_mob.mobName = "Bat"
	%SmallCircleFollow.progress_ratio = randf()
	new_mob.global_position = %SmallCircleFollow.global_position
	add_child(new_mob)

# $Timer timing out
func _on_timer_timeout():
	spawn_mob(randi_range(0, mobs.size() - 1))

#region Patterns

#endregion
#endregion

func _on_stopwatch_timeout():
	timeSeconds += 1
	if timeSeconds == 60:
		timeSeconds = 0
		timeMinutes += 1
	updateTimer()

func updateTimer():
	$Player/%TimerLabel.text = (
		"0" + str(timeMinutes) if timeMinutes < 10 else str(timeMinutes)) + ":" + (
		"0" + str(timeSeconds) if timeSeconds < 10 else str(timeSeconds))
