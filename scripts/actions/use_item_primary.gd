extends Node2D

@onready var destroy_tile: Node2D = $"../DestroyTile"
@onready var player_inventory: Node2D = $"../../Player/Inventory"
@onready var inventory_toggle: Node2D = $"../ToggleInventory"

func _process(delta: float) -> void:
	var holding := Input.is_action_pressed("use_primary")
	if not holding:
		destroy_tile.cancel_break()
		return
	
	if not inventory_toggle.inventory_shown:
		var item = player_inventory.get_selected_item()
		if item == null:
			destroy_tile.try_break(delta)
			return

		var data: Resource = ItemDatabase.get_item(item.id)
		if data is WeaponData:
			var weapons_root := $"../../Player/Weapons"
			var weapon := weapons_root.get_node_or_null(NodePath(String(item.id)))
			if weapon and weapon.has_method("attack"):
				weapon.attack(data as WeaponData)
			destroy_tile.cancel_break()
			return

		if data is ItemData and data.can_destroy_tiles:
			destroy_tile.try_break(delta)
		else:
			destroy_tile.cancel_break()
	elif Input.is_action_just_pressed("use_primary"):
		print("inventory shown primary action")
