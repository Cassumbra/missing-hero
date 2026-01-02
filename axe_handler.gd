extends Node2D

@onready var axe_swing = $AxeSwing
@onready var swinging_timer: Timer = $SwingingTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_swing_axe(direction: String) -> void:
	axe_swing.visible = true
	swinging_timer.start()
	
	match direction:
		"down":
			rotation_degrees = 0.0
		"up":
			rotation_degrees = 180.0
		"left":
			rotation_degrees = 90.0
		"right":
			rotation_degrees = 270.0


func _on_swinging_timer_timeout() -> void:
	axe_swing.visible = false
