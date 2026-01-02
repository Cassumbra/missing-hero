extends CharacterBody2D

@onready var swinging_timer = $AxeHandler/SwingingTimer

signal swing_axe(direction: String)

const SPEED = 50.0

var move_dir = "none"
var face_dir = "down"

var timer_just_stopped = false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("button a"):
		swing_axe.emit(face_dir)
		move_dir = "none"
	
	if swinging_timer.is_stopped():
		# Get the input direction and handle the movement/deceleration.
		if Input.is_action_just_pressed("down"):
			move_dir = "down"
		if Input.is_action_just_pressed("up"):
			move_dir = "up"
		if Input.is_action_just_pressed("left"):
			move_dir = "left"
		if Input.is_action_just_pressed("right"):
			move_dir = "right"
		
		if Input.is_action_just_released(move_dir) or timer_just_stopped:
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
			
	if move_dir != "none":
		face_dir = move_dir
	
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
	
	timer_just_stopped = false


func _on_swinging_timer_timeout() -> void:
	timer_just_stopped = true
