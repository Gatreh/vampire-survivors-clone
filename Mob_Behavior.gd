class_name Mob_Behavior
extends CharacterBody2D

@onready var player = get_node("/root/Game/Player")
@onready var mob = new()

const DEATH_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")

var movement = 0
var direction = Vector2(0,0)
enum DIRECTION {PLAYER, MIDDLE, HOVER, UP, RIGHT, DOWN, LEFT}
const MOVEMENT_DIRECTION = {
	DIRECTION.UP: Vector2(0, -1),
	DIRECTION.RIGHT: Vector2(1, 0),
	DIRECTION.DOWN: Vector2(0, 1),
	DIRECTION.LEFT: Vector2(-1, 0)
}

var mobName = ""
var STATS = {
	"HEALTH" : 0,
	"SPEED": 0,
	"DAMAGE": 0,
	"RANGE": 0,
	"LIFETIME": 0.00 # in seconds
}

func _ready():
	mob = get_node("%" + mobName)
	mob.play_walk()
	KillAfterTimeout()

func _physics_process(delta):
	Move()

#region Movement
func Move():
	if STATS.SPEED == 0:
		pass
	match movement:
		DIRECTION.PLAYER:
			direction = global_position.direction_to(player.global_position)
		DIRECTION.MIDDLE:
			if direction == Vector2(0,0):
				direction = global_position.direction_to(player.global_position)
		DIRECTION.HOVER:
			pass #TODO Implement hovering in a circle around the player
		_:
			if get_collision_mask_value(3):
				set_collision_mask_value(3, false)
			direction = MOVEMENT_DIRECTION[movement]
	velocity = direction * STATS.SPEED
	move_and_slide()
#endregion

#region Damage
func TakeDamage(damage):
	STATS.HEALTH -= damage
	mob.play_hurt()
	if STATS.HEALTH <= 0:
		Kill()

func KillAfterTimeout():
	if STATS.LIFETIME > 0.00:
		await get_tree().create_timer(STATS.LIFETIME).timeout
		Kill()

func Kill():
	queue_free()
	var smoke = DEATH_SCENE.instantiate()
	get_parent().add_child(smoke)
	smoke.global_position = global_position
#endregion
