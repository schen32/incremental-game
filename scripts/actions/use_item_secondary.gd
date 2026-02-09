extends Node2D

@onready var place_tile: Node2D = $"../PlaceTile"
@onready var player_inventory: Node = $"../../Player/Inventory"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("use_secondary"):
		var selected_item = player_inventory.get_selected_item()
		if selected_item == null or selected_item.amount <= 0:
			return
		var selected_item_data := ItemDatabase.get_item(selected_item.id)

		if selected_item_data.is_placeable and place_tile.try_place(selected_item_data):
			player_inventory.remove_item_from_slot(selected_item.index, 1)
