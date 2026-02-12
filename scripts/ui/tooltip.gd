extends Panel

@export var slot_scene: PackedScene
@export var style_box: StyleBoxFlat

@onready var item_name: Label = $ItemName
@onready var description: Label = $Description
@onready var input_grid: GridContainer = $InputGrid
@onready var output_grid: GridContainer = $OutputGrid
@onready var available: Node2D = $"../../../GameScripts/AvailableRecipes"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	
func _process(_delta: float) -> void:
	if visible:
		global_position = get_global_mouse_position() + Vector2(8, 8)

func show_tooltip(index: int) -> void:
	visible = true
	
	var recipe_data: RecipeData = available.recipes[index]
	var output_data: ItemData = ItemDatabase.get_item(recipe_data.output_id)
	item_name.text = output_data.display_name
	
	_refresh(recipe_data)
	
func hide_tooltip(index: int) -> void:
	visible = false

func _refresh(recipe_data: RecipeData) -> void:
	_clear_children(input_grid)
	_clear_children(output_grid)

	for key in recipe_data.inputs.keys():
		var ui_slot = slot_scene.instantiate()
		input_grid.add_child(ui_slot)
		
		ui_slot.set_slot(key, recipe_data.inputs[key])
		ui_slot.add_theme_stylebox_override(&"panel", style_box)
		
	var ui_slot = slot_scene.instantiate()
	output_grid.add_child(ui_slot)

	ui_slot.set_slot(recipe_data.output_id, recipe_data.output_amount)
	ui_slot.add_theme_stylebox_override(&"panel", style_box)

func _clear_children(node: Node) -> void:
	for c in node.get_children():
		c.queue_free()
