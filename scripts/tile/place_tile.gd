extends Node2D

@export var source_id := 0  # TileSet source id (usually 0 for an atlas source)

@onready var highlight_controller: Node2D = $"../HighlightTile"
@onready var ground: TileMapLayer = $"../../AllTiles/Tiles"
@onready var player_inventory: Node = $"../../Player/Inventory"
@onready var player: CharacterBody2D = $"../../Player"
@onready var place_sound: AudioStreamPlayer2D = $PlaceSound

func _process(_delta: float) -> void:
	if Input.is_action_pressed("place_tile"):
		try_place()

func try_place() -> void:
	var cell: Vector2i = highlight_controller.current_hover_cell
	if cell.x > 100000 or ground.get_cell_source_id(cell) != -1:
		return
	
	var player_cell: Vector2i = ground.local_to_map(ground.to_local(player.global_position))
	if cell == player_cell:
		return
	
	var selected_item = player_inventory.get_selected_data()
	if selected_item == null or selected_item.amount <= 0:
		return

	ground.set_cell(cell, source_id, selected_item.atlas_coords, 0)
	player_inventory.remove_item_from_slot(selected_item.index, 1)
	play_place_sound(cell)
	
func play_place_sound(cell_pos: Vector2i) -> void:
	place_sound.pitch_scale = randf_range(0.8, 1.2)
	place_sound.volume_db = -2 + randf_range(-2.0, 2.0)
	place_sound.global_position = ground.to_global(ground.map_to_local(cell_pos))
	place_sound.play()
