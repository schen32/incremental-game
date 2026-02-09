extends RigidBody2D

var item_id: StringName

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func set_item(_item_id: StringName) -> void:
	item_id = _item_id
	var item_data: ItemData = ItemDatabase.get_item(_item_id)
	
	sprite.texture = item_data.texture
	sprite.region_enabled = true
	sprite.region_rect = Rect2i(item_data.atlas_coords * item_data.tile_size, item_data.tile_size)
	
func pop() -> void:
	apply_impulse(Vector2(randf_range(-16, 16), randf_range(-42, -26)))
