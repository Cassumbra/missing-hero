extends CharacterBody2D

@onready var swinging_timer = $AxeHandler/SwingingTimer
@onready var room_transition_timer = $RoomTransitionTimer
@onready var camera: Camera2D = $Camera2D


signal swing_axe(direction: String)

const SPEED = 50.0

var move_dir = "none"
var face_dir = "down"

var can_move = true

var transition_start_position = position
var transition_new_position = position
var new_room_size
var new_room_position
var old_limit_top
var old_limit_bottom
var old_limit_left
var old_limit_right
var new_limit_top
var new_limit_bottom
var new_limit_left
var new_limit_right

var swing_timer_just_stopped = false

func _process(delta: float) -> void:
	# TODO: Should this be here? Or in physics_process?
	if !room_transition_timer.is_stopped():
		do_room_transition()

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
	begin_room_transition(room_size, room_position)


func begin_room_transition(room_size, room_position) -> void:
	new_room_size = room_size
	new_room_position = room_position
	
	old_limit_top = camera.limit_top
	old_limit_left = camera.limit_left
	old_limit_bottom = camera.limit_bottom
	old_limit_right = camera.limit_right
	new_limit_top = new_room_position.y as int
	new_limit_left = new_room_position.x as int
	# TODO: A magic number most sinister... We should replace it with some global constant referring to the UI size, perhaps.
	new_limit_bottom = (new_room_position.y + new_room_size.y + 16) as int
	new_limit_right = (new_room_position.x + new_room_size.x) as int
	
	can_move = false
	transition_start_position = position
	# TODO: The 16s here should probably be some sort of TILE_SIZE constant or something.
	match move_dir:
		"down":
			transition_new_position = position
			transition_new_position.y = transition_new_position.y + 16 + 1
			#camera.limit_top = -10000000
			#camera.limit_bottom = 10000000
		"up":
			transition_new_position = position
			transition_new_position.y = transition_new_position.y - 16 - 1
			#camera.limit_top = -10000000
			#camera.limit_bottom = 10000000

		"right":
			transition_new_position = position
			transition_new_position.x = transition_new_position.x + 16 + 1
			#camera.limit_left = -10000000
			#camera.limit_right = 10000000
		"left":
			transition_new_position = position
			transition_new_position.x = transition_new_position.x - 16 - 1
			#camera.limit_left = -10000000
			#camera.limit_right = 10000000
		
		# TODO: We should be throwing an error here, but we don't because we actually have a "room transition" when the player first spawns.
		#       This is kind of fucking stupid.
		"none":
			transition_new_position = position
			#push_error("Transitioning to a new room without a movement direction. What happened?")
	
	
	room_transition_timer.start()
	#print(room_size)
	#print(room_position)

	
func do_room_transition() -> void:
	var weight = room_transition_timer.time_left/room_transition_timer.wait_time
	# TODO: We actually have from and to reversed here. Would it be better if this weren't the case?
	position = lerp(transition_new_position, transition_start_position, weight)
	camera.limit_bottom = lerp(new_limit_bottom, old_limit_bottom, weight)
	camera.limit_left = lerp(new_limit_left, old_limit_left, weight)
	camera.limit_right = lerp(new_limit_right, old_limit_right, weight)
	camera.limit_top = lerp(new_limit_top, old_limit_top, weight)
	

func _on_room_transition_timer_timeout() -> void:
	can_move = true
	camera.limit_bottom = new_limit_bottom
	camera.limit_left = new_limit_left
	camera.limit_right = new_limit_right
	camera.limit_top = new_limit_top
	
