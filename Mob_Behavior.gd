extends CharacterBody2D

@onready var player = get_node("/root/Game/Player")
@onready var mob = new()

const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")

var mobName = ""

var STATS = {
	"HEALTH" : 0,
	"RESISTANCE": 0,
	"SPEED": 0,
	"DAMAGE": 0,
	"RANGE": 0,
	"LIFETIME": 0.00 # in seconds
}

func _ready():
	mob = get_node("%" + mobName)
	mob.play_walk()
	if STATS.LIFETIME > 0.00:
		KillAfterTimeout(STATS.LIFETIME)

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * STATS.SPEED
	move_and_slide()

func TakeDamage(damage):
	STATS.HEALTH -= damage
	mob.play_hurt()
	if STATS.HEALTH == 0:
		Kill()

func KillAfterTimeout(time):
	await get_tree().create_timer(time).timeout
	Kill()

func Kill():
	queue_free()
	var smoke = SMOKE_SCENE.instantiate()
	get_parent().add_child(smoke)
	smoke.global_position = global_position
