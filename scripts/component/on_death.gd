extends Node2D

@onready var health: Node2D = $"../Health"
@onready var sprite: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var body: CharacterBody2D = get_parent()

var dead := false

func _ready() -> void:
	health.died.connect(_on_died)

func _on_died() -> void:
	if dead:
		return
	dead = true

	body.set_physics_process(false)

	# Play death animation
	sprite.play("death")
	await sprite.animation_finished
	body.queue_free()
