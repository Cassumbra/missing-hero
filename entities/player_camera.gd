class_name PlayerCamera
extends Camera2D

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


# TODO: Maybe we should tidy up by moving some of this code and the variables into a camera script?
func begin_room_transition(room_size, room_position, move_dir, player_position) -> void:
	new_room_size = room_size
	new_room_position = room_position
	
	old_limit_top = limit_top
	old_limit_left = limit_left
	old_limit_bottom = limit_bottom
	old_limit_right = limit_right
	new_limit_top = new_room_position.y as int
	new_limit_left = new_room_position.x as int
	# TODO: A magic number most sinister... We should replace it with some global constant referring to the UI size, perhaps.
	new_limit_bottom = (new_room_position.y + new_room_size.y + 16) as int
	new_limit_right = (new_room_position.x + new_room_size.x) as int
	
	#can_move = false
	transition_start_position = player_position
	# TODO: The 16s here should probably be some sort of TILE_SIZE constant or something.
	match move_dir:
		"down":
			transition_new_position = player_position
			transition_new_position.y = transition_new_position.y + 16 + 1
			#camera.limit_top = -10000000
			#camera.limit_bottom = 10000000
		"up":
			transition_new_position = player_position
			transition_new_position.y = transition_new_position.y - 16 - 1
			#camera.limit_top = -10000000
			#camera.limit_bottom = 10000000

		"right":
			transition_new_position = player_position
			transition_new_position.x = transition_new_position.x + 16 + 1
			#camera.limit_left = -10000000
			#camera.limit_right = 10000000
		"left":
			transition_new_position = player_position
			transition_new_position.x = transition_new_position.x - 16 - 1
			#camera.limit_left = -10000000
			#camera.limit_right = 10000000
		
		# TODO: We should be throwing an error here, but we don't because we actually have a "room transition" when the player first spawns.
		#       This is kind of fucking stupid.
		"none":
			transition_new_position = player_position
			#push_error("Transitioning to a new room without a movement direction. What happened?")
	
	#room_transition_timer.start()
	
	#print(room_size)
	#print(room_position)


func do_room_transition(room_transition_timer) -> Vector2:
	var weight = room_transition_timer.time_left/room_transition_timer.wait_time
	# TODO: We actually have from and to reversed here. Would it be better if this weren't the case?
	var player_position = lerp(transition_new_position, transition_start_position, weight)
	limit_bottom = lerp(new_limit_bottom, old_limit_bottom, weight)
	limit_left = lerp(new_limit_left, old_limit_left, weight)
	limit_right = lerp(new_limit_right, old_limit_right, weight)
	limit_top = lerp(new_limit_top, old_limit_top, weight)
	return player_position

func finish_room_transition() -> void:
	limit_bottom = new_limit_bottom
	limit_left = new_limit_left
	limit_right = new_limit_right
	limit_top = new_limit_top
