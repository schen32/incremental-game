extends Control

@export var slot_scene: PackedScene
@export var style_box: StyleBoxFlat
@onready var recipe_grid: GridContainer = $ScrollContainer/RecipeGrid
@onready var tooltip: Panel = $"../TooltipUI"

func _ready() -> void:
	_refresh()

func _refresh() -> void:
	_clear_children(recipe_grid)

	var i = 0
	for recipe in RecipeDatabase.recipes:
		var ui_slot = slot_scene.instantiate()
		recipe_grid.add_child(ui_slot)
		ui_slot.index = i
		ui_slot.set_slot(recipe, 1)
		ui_slot.add_theme_stylebox_override(&"panel", style_box)
		
		ui_slot.hovered.connect(tooltip.show_tooltip)
		ui_slot.unhovered.connect(tooltip.hide_tooltip)
		i += 1

func _clear_children(node: Node) -> void:
	for c in node.get_children():
		c.queue_free()
