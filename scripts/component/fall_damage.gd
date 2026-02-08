extends Node2D

@export var safe_fall_distance := 128.0
@export var damage_per_16px := 1

var fall_start_y := 0.0
var was_on_floor := false

@onready var body: CharacterBody2D = get_parent()
@onready var health: Node2D = body.get_node("Health")

func _physics_process(delta):
	if not body.is_on_floor() and was_on_floor:
		fall_start_y = global_position.y

	if body.is_on_floor() and not was_on_floor:
		var fall_distance := global_position.y - fall_start_y
		if fall_distance > safe_fall_distance:
			var dmg := int((fall_distance / 16.0) * damage_per_16px)
			health.damage(dmg)

	was_on_floor = body.is_on_floor()
