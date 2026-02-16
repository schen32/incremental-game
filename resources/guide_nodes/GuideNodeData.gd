extends Resource
class_name GuideNodeData

@export var texture: Texture2D
@export var atlas_coords: Vector2i
@export var tile_size: int = 16

@export var title: StringName
@export var description: StringName
@export var requirements: Dictionary = {}
@export var rewards: Dictionary = {}

func get_region() -> Rect2:
	return Rect2(atlas_coords * tile_size, Vector2(tile_size, tile_size))
