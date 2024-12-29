extends Area2D

class_name bossStateTrigger


@export var state_number : int = 1

signal begin_phase_signal
var active : bool = false

func reset(state_num):
	if (state_number == state_num+1):
		active = true

func _on_body_entered(body):
	if (body is rigidPlayer):
		active = false
		emit_signal("begin_phase_signal", state_number)
