extends Node2D

@export var source_id := 0  # TileSet source id (usually 0 for an atlas source)

@onready var highlight_controller: Node2D = $"../HighlightTile"
@onready var ground: TileMapLayer = $"../../AllTiles/Tiles"
@onready var player: CharacterBody2D = $"../../Player"
@onready var place_sound: AudioStreamPlayer2D = $PlaceSound

func try_place(tile_data: ItemData) -> bool:
	var cell: Vector2i = highlight_controller.current_hover_cell
	if cell.x > 100000 or ground.get_cell_source_id(cell) != -1:
		return false
	
	var player_cell: Vector2i = ground.local_to_map(ground.to_local(player.global_position))
	if cell == player_cell:
		return false

	ground.set_cell(cell, source_id, tile_data.atlas_coords, 0)
	play_place_sound(cell)
	return true
	
func play_place_sound(cell_pos: Vector2i) -> void:
	place_sound.pitch_scale = randf_range(0.8, 1.2)
	place_sound.volume_db = -2 + randf_range(-2.0, 2.0)
	place_sound.global_position = ground.to_global(ground.map_to_local(cell_pos))
	place_sound.play()
