extends PatternSpawner

@onready var death_scene = load("res://levels/Restart.tscn")

var time = 0
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
	get_tree().change_scene_to_file("res://levels/MainMenu.tscn")

#endregion

#region Mob spawning handling
# Spawntimer will use times from time(m, s) or conditions to summon mobs.
# Below are some examples
#func CircleFullSpawner(mobType:int, newStats, amount:int, delay:float, 
#						startDeg:float, endDeg:float, separate:bool, fill:bool):
func _on_SpawnTimer():
	if BetweenTime(0,0, 0,45):
		Random(1, 0.0)
	if BetweenTime(0,45, 1,0):
		LineRight(SLIME, [["HEALTH", 1000],["LIFETIME", 20.0]], 15, 0.0 )
	if BetweenTime(1,0, 1,30):
		Random(2, 0.5)
	if AfterTime(1, 30):
		Random(3, 0.33)
	if AtTime(1, 0):
		var stats = [["SPEED", 100], ["MOVE_TYPE", DIRECTION.MIDDLE], ["LIFETIME", 6.0]]
		Circle(SLIME, 12, stats, 0.00)
		Circle(BAT, 13, stats, 0.00)
		
#endregion

func _on_stopwatch_timeout():
	timeSeconds += 1
	if timeSeconds == 60:
		timeSeconds = 0
		timeMinutes += 1
	time += 1
	updateTimer()

func updateTimer():
	$Player/%TimerLabel.text = (
		"0" + str(timeMinutes) if timeMinutes < 10 else str(timeMinutes)) + ":" + (
		"0" + str(timeSeconds) if timeSeconds < 10 else str(timeSeconds))

# Time calculator helpers
func AtTime(minutes, seconds) -> bool:
	return (minutes * 60 + seconds) == time

func BetweenTime(startMinutes, startSeconds, endMinutes, endSeconds) -> bool:
	return (startMinutes * 60 + startSeconds) <= time && time <= endMinutes * 60 + endSeconds

func AfterTime(startMinutes, startSeconds):
	return (startMinutes * 60 + startSeconds) <= time
