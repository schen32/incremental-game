extends Node2D

@export var interact_range := 3

@onready var player: CharacterBody2D = $"../../Player"
@onready var ground: TileMapLayer = $"../../Tiles/Ground"
@onready var highlight: Node2D = $"../../Tiles/Highlight"

var current_hover_cell: Vector2i = Vector2i(999999, 999999) # invalid default

func _process(_delta):
	var mouse_world = get_global_mouse_position()

	var hover_cell: Vector2i = ground.local_to_map(ground.to_local(mouse_world))
	var player_cell: Vector2i = ground.local_to_map(ground.to_local(player.global_position))

	if ground.get_cell_source_id(hover_cell) == -1:
		highlight.visible = false
		current_hover_cell = Vector2i(999999, 999999)
		return

	var dist = max(abs(player_cell.x - hover_cell.x), abs(player_cell.y - hover_cell.y))

	if dist <= interact_range:
		highlight.visible = true
		highlight.global_position = ground.map_to_local(hover_cell)
		current_hover_cell = hover_cell
	else:
		highlight.visible = false
		current_hover_cell = Vector2i(999999, 999999)
