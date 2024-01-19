extends Area2D

func _ready():
	$AnimationPlayer.play("idle")


func _on_body_entered(body):
	if body.has_method("updateHealthBar"):
		if body.STATS.HEALTH + 10 < body.STATS.MAX_HEALTH:
			body.STATS.HEALTH += 10
		else:
			body.STATS.HEALTH = body.STATS.MAX_HEALTH
		body.updateHealthBar()
		queue_free()
