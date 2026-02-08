extends Area2D

@onready var respawn_point: Node2D = $"../RespawnPoint"

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	call_deferred("_respawn_body", body)

func _respawn_body(body: Node) -> void:
	print("KILLZONE HIT: ", body.name, " at ", body.global_position)
	
	if body is CharacterBody2D:
		body.velocity = Vector2.ZERO
		body.global_position = respawn_point.global_position

	elif body is RigidBody2D:
		body.freeze = true
		body.linear_velocity = Vector2.ZERO
		body.angular_velocity = 0.0
		body.global_position = respawn_point.global_position
		body.sleeping = false
		body.freeze = false
