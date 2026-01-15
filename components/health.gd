class_name Health
extends Node


@export var max_value: int = 12
var value = max_value

func change_value(change):
	value += change
