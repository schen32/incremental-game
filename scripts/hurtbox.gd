extends Area2D

@onready var body: CharacterBody2D = get_parent()
@onready var health: Node2D = $"../Health"
@onready var knockback: Node2D = $"../Knockback"

func apply_damage(amount: int) -> void:
	health.damage(amount)

func apply_knockback(from_pos, force, duration) -> void:
	var dir = (body.global_position - from_pos).normalized()
	knockback.apply_knockback(dir, force, duration)
