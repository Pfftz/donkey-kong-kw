### BoxSpawner.gd

extends Node2D

# Box scene reference
var box = preload("res://Scenes/Box.tscn")
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# References to our scene, PathFollow2D path, and AnimationPlayer path
var box_path
var box_animation

# Allows us to flip our pigs around in the editor
@export var flip_h = false
@export var flip_v = false

# When it's loaded into the scene
func _ready():
    # Initiates paths
    box_path = $BoxPath/Path2D/PathFollow2D
    box_animation = $BoxPath/Path2D/AnimationPlayer
    # Enables box movement on path on load
    box_animation.play("box_movement")
    # Default animation on load
    animated_sprite_2d.play("pig_throw")
    # Apply initial flip values
    apply_flip()

# Setter for flip_h
func set_flip_h(value):
    flip_h = value
    apply_flip()

# Setter for flip_v
func set_flip_v(value):
    flip_v = value
    apply_flip()

# Apply flip values to the AnimatedSprite2D
func apply_flip():
    animated_sprite_2d.flip_h = flip_h
    animated_sprite_2d.flip_v = flip_v

func _process(delta):
    # Check if the boxes have reached the end of the path
    if box_path.progress_ratio >= 1:
        # Respawn box
        box_path.progress_ratio = 0
        Global.enable_spawning()
        box_animation.play("box_movement")
        
    # Play throwing animation if path resets	
    if box_path.progress_ratio == 0:
        animated_sprite_2d.play("pig_throw")
        
# Shoot and spawn box onto path
func _on_timer_timeout():
    # Reset animation back to idle if not throwing
    animated_sprite_2d.play("pig_idle")
    
    # Spawns a box onto our path if there are no boxes available and can_spawn is True
    if box_path.get_child_count() <= 0 and Global.can_spawn == true:
        var spawned_box = box.instantiate()
        box_path.add_child(spawned_box)