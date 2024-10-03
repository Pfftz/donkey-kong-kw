extends Area2D

var rotation_speed = 10

func _ready():
	$AnimatedSprite2D.play("idle")
	
#rolls the bomb
func _physics_process(delta):
	# Rotate the bomb if it hasn't exploded
	if Global.is_bomb_moving == true:
		$AnimatedSprite2D.rotation += rotation_speed * delta

func _on_body_entered(body: Node2D):
	if body.name == "Player":
		$AnimatedSprite2D.play("explode")
		$Timer.start()
		Global.is_bomb_moving = false
	if body.name == "Terrain":
		$AnimatedSprite2D.play("explode")
		$Timer.start()
		Global.is_bomb_moving = false
	if body.name == "WallTrigger":
		$AnimatedSprite2D.play("explode")
		$Timer.start()
		Global.is_bomb_moving = false

func _on_timer_timeout():
	if is_instance_valid(self):
		self.queue_free()