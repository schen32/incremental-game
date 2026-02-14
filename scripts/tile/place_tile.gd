extends Node2D

@export var source_id := 0  # TileSet source id (atlas source is usually 0)
@onready var highlight_controller: Node2D = $"../HighlightTile"
@onready var player: CharacterBody2D = $"../../Player"
@onready var place_sound: AudioStreamPlayer2D = $PlaceSound
@onready var world: Node2D = $"../../GameNodes/WorldBlocks"

func try_place(tile_data: ItemData) -> bool:
	var tilemap = world.tilemap
	var cell: Vector2i = highlight_controller.current_hover_cell

	# invalid / already occupied
	if cell.x > 100000 or tilemap.get_cell_source_id(cell) != -1:
		return false

	# don't place inside player
	var player_cell: Vector2i = tilemap.local_to_map(tilemap.to_local(player.global_position))
	if cell == player_cell:
		return false

	world.set_block(cell, source_id, tile_data.atlas_coords)

	SoundManager.play_player(place_sound, world.cell_to_world(cell))
	return true
