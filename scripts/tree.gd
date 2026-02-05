extends TileMapLayer

# Tile info (adjust these to match your TileSet)
const SOURCE_ID := 0
const ATLAS_COORD := Vector2i(8, 0)
const ALT := 0

var grow_timer := 0.0
var grow_interval := 1.0   # seconds per new block

var root := Vector2i(0, 0)
var top := Vector2i(0, 0)

func _ready() -> void:
	set_cell(root, SOURCE_ID, ATLAS_COORD, ALT)
	top = root

func _process(delta: float) -> void:
	grow_timer += delta
	if grow_timer >= grow_interval:
		grow_timer = 0.0
		grow_one_cell()

func grow_one_cell():
	var next := top + Vector2i(0, -1)  # grow upward
	if get_cell_source_id(next) == -1:
		set_cell(next, SOURCE_ID, ATLAS_COORD, ALT)
		top = next
