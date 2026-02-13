extends Node2D

@onready var available_recipes = $"../AvailableRecipes"
@onready var inventory_move_items = $"../InventoryMoveItems"
@onready var player_inventory = $"../../Player/Inventory"

func craft_recipe(index: int, button: int) -> void:
	if button != MOUSE_BUTTON_LEFT:
		return

	var recipe: RecipeData = available_recipes.recipes[index]
	if inventory_move_items.held_stack != null and inventory_move_items.held_stack.id != recipe.output_id:
		return
	if not player_inventory.consume_requirements(recipe.inputs):
		return

	if inventory_move_items.held_stack == null:
		inventory_move_items.set_held(player_inventory.new_item_stack(recipe.output_id, recipe.output_amount))
	else:
		inventory_move_items.add_to_held(recipe.output_id, recipe.output_amount)
