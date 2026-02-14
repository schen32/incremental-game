extends RigidBody2D

@export var item_id: StringName = &""
@export var pop_strength := 40.0        # overall force
@export var pop_spread_x := 0.5         # how wide it can spray horizontally (0–1)
@export var pop_upward_bias := 1.0      # how strongly it prefers going up (1 = full up)

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	if item_id != &"":
		set_item(item_id)

func set_item(_item_id: StringName) -> void:	
	item_id = _item_id
	var item_data: ItemData = ItemDatabase.get_item(_item_id)

	sprite.texture = item_data.texture
	sprite.region_enabled = true
	sprite.region_rect = item_data.get_region()

func pop(multiplier := 1.0) -> void:
	var x_dir := randf_range(-pop_spread_x, pop_spread_x)
	var y_dir := -pop_upward_bias
	var dir := Vector2(x_dir, y_dir).normalized()

	apply_impulse(dir * pop_strength * multiplier)
