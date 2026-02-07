extends Node2D

@export var source_id := 0  # TileSet source id (usually 0 for an atlas source)

@onready var highlight_controller: Node2D = $"../HighlightTile"
@onready var ground: TileMapLayer = $"../../Tiles/Ground"
@onready var player_inventory: Node = $"../../Player/Inventory"

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("place_tile"):
		try_place()

func try_place() -> void:
	var cell: Vector2i = highlight_controller.current_hover_cell
	if cell.x > 100000 or ground.get_cell_source_id(cell) != -1:
		return

	var id: StringName = player_inventory.selected_item
	if player_inventory.get_amount(id) <= 0:
		return
	var atlas: Vector2i = player_inventory.get_atlas_coords(id)

	ground.set_cell(cell, source_id, atlas, 0)
	player_inventory.remove_item(id, 1)
