extends CharacterBody2D

@onready var player = get_node("/root/Game/Player")
@onready var mob = %Bat

const SPEED = 600
const DAMAGE = 2

var health = 5

func _ready():
	mob.play_walk()

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * SPEED
	move_and_slide()

func TakeDamage(damage):
	health -= damage
	mob.play_hurt()
	if health == 0:
		queue_free()
		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = Vector2(global_position.x, global_position.y - 75)
