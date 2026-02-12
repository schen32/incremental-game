extends Panel

@export var slot_scene: PackedScene
@export var style_box: StyleBoxFlat

@onready var item_name: Label = $ItemName
@onready var description: Label = $Description
@onready var input_grid: GridContainer = $InputGrid

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	
func _process(_delta: float) -> void:
	if visible:
		global_position = get_global_mouse_position() + Vector2(8, 8)

func show_tooltip(index: int) -> void:
	visible = true
	_refresh()
	
func hide_tooltip(index: int) -> void:
	visible = false

func _refresh() -> void:
	_clear_children(input_grid)

	for i in range(10):
		var ui_slot = slot_scene.instantiate()
		input_grid.add_child(ui_slot)
		ui_slot.index = i
		ui_slot.set_slot(&"", 0)
		ui_slot.add_theme_stylebox_override(&"panel", style_box)

func _clear_children(node: Node) -> void:
	for c in node.get_children():
		c.queue_free()
