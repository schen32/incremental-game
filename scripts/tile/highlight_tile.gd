extends Node2D

@export var interact_range := 3

@onready var player: CharacterBody2D = $"../../Player"
@onready var ground: TileMapLayer = $"../../AllTiles/Tiles"
@onready var highlight: Node2D = $"Highlight"

const INVALID_CELL := Vector2i(999999, 999999)
var current_hover_cell: Vector2i = INVALID_CELL

func _process(_delta: float) -> void:
	var mouse_world := get_global_mouse_position()

	var hover_cell: Vector2i = ground.local_to_map(ground.to_local(mouse_world))
	var player_cell: Vector2i = ground.local_to_map(ground.to_local(player.global_position))

	var dx = abs(player_cell.x - hover_cell.x)
	var dy = abs(player_cell.y - hover_cell.y)
	var dist = max(dx, dy)  # square range

	if dist <= interact_range:
		highlight.visible = true
		# correct coordinate space:
		highlight.global_position = ground.to_global(ground.map_to_local(hover_cell))
		current_hover_cell = hover_cell
	else:
		highlight.visible = false
		current_hover_cell = INVALID_CELL
