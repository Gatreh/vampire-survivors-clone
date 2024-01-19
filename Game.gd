extends PatternSpawner

@onready var death_scene = load("res://Restart.tscn")

enum mobs {SLIME, BAT}

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
# Spawntimer will use times from time(m, s) or conditions to summon mobs.
# Below are some examples
func _on_SpawnTimer():
	if AtTime(0, 2):
		Circle(SLIME, 4)
		CircleFullSpawner(SLIME, null, 4, 0.00, 270, 90, false, true)

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

# Time calculator helpers
func AtTime(minutes, seconds) -> bool:
	return (timeMinutes == minutes && timeSeconds == seconds)

func BeforeTime(minutes, seconds) -> bool:
	if timeMinutes > 0:
		if timeMinutes == minutes:
			return (timeSeconds <= seconds)
		return (timeMinutes <= minutes)
	return (timeSeconds <= seconds)

func BetweenTime(startMinutes, startSeconds, endMinutes, endSeconds) -> bool:
	return true


