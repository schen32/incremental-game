extends Node2D

signal held_changed(held)
var held_stack = null
var prev_held = null

@onready var player_inventory: Node2D = $"../../Player/Inventory"

func _process(_delta: float) -> void:
	if held_stack != prev_held:
		held_changed.emit(held_stack)
		prev_held = held_stack

func _on_slot_clicked(index: int, button: int) -> void:
	match button:
		MOUSE_BUTTON_LEFT:
			_left_click_slot(index)
		MOUSE_BUTTON_RIGHT:
			_right_click_slot(index)

func _left_click_slot(index: int) -> void:
	var slot_stack = player_inventory.slots[index]  # ItemStack or null

	# Case A: not holding anything -> pick up
	if held_stack == null:
		if slot_stack == null:
			return
		held_stack = slot_stack
		player_inventory.slots[index] = null
		player_inventory.changed.emit()
		return

	# Case B: holding something -> drop
	if slot_stack == null:
		player_inventory.slots[index] = held_stack
		held_stack = null
		player_inventory.changed.emit()
		return
	
	# If same item: merge
	if slot_stack.id == held_stack.id:
		slot_stack.amount += held_stack.amount
		held_stack = null
		player_inventory.changed.emit()
		return

	# Case C: slot occupied -> swap
	player_inventory.slots[index] = held_stack
	held_stack = slot_stack
	player_inventory.changed.emit()

func _right_click_slot(index: int) -> void:
	var slot_stack = player_inventory.slots[index]

	# If holding nothing: split the stack
	if held_stack == null:
		if slot_stack == null or slot_stack.amount <= 1:
			return
		var half := int(ceil(slot_stack.amount / 2.0))
		held_stack = player_inventory.new_item_stack(slot_stack.id, half)
		slot_stack.amount -= half
		if slot_stack.amount <= 0:
			player_inventory.slots[index] = null
		player_inventory.changed.emit()
		return

	# If holding something: place ONE
	if slot_stack == null:
		player_inventory.slots[index] = player_inventory.new_item_stack(held_stack.id, 1)
		held_stack.amount -= 1
		if held_stack.amount <= 0:
			held_stack = null
		player_inventory.changed.emit()
		return

	# If same item: add ONE to slot
	if slot_stack.id == held_stack.id:
		slot_stack.amount += 1
		held_stack.amount -= 1
		if held_stack.amount <= 0:
			held_stack = null
		player_inventory.changed.emit()
