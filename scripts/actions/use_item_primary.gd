extends Node2D

@onready var destroy_tile: Node2D = $"../DestroyTile"
@onready var player_inventory: Node = $"../../Player/Inventory"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("use_primary"):
		var selected_item = player_inventory.get_selected_item()
		if selected_item != null:
			var selected_item_data := ItemDatabase.get_item(selected_item.id)
			if not selected_item_data.can_destroy_tiles:
				return

		var holding := Input.is_action_pressed("use_primary")
		if holding:
			destroy_tile.try_break(delta)
		else:
			destroy_tile.cancel_break()
