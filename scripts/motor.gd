extends Node2D

@onready var body: CharacterBody2D = get_parent()

var external_velocity := Vector2.ZERO
var frozen := false

func request_knockback(v: Vector2) -> void:
	external_velocity = v

func freeze() -> void:
	frozen = true

func _physics_process(delta: float) -> void:
	if frozen:
		body.velocity = Vector2.ZERO
		body.move_and_slide()
		return

	# base velocity comes from AI script (it sets body.velocity.x, gravity, etc.)
	body.velocity += external_velocity
	external_velocity = external_velocity.move_toward(Vector2.ZERO, 2000.0 * delta)

	body.move_and_slide()
