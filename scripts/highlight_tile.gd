extends Node2D

@export var range_tiles := 3

@onready var player: CharacterBody2D = $Player
@onready var ground: TileMapLayer = $Tiles/Ground
@onready var highlight: ColorRect = $Tiles/Highlight

func _process(delta):
	var mouse_world = get_global_mouse_position()

	var hover_cell: Vector2i = ground.local_to_map(ground.to_local(mouse_world))
	var player_cell: Vector2i = ground.local_to_map(ground.to_local(player.global_position))

	if ground.get_cell_source_id(hover_cell) == -1:
		highlight.visible = false
		return

	var dist = max(abs(player_cell.x - hover_cell.x), abs(player_cell.y - hover_cell.y))

	if dist <= range_tiles:
		highlight.visible = true
		highlight.global_position = ground.map_to_local(hover_cell) - highlight.size * 0.5
	else:
		highlight.visible = false
