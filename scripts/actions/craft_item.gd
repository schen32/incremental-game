extends Node2D

@onready var available_recipes = $"../AvailableRecipes"
@onready var inventory_move_items = $"../InventoryMoveItems"
@onready var player_inventory = $"../../Player/Inventory"

func craft_recipe(index: int, button: int) -> void:
	if button != MOUSE_BUTTON_LEFT:
		return

	var entry = available_recipes.recipes[index]
	var recipe: RecipeData = entry.recipe

	# Only craft if held is empty or same item (so it can stack)
	if inventory_move_items.held_stack != null and inventory_move_items.held_stack.id != recipe.output_id:
		return

	# Must be craftable AND must successfully consume inputs
	if not entry.can_craft:
		return
	if not player_inventory.consume_requirements(recipe.inputs):
		return

	# Put output into held (stack if same)
	if inventory_move_items.held_stack == null:
		inventory_move_items.set_held(player_inventory.new_item_stack(recipe.output_id, recipe.output_amount))
	else:
		inventory_move_items.add_to_held(recipe.output_id, recipe.output_amount)
