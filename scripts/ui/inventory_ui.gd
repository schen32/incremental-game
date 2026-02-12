extends Control

@export var slot_scene: PackedScene
@export var style_box: StyleBoxFlat
@export var hotbar_size := 10
@export var total_slots := 30  # includes hotbar
var held_stack = null

@onready var hotbar_grid: GridContainer = $HotbarGrid
@onready var inventory_grid: GridContainer = $InventoryGrid
#@onready var item_name: Label = $ItemName
@onready var player_inventory: Node = $"../../../Player/Inventory"

func _ready() -> void:
	player_inventory.changed.connect(_refresh)
	_refresh()

func _refresh() -> void:
	_clear_children(hotbar_grid)
	_clear_children(inventory_grid)

	# --- hotbar row (always shown) ---
	for i in range(hotbar_size):
		var ui_slot = slot_scene.instantiate()
		hotbar_grid.add_child(ui_slot)
		ui_slot.index = i
		ui_slot.clicked.connect(_on_slot_clicked)

		if player_inventory.slots[i] != null:
			var stack = player_inventory.slots[i]
			ui_slot.set_slot(stack.id, stack.amount)
		else:
			ui_slot.set_slot(&"", 0)
		ui_slot.add_theme_stylebox_override(&"panel", style_box)

		ui_slot.set_selected(i == player_inventory.selected_hotbar_index)

	# --- inventory rows ---
	for i in range(hotbar_size, total_slots):
		var ui_slot = slot_scene.instantiate()
		inventory_grid.add_child(ui_slot)
		ui_slot.index = i
		ui_slot.clicked.connect(_on_slot_clicked)

		if player_inventory.slots[i] != null:
			var stack = player_inventory.slots[i]
			ui_slot.set_slot(stack.id, stack.amount)
		else:
			ui_slot.set_slot(&"", 0)
	
	#var selected_item = player_inventory.get_selected_item()
	#item_name.text = &""
	#if selected_item != null:
		#item_name.text = ItemDatabase.get_item(selected_item.id).display_name

func _clear_children(node: Node) -> void:
	for c in node.get_children():
		c.queue_free()

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
