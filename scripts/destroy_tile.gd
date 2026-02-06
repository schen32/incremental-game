extends Node2D

@export var break_time := 0.6

@onready var highlight_controller: Node2D = $"../HighlightTile"
@onready var ground: TileMapLayer = $"../../Tiles/Ground"

var breaking := false
var break_progress := 0.0
var breaking_cell: Vector2i = Vector2i(999999, 999999)

func _process(delta: float) -> void:
	var holding := Input.is_action_pressed("destroy_tile")

	if holding:
		_try_break(delta)
	else:
		_cancel_break()

func _try_break(delta: float) -> void:
	var cell = highlight_controller.current_hover_cell
	if cell.x > 100000:
		_cancel_break()
		return

	# If player moved hover to a different tile, reset progress
	if not breaking or cell != breaking_cell:
		breaking = true
		breaking_cell = cell
		break_progress = 0.0

	break_progress += delta
	if break_progress >= break_time:
		if ground.get_cell_source_id(breaking_cell) != -1:
			ground.erase_cell(breaking_cell)

		_cancel_break()

func _cancel_break() -> void:
	breaking = false
	break_progress = 0.0
	breaking_cell = Vector2i(999999, 999999)
