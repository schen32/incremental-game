extends Panel

@export var tile_size := Vector2i(16, 16)

@onready var icon: TextureRect = $Icon
@onready var count: Label = $Count

func set_slot(atlas_coords: Vector2i, amt: int) -> void:
	var atlas := AtlasTexture.new()
	atlas.atlas = preload("res://assets/tetris-Sheet.png")
	atlas.region = Rect2(Vector2(atlas_coords) * Vector2(tile_size), Vector2(tile_size))

	icon.texture = atlas
	count.text = str(amt) if amt > 0 else ""
