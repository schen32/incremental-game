extends Node2D

signal changed

class RecipeEntry:
	var recipe: RecipeData
	var can_craft: bool = false

	func _init(_recipe: RecipeData, _can_craft := false) -> void:
		recipe = _recipe
		can_craft = _can_craft

var recipes: Array[RecipeEntry] = []

@onready var player_inventory: Node2D = $"../../Player/Inventory"

func _ready() -> void:
	recipes.clear()
	for recipe in RecipeDatabase.recipes.values():
		recipes.append(RecipeEntry.new(recipe))

	_update_can_craft()
	player_inventory.changed.connect(_update_can_craft)


func _update_can_craft() -> void:
	for entry in recipes:
		entry.can_craft = player_inventory.has_requirements(entry.recipe.inputs)
	changed.emit()
