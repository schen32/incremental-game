extends Resource
class_name ItemData

@export var id: StringName
@export var display_name: StringName
@export var texture: Texture2D
@export var atlas_coords: Vector2i

@export var is_placeable: bool = false
@export var can_destroy_tiles: bool = true

@export var tile_size: int = 16

func get_region() -> Rect2:
	return Rect2(atlas_coords * tile_size, Vector2(tile_size, tile_size))
