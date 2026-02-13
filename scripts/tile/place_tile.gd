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
	SoundManager.play_player(place_sound)
	return true
