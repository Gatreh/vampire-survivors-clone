extends PatternSpawner

@onready var death_scene = load("res://levels/Restart.tscn")

var time = 0
var timeSeconds = 0
var timeMinutes = 0


func _ready():
	UpdateTimer()

#region Game over handling
func _on_player_health_depleted():
	var deathMenu = death_scene.instantiate()
	add_child(deathMenu)
	(deathMenu.get_node("%RestartButton") as Button).pressed.connect(_on_Restart_pressed)
	(deathMenu.get_node("%MainMenuButton") as Button).pressed.connect(_on_MainMenu_pressed)
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
#func Circle(mobType:int, spawnArea:AREA, amount:int = 1,
#			 spawnMode:SPAWN_MODE = SPAWN_MODE.SEPARATE, newStats:Array = [], delay:float = 0.0)
func _on_SpawnTimer():
	if BetweenTime(0,0, 0,45):
		Random()
	if BetweenTime(0,45, 1,0):
		Line(SLIME, 15, AREA.TOP, [["HEALTH", 1000],["LIFETIME", 20.0]])
	if BetweenTime(1,0, 1,30):
		Random(2, 0.5)
	if AfterTime(1, 30):
		Random(3, 0.33)
	if AtTime(1, 0):
		var stats = [["SPEED", 100], ["MOVE_TYPE", MOVEMENT_DIRECTION.MIDDLE], ["LIFETIME", 6.0]]
		Circle(SLIME, AREA.FULL, 12, SPAWN_MODE.SEPARATE, stats)
		Circle(BAT, AREA.FULL, 13, SPAWN_MODE.SEPARATE, stats)
		
#endregion

func _on_stopwatch_timeout():
	timeSeconds += 1
	if timeSeconds == 60:
		timeSeconds = 0
		timeMinutes += 1
	time += 1
	UpdateTimer() 

func UpdateTimer():
	$Player/%TimerLabel.text = str(timeMinutes).pad_zeros(2) + ":" + str(timeSeconds).pad_zeros(2)

# Time calculator helpers
func AtTime(minutes, seconds) -> bool:
	return (minutes * 60 + seconds) == time

func BetweenTime(startMinutes, startSeconds, endMinutes, endSeconds) -> bool:
	return (startMinutes * 60 + startSeconds) <= time && time <= endMinutes * 60 + endSeconds

func AfterTime(startMinutes, startSeconds):
	return (startMinutes * 60 + startSeconds) <= time
