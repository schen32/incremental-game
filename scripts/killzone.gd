extends Area2D

@onready var respawn_point: Node2D = $"../RespawnPoint"

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		_respawn_player(body)

func _respawn_player(player: Node) -> void:
	# stop movement
	if player is CharacterBody2D:
		player.velocity = Vector2.ZERO

	# teleport
	player.global_position = respawn_point.global_position
