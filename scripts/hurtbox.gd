extends Area2D

@onready var health: Node2D = $"../Health"

func apply_damage(amount: int) -> void:
	health.damage(amount)
