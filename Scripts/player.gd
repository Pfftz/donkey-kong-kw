### Player.gd

extends CharacterBody2D

# Player movement variables
@export var speed = 8000
@export var gravity = 200
@export var jump_height = -120

# Movement and physics
func _physics_process(delta):
    # Vertical movement velocity (down)
    if !Global.is_climbing:
        velocity.y += gravity * delta
    
    # Horizontal movement processing (left, right)
    horizontal_movement(delta)
    
    # Applies movement
    move_and_slide()
    
    # Applies animations
    if !Global.is_attacking and !Global.is_climbing:
        player_animations()
        
# Horizontal movement calculation
func horizontal_movement(delta):
    # If keys are pressed it will return 1 for right, -1 for left, and 0 for neither
    var horizontal_input = Input.get_action_strength("right") - Input.get_action_strength("left")
    # Horizontal velocity which moves player left or right based on input
    velocity.x = horizontal_input * speed * delta

# Animations
func player_animations():
    # On left
    if Input.is_action_pressed("left"):
        $AnimatedSprite2D.flip_h = true
        if is_on_floor():
            $AnimatedSprite2D.play("run")
        else:
            $AnimatedSprite2D.play("jump")
        $CollisionShape2D.position.x = 7
        
    # On right
    if Input.is_action_pressed("right"):
        $AnimatedSprite2D.flip_h = false
        if is_on_floor():
            $AnimatedSprite2D.play("run")
        else:
            $AnimatedSprite2D.play("jump")
        $CollisionShape2D.position.x = -7
    
    # On idle if nothing is being pressed
    if not Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
        if is_on_floor():
            $AnimatedSprite2D.play("idle")
        else:
            $AnimatedSprite2D.play("jump")
        
# Singular input captures
func _input(event):
    # On attack
    if event.is_action_pressed("attack"):
        Global.is_attacking = true
        $AnimatedSprite2D.play("attack")

    # On jump
    if event.is_action_pressed("jump") and is_on_floor():
        velocity.y = jump_height
        $AnimatedSprite2D.play("jump")
    
    # On climbing ladders
    if Global.is_climbing:
        if not Input.is_action_pressed("climb"):
            $AnimatedSprite2D.play("idle")
        else:
            $AnimatedSprite2D.play("climb")
            gravity = 150
            velocity.y = -110
    else:
        Global.is_climbing = false
        
# Reset our animation variables
func _on_animated_sprite_2d_animation_finished():
    Global.is_attacking = false
    Global.is_climbing = false