### Player.gd

extends CharacterBody2D

#custom signals
signal update_lives(lives, max_lives)

#health stats
var max_lives = 3
var lives = 3

# Player movement variables
@export var speed = 8000
@export var gravity = 200
@export var jump_height = -120

# Keep track of the last direction (1 for right, -1 for left, 0 for none)
var last_direction = 0
# Check the direction of the player's movement
var current_direction = 0

func _ready():
	# Set the player's initial direction
	current_direction = -1

func _process(delta):
	if velocity.x > 0: # Moving right
		current_direction = 1
	elif velocity.x < 0: # Moving left
		current_direction = -1
	
	# If the direction has changed, play the appropriate animation
	if current_direction != last_direction:
		if current_direction == 1:
			# Play the right animation
			$AnimationPlayer.play("move_right")
			#limits
			$Camera2D.limit_left = -50
			$Camera2D.limit_bottom = 50
		elif current_direction == -1:
			# Play the left animation
			$AnimationPlayer.play("move_left")
			#limits
			$Camera2D.limit_left = 50
			$Camera2D.limit_bottom = 50
		# Update the last_direction variable
		last_direction = current_direction

func take_damage():
	if lives > 0:
		lives = lives - 1
		update_lives.emit(lives, max_lives)
		print("Player took damage. Lives remaining: ", lives)
		$AnimatedSprite2D.play("damage")
		set_physics_process(false)

#movement and physics
func _physics_process(delta):
	# vertical movement velocity (down)
	velocity.y += gravity * delta
	# horizontal movement processing (left, right)
	horizontal_movement(delta)
	
	#applies movement
	move_and_slide() 
	
	#applies animations
	if !Global.is_attacking || !Global.is_climbing:
		player_animations()
		
# Horizontal movement calculation
func horizontal_movement(delta):
	# If keys are pressed it will return 1 for right, -1 for left, and 0 for neither
	var horizontal_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	# Horizontal velocity which moves player left or right based on input
	velocity.x = horizontal_input * speed * delta

#animations
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
		if Input.is_action_pressed("climb"):
			$AnimatedSprite2D.play("climb")	
			gravity = 100
			velocity.y = -160
			Global.is_jumping = true
	else:
		gravity = 200
		Global.is_climbing = false	
		Global.is_jumping = false
		
# Reset our animation variables
func _on_animated_sprite_2d_animation_finished():
	Global.is_attacking = false
	set_physics_process(true)
