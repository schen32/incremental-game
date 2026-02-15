extends Node2D

@export var float_speed := 35.0
@export var lifetime := 0.6
@export var spread_x := 10.0

@onready var label: Label = $Label

var _t := 0.0
var _vel := Vector2.ZERO

func setup(amount: int) -> void:
	label.text = str(amount)
	_vel = Vector2(randf_range(-spread_x, spread_x), -float_speed)

func _process(delta: float) -> void:
	_t += delta
	position += _vel * delta
	_vel.y += 80.0 * delta # tiny gravity / ease

	label.modulate.a = 1.0 - clamp(_t / lifetime, 0.0, 1.0)

	if _t >= lifetime:
		queue_free()
