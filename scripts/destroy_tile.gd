extends Node2D

@onready var highlight_controller: Node2D = $"../HighlightTile"
@onready var ground: TileMapLayer = $"../../Tiles/Ground"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("destroy_tile"):
		try_destroy_hovered_tile()

func try_destroy_hovered_tile():
	var cell = highlight_controller.current_hover_cell
	if cell.x > 100000: # invalid
		return

	ground.erase_cell(cell)
