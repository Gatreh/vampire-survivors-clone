extends Area2D

const BULLET = preload("res://Bullet.tscn")

var WEAPON_STATS = {
	"DAMAGE": 1,
	"ATTACK_SPEED": 0.2,
	"PROJECTILE_SPEED": 800,
	"LIFETIME": 1.5 # Can be used as a range multiplier or a timer.
}

func _ready():
	$AttackSpeed.wait_time = WEAPON_STATS.ATTACK_SPEED
	$AttackSpeed.autostart = true
	$AttackSpeed.start()

func _physics_process(delta):
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range.front()
		look_at(target_enemy.global_position)
	FlipWeapon()

func Shoot():
	var new_bullet = BULLET.instantiate()
	new_bullet.STATS.DAMAGE = 1
	new_bullet.STATS.SPEED = 800
	new_bullet.STATS.RANGE = WEAPON_STATS.LIFETIME
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation_degrees = %ShootingPoint.global_rotation_degrees
	%ShootingPoint.add_child(new_bullet)

# Flip sprite based on which direction it's pointing and adjust position
# to make it look more like it's in the same spot as the original
func FlipWeapon():
	if global_rotation_degrees > 90.0 || global_rotation_degrees < -90.0:
		$WeaponPivot/Pistol.flip_v = true
		$WeaponPivot/Pistol.offset = Vector2(0, 21)
		%ShootingPoint.position.y = 21
	else:
		$WeaponPivot/Pistol.flip_v = false
		$WeaponPivot/Pistol.offset = Vector2(0, 0)
		%ShootingPoint.position.y = -11

func _on_timer_timeout():
	Shoot()
