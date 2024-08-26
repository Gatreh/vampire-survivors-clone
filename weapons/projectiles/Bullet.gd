extends Area2D

var STATS = {
	"DAMAGE": 0,
	"SPEED": 0,
	"RANGE": 0.0,
	"CRIT": false,
	"CRIT_MULTIPLIER": 2
}

var travelDistance = 0 # Distance the bullet has traveled

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * STATS.SPEED * delta
	
	travelDistance += STATS.SPEED * delta
	if travelDistance > STATS.SPEED * STATS.RANGE:
		queue_free()

func _on_body_entered(body):
	queue_free()
	if body.has_method("TakeDamage"):
		if STATS.CRIT == true:
			body.TakeDamage(STATS.DAMAGE * STATS.CRIT_MULTIPLIER, STATS.CRIT)
		else:
			body.TakeDamage(STATS.DAMAGE, STATS.CRIT)
