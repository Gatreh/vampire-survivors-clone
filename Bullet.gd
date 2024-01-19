extends Area2D

const STATS = {
	"DAMAGE": 1,
	"SPEED": 800,
	"RANGE": 1.5
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
		body.TakeDamage(STATS.DAMAGE)
