class_name HurtBox
extends Area2D


## Gets compared to other hurtboxes to see which (if either) takes damage.
@export var strength: int = 0

@export var damage: int = 1

@export var health: Health

@export var iframes: Timer

func _ready() -> void:
	#connect("area_entered", _on_area_entered)
	#iframes.connect("timeout", _on_iframes_timeout)
	if health:
		await health.ready
	if iframes:
		await iframes.ready

func _process(delta: float) -> void:
	if has_overlapping_areas():
		for area in get_overlapping_areas():
			if (area as HurtBox).strength > strength and iframes.is_stopped():
				health.value -= (area as HurtBox).damage
				iframes.start()
	
		
#func _on_iframes_timeout() -> void:
#	print("bwee!")
