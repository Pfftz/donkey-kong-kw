extends Node

#movement states
var is_attacking = false
var is_climbing = false

#current scenes
var current_scene_name

var is_bomb_moving = false

func _ready():
    #sets the current scene name
    current_scene_name = get_tree().get_current_scene().name