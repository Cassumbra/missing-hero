extends CharacterBody2D

@onready var swinging_timer = $AxeHandler/SwingingTimer
@onready var room_transition_timer = $RoomTransitionTimer
@onready var camera: PlayerCamera = $PlayerCamera


signal swing_axe(direction: String)

const SPEED = 50.0

var move_dir = "none"
var face_dir = "down"

var can_move = true



var swing_timer_just_stopped = false

func _process(delta: float) -> void:
	# TODO: Should this be here? Or in physics_process?
	if !room_transition_timer.is_stopped():
		position = camera.do_room_transition(room_transition_timer)

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
	
	if Input.is_action_just_released(move_dir) or swing_timer_just_stopped:
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

	# TODO: Should this encompass more than just move_and_slide()?
	if can_move:
		move_and_slide()
	
	
	
	swing_timer_just_stopped = false


func _on_swinging_timer_timeout() -> void:
	swing_timer_just_stopped = true


func _on_room_detector_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	var room_size = area.shape_owner_get_shape(area.shape_find_owner(area_shape_index), area_shape_index).size
	var room_position = area.global_position
	camera.begin_room_transition(room_size, room_position, move_dir, position)
	can_move = false
	room_transition_timer.start()

	

func _on_room_transition_timer_timeout() -> void:
	can_move = true
	camera.finish_room_transition()
	
