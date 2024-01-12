extends CharacterBody2D

signal health_depleted

@onready var character := %HappyBoo

var speed := 600
var max_health := 100.0
var health := max_health

func _ready():
	updateHealthBar()
	

func _physics_process(delta):
	# Movement
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()
	
	# Animations
	if velocity.length() > 0.0:
		character.play_walk_animation()
	else:
		character.play_idle_animation()
	
	# Damage to player
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0 && $Timer.is_stopped():
		$Timer.start()			# Configurable iframes
		for enemy in overlapping_mobs:
			health -= enemy.DAMAGE
		updateHealthBar()
		if health <= 0:
			health_depleted.emit()

func updateHealthBar():
	%HealthBar.max_value = max_health
	%HealthBar.value = health
	%HealthLabel.text = str(health) + "/" + str(max_health)
