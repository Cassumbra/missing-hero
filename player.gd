extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -400.0

var move_dir = "none"

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	
	if Input.is_action_just_pressed("down"):
		move_dir = "down"
	if Input.is_action_just_pressed("up"):
		move_dir = "up"
	if Input.is_action_just_pressed("left"):
		move_dir = "left"
	if Input.is_action_just_pressed("right"):
		move_dir = "right"
	
	if Input.is_action_just_released(move_dir):
		if Input.is_action_pressed("down"):
			move_dir = "down"
		elif Input.is_action_pressed("up"):
			move_dir = "up"
		elif Input.is_action_pressed("left"):
			move_dir = "left"
		elif Input.is_action_pressed("right"):
			move_dir = "right"
		else:
			move_dir = "none"
	
	var direction: Vector2
	match move_dir:
		"down":
			direction = Vector2(0.0, 1.0)
		"up":
			direction = Vector2(0.0, -1.0)
		"right":
			direction = Vector2(1.0, 0.0)
		"left":
			direction = Vector2(-1.0, 0.0)
		"none":
			direction = Vector2(0.0, 0.0)
	
	velocity = direction * SPEED
	
	#var direction_x := Input.get_axis("left", "right")
	#var direction_y := Input.get_axis("up", "down")
	#if direction_x:
		#velocity.x = direction_x * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
	#
	#if direction_y and !direction_x:
		#velocity.y = direction_y * SPEED
	#else:
		#velocity.y = move_toward(velocity.y, 0, SPEED)


	move_and_slide()
