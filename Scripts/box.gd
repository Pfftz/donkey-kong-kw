### Box.gd

extends Area2D

# Default animation on spawn
func _ready():
	$AnimatedSprite2D.play("moving")
	
func _on_body_entered(body):
	# If the bomb collides with the player, play the explosion animation and disable spawning
	if body.name == "Player":
		$AnimatedSprite2D.play("explode")
		# Disable spawning in BoxSpawner
		Global.disable_spawning()
		# Player takes damage
		body.take_damage()
		
	# If the bomb collides with our Wall scene, remove so that it can be respawned
	if body.name.begins_with("Terrain"):
		queue_free()
		
#if the box's explode animation is playing, remove it from the scene
func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "explode":
		queue_free()