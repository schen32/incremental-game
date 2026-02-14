extends Node2D

@export var dropped_item: PackedScene
@export var dropped_item_id: StringName = &"gem"
@export var dropped_item_amount: int = 1
@export var drop_radius_px := 6.0
@export var pop_multiplier := 2.0

@onready var health := $"../Health"
@onready var body: CharacterBody2D = get_parent()
@onready var motor := $"../Motor"
@onready var anim_controller := $"../AnimationController"
@onready var death_sound: AudioStreamPlayer2D = $"DeathSound"

var dead := false

func _ready() -> void:
	health.died.connect(_on_died)

func _on_died() -> void:
	if dead:
		return
	dead = true
	call_deferred("_do_death")

func _do_death() -> void:
	_disable_collisions()

	if motor and motor.has_method("freeze"):
		motor.freeze()

	if anim_controller and anim_controller.has_method("play_anim"):
		anim_controller.play_anim(&"death")

	if death_sound:
		SoundManager.play_player(death_sound)

	_drop_items()

	if anim_controller and anim_controller.has_signal("anim_finished"):
		await anim_controller.anim_finished
	else:
		await get_tree().create_timer(0.6).timeout

	body.queue_free()

func _drop_items() -> void:
	if dropped_item == null or dropped_item_amount <= 0:
		return

	for i in range(dropped_item_amount):
		var item := dropped_item.instantiate()
		get_tree().current_scene.add_child(item)

		var offset := Vector2(
			randf_range(-drop_radius_px, drop_radius_px),
			randf_range(-drop_radius_px, drop_radius_px)
		)

		item.global_position = body.global_position + offset

		if item.has_method("set_item"):
			item.set_item(dropped_item_id)
		if item.has_method("pop"):
			item.pop(pop_multiplier)

func _disable_collisions() -> void:
	# Disable the enemy's main collision shape (adjust path if yours differs)
	var shape := body.get_node_or_null("CollisionShape2D") as CollisionShape2D
	if shape:
		shape.set_deferred("disabled", true)

	# If you have a hurtbox Area2D, disable it too (adjust path/name)
	var hurtbox := body.get_node_or_null("Hurtbox") as Area2D
	if hurtbox:
		hurtbox.set_deferred("monitoring", false)
		hurtbox.set_deferred("monitorable", false)
