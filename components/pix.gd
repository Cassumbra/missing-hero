extends CharacterBody2D

@export var speed: float = 1
@export var min_time: float = 0.5
@export var max_time: float = 1.5

@onready var timer = $WanderTimer

var move_dir = Vector2(0.0, 0.0)
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	choose_random_direction()
	start_timer()

func _physics_process(delta: float) -> void:
	velocity = move_dir * speed;
	
	move_and_slide()

func start_timer() -> void:
	timer.wait_time = rng.randf_range(min_time, max_time)
	timer.start()

func choose_random_direction() -> void:
	match rng.randi_range(0, 3):
		0:
			move_dir = Vector2.UP
		1:
			move_dir = Vector2.DOWN
		2:
			move_dir = Vector2.LEFT
		3:
			move_dir = Vector2.RIGHT


func _on_wander_timer_timeout() -> void:
	start_timer()
	choose_random_direction()
