extends Node2D

@onready var available_recipes = $"../AvailableRecipes"
@onready var inventory_move_items = $"../InventoryMoveItems"
@onready var player_inventory = $"../../Player/Inventory"

func craft_recipe(index: int, button: int) -> void:
	if button != MOUSE_BUTTON_LEFT:
		return
	if inventory_move_items.held_stack != null:
		return
	
	var recipe = available_recipes.recipes[index]
	if not player_inventory.consume_requirements(recipe.inputs):
		return
	inventory_move_items.held_stack = player_inventory.new_item_stack(recipe.output_id, recipe.output_amount)
