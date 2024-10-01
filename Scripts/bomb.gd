extends Area2D

func _ready():
	$AnimatedSprite2D.play("idle")

func _on_timer_timeout():
	if is_instance_valid(self):
		self.queue_free()


func _on_body_entered(body:Node2D):
	if body.name == "Player":
		$AnimatedSprite2D.play("explode")
		$Timer.start()
	if body.name == "Terrain":
		$AnimatedSprite2D.play("explode")
		$Timer.start()
	if body.name == "WallTrigger":
		$AnimatedSprite2D.play("explode")
		$Timer.start()
