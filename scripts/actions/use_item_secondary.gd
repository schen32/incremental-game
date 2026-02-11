extends Node2D

@onready var place_tile: Node2D = $"../PlaceTile"
@onready var player_inventory: Node = $"../../Player/Inventory"
@onready var inventory_toggle: Node2D = $"../ToggleInventory"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("use_secondary"):
		if not inventory_toggle.inventory_shown:
			var selected_item = player_inventory.get_selected_item()
			if selected_item == null:
				return
			var selected_item_data := ItemDatabase.get_item(selected_item.id)

			if selected_item_data.is_placeable and place_tile.try_place(selected_item_data):
				player_inventory.remove_item_from_slot(selected_item.index, 1)
		elif Input.is_action_just_pressed("use_secondary"):
			print("inventory shown secondary action")
