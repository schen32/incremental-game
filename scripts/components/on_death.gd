extends Node2D

@export var dropped_item: PackedScene
@export var dropped_item_id: StringName = &"gem"
@export var dropped_item_amount: int = 1

@onready var health: Node2D = $"../Health"
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
	
	for i in range(dropped_item_amount):
		var item := dropped_item.instantiate()
		get_tree().current_scene.add_child(item)
		item.global_position = body.global_position
		item.set_item(dropped_item_id)
		item.pop(2)
	
	await anim_controller.anim_finished
	body.queue_free()
