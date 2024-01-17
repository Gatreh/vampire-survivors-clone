extends Area2D

#Keep as var so I can modify the bullets later with upgrades
var speed = null
var range = null
var damage = null
var travelDistance = 0

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta
	
	travelDistance += speed * delta
	if travelDistance > range:
		queue_free()

func _on_body_entered(body):
	queue_free()
	if body.has_method("TakeDamage"):
		body.TakeDamage(damage)
