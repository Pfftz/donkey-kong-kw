extends Node

#movement states
var is_attacking = false
var is_climbing = false

# Indicates if box can be spawned
var can_spawn = true

#current scenes
var current_scene_name

var is_bomb_moving = false

func _ready():
	#sets the current scene name
	current_scene_name = get_tree().get_current_scene().name

# Function to disable box spawning
func disable_spawning():
	can_spawn = false
# Function to enable box spawning
func enable_spawning():
	can_spawn = true