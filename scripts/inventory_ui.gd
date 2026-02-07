extends Control

@export var slot_scene: PackedScene
@export var hotbar_size := 10
@export var total_slots := 30  # includes hotbar

@onready var hotbar_grid: GridContainer = $HotbarPanel/GridContainer
@onready var inventory_panel: Panel = $InventoryPanel
@onready var inventory_grid: GridContainer = $InventoryPanel/GridContainer
@onready var player_inventory: Node = $"../../Player/Inventory"

var expanded := false

func _ready() -> void:
	inventory_panel.visible = false
	player_inventory.changed.connect(_refresh)
	_refresh()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_inventory"):
		expanded = not expanded
		inventory_panel.visible = expanded
		_refresh()

func _refresh() -> void:
	_clear_children(hotbar_grid)
	_clear_children(inventory_grid)

	# Ensure we don't index past what the inventory actually has
	var slot_count = min(total_slots, player_inventory.slots.size())

	# --- hotbar row (always shown) ---
	for i in range(hotbar_size):
		var ui_slot = slot_scene.instantiate()
		hotbar_grid.add_child(ui_slot)

		if i < slot_count and player_inventory.slots[i] != null:
			var stack = player_inventory.slots[i]
			ui_slot.set_slot(stack.atlas_coords, stack.amount)
		else:
			ui_slot.set_slot(Vector2i(-1, -1), 0)

		ui_slot.set_selected(i == player_inventory.selected_hotbar_index)

	# --- inventory rows (only when expanded) ---
	if expanded:
		for i in range(hotbar_size, total_slots):
			var ui_slot = slot_scene.instantiate()
			inventory_grid.add_child(ui_slot)

			if i < slot_count and player_inventory.slots[i] != null:
				var stack = player_inventory.slots[i]
				ui_slot.set_slot(stack.atlas_coords, stack.amount)
			else:
				ui_slot.set_slot(Vector2i(-1, -1), 0)

func _clear_children(node: Node) -> void:
	for c in node.get_children():
		c.queue_free()
