extends AnimatedSprite2D

@export var iframes: Timer

@export var blink_time: int = 10

func _ready() -> void:
	iframes.connect("timeout", _on_iframes_timeout)
	if iframes:
		await iframes.ready

func _process(delta: float) -> void:
	if not iframes.is_stopped():
		if (iframes.time_left * 100) as int % blink_time == 0:
			visible = !visible

func _on_iframes_timeout() -> void:
	visible = true
