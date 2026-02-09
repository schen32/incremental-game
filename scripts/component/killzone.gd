extends Area2D

@export var killzone_damage := 999999

@onready var respawn_point: Node2D = $"../RespawnPoint"

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	var health := body.get_node_or_null("Health")
	if health != null:
		health.damage(killzone_damage)
	
	call_deferred("_teleport_body", body)

func _teleport_body(body: Node) -> void:
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
		
		pop(body)

func pop(body: Node) -> void:
	body.apply_impulse(Vector2(randf_range(-16, 16), randf_range(-42, -26)))
