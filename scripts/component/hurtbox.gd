extends Area2D

@onready var body: CharacterBody2D = get_parent()
@onready var health: Node2D = $"../Health"
@onready var knockback: Node2D = $"../Knockback"
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	health.died.connect(_on_died)

func _on_died() -> void:
	collision_shape.set_deferred("disabled", true)
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)

func apply_damage(amount: int) -> void:
	health.damage(amount)

func apply_knockback(from_pos, force) -> void:
	var dir = (body.global_position - from_pos).normalized()
	knockback.apply_knockback(dir, force)
