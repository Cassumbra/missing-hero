extends CharacterBody2D

@onready var swinging_timer = $AxeHandler/SwingingTimer
@onready var camera: Camera2D = $Camera2D

signal swing_axe(direction: String)

const SPEED = 50.0

var move_dir = "none"
var face_dir = "down"

var timer_just_stopped = false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("button a"):
		swing_axe.emit(face_dir)
		move_dir = "none"
	
	
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
		
	if !swinging_timer.is_stopped():
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
	
	timer_just_stopped = false


func _on_swinging_timer_timeout() -> void:
	timer_just_stopped = true


func _on_room_detector_area_entered(area: Area2D) -> void:
	pass


func _on_room_detector_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	var room_size = area.shape_owner_get_shape(area.shape_find_owner(area_shape_index), area_shape_index).size
	var room_position = area.global_position - room_size / 2.0
	# TODO: A magic number most sinister... We should replace it with some global constant referring to the UI size, perhaps.
	room_position.y = room_position.y + 8
	print(room_size)
	print(room_position)
	camera.limit_top = room_position.y
	camera.limit_left = room_position.x
	camera.limit_bottom = room_position.y + room_size.y
	camera.limit_right = room_position.x + room_size.x
