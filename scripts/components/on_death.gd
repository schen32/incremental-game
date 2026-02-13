extends Node2D

@onready var health: Node2D = $"../Health"
@onready var sprite: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var body: CharacterBody2D = get_parent()
@onready var motor: Node2D = $"../Motor"
@onready var anim_controller: Node2D = $"../AnimationController"
@onready var death_sound: AudioStreamPlayer2D = $"DeathSound"

var dead := false

func _ready() -> void:
	health.died.connect(_on_died)

func _on_died() -> void:
	if dead:
		return
	dead = true

	motor.freeze()

	anim_controller.play_anim(&"death")
	SoundManager.play_player(death_sound)
	await anim_controller.anim_finished
	body.queue_free()
