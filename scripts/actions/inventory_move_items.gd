extends Node2D
class_name InventoryMoveItems

signal held_changed(held)

@onready var player_inventory: Node2D = $"../../Player/Inventory"

var held_stack = null # Inventory.ItemStack or null


func _on_slot_clicked(index: int, button: int) -> void:
	match button:
		MOUSE_BUTTON_LEFT:
			_left_click_slot(index)
		MOUSE_BUTTON_RIGHT:
			_right_click_slot(index)


func _left_click_slot(index: int) -> void:
	var slot_stack = player_inventory.slots[index]  # ItemStack or null

	# Pick up
	if held_stack == null:
		if slot_stack == null:
			return
		# remove from slot first, then hold it
		player_inventory.slots[index] = null
		set_held(slot_stack)
		player_inventory.changed.emit()
		return

	# Drop into empty slot
	if slot_stack == null:
		player_inventory.slots[index] = held_stack
		set_held(null)
		player_inventory.changed.emit()
		return

	# Merge (same id)
	if slot_stack.id == held_stack.id:
		slot_stack.amount += held_stack.amount
		set_held(null)
		player_inventory.changed.emit()
		return

	# Swap
	player_inventory.slots[index] = held_stack
	set_held(slot_stack)
	player_inventory.changed.emit()


func _right_click_slot(index: int) -> void:
	var slot_stack = player_inventory.slots[index]

	# Split the clicked stack into hand (take ceil(half))
	if held_stack == null:
		if slot_stack == null or slot_stack.amount <= 1:
			return

		var half := int(ceil(slot_stack.amount / 2.0))
		slot_stack.amount -= half

		# if we emptied the slot, clear it
		if slot_stack.amount <= 0:
			player_inventory.slots[index] = null

		set_held(player_inventory.new_item_stack(slot_stack.id, half))
		player_inventory.changed.emit()
		return

	# Place ONE into empty slot
	if slot_stack == null:
		player_inventory.slots[index] = player_inventory.new_item_stack(held_stack.id, 1)
		_remove_one_from_held()
		player_inventory.changed.emit()
		return

	# Add ONE into same-id slot
	if slot_stack.id == held_stack.id:
		slot_stack.amount += 1
		_remove_one_from_held()
		player_inventory.changed.emit()
		return
	# else: different item in slot -> do nothing


func _remove_one_from_held() -> void:
	if held_stack == null:
		return
	held_stack.amount -= 1
	if held_stack.amount <= 0:
		set_held(null)
	else:
		# same object, amount changed
		held_changed.emit(held_stack)


func set_held(new_stack) -> void:
	held_stack = new_stack
	held_changed.emit(held_stack)


func add_to_held(id: StringName, amount: int) -> bool:
	if amount <= 0:
		return true

	if held_stack == null:
		set_held(player_inventory.new_item_stack(id, amount))
		return true

	if held_stack.id != id:
		return false

	held_stack.amount += amount
	held_changed.emit(held_stack) # amount changed, same object
	return true
