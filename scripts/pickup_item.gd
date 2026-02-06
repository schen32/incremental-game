extends RigidBody2D

@export var item: StringName = &"grass"
@export var tile_size := Vector2i(16, 16)

@onready var sprite: Sprite2D = $Sprite2D

func apply_appearance(atlas_coords: Vector2i) -> void:
	sprite.region_enabled = true
	sprite.region_rect = Rect2(Vector2(atlas_coords) * Vector2(tile_size), Vector2(tile_size))

func pop() -> void:
	apply_impulse(Vector2(randf_range(-16, 16), randf_range(-42, -26)))
