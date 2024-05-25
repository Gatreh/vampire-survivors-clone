extends CharacterBody2D

signal health_depleted

@onready var character := %HappyBoo
@export var immortal:bool = false
var STATS = {
	"MAX_HEALTH": 100.0,
	"HEALTH": 100.0,
	"SPEED": 600
}

func _ready():
	updateHealthBar()

func _physics_process(delta):
	# Movement
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * STATS.SPEED
	move_and_slide()
	
	# Animations
	if velocity.length() > 0.0:
		character.play_walk_animation()
	else:
		character.play_idle_animation()
	
	# Damage to player
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0 && $Timer.is_stopped() && !immortal:
		$Timer.start()			# Configurable iframes
		for enemy in overlapping_mobs:
			STATS.HEALTH -= enemy.STATS.DAMAGE
		updateHealthBar()
		if STATS.HEALTH <= 0:
			health_depleted.emit()

func updateHealthBar():
	%HealthBar.max_value = STATS.MAX_HEALTH
	%HealthBar.value = STATS.HEALTH
	%HealthLabel.text = str(%HealthBar.value) + "/" + str(%HealthBar.max_value)
