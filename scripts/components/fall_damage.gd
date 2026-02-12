extends Node2D

@export var safe_fall_distance := 128.0
@export var damage_per_16px := 3

var fall_start_y := 0.0
var was_on_floor := false

@onready var body: CharacterBody2D = get_parent()
@onready var health = body.get_node("Health")

func _ready() -> void:
	# Wait one physics frame so is_on_floor() is correct on spawn
	await get_tree().physics_frame
	
	was_on_floor = body.is_on_floor()
	fall_start_y = body.global_position.y

func _physics_process(_delta: float) -> void:
	if not body.is_on_floor() and was_on_floor:
		fall_start_y = body.global_position.y

	if body.is_on_floor() and not was_on_floor:
		var fall_distance := body.global_position.y - fall_start_y
		if fall_distance > safe_fall_distance:
			var dmg := int((fall_distance / 16.0) * damage_per_16px)
			health.damage(dmg)

	was_on_floor = body.is_on_floor()
