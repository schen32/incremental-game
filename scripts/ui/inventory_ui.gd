extends Control

@export var slot_scene: PackedScene
@export var style_box: StyleBoxFlat
@export var hotbar_size := 10
@export var total_slots := 30  # includes hotbar

@onready var hotbar_grid: GridContainer = $HotbarGrid
@onready var inventory_grid: GridContainer = $InventoryGrid
#@onready var item_name: Label = $ItemName
@onready var player_inventory: Node2D = $"../../../Player/Inventory"
@onready var inventory_move_items: Node2D = $"../../../GameScripts/InventoryMoveItems"

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
		ui_slot.clicked.connect(inventory_move_items._on_slot_clicked)

		if player_inventory.slots[i] != null:
			var stack = player_inventory.slots[i]
			ui_slot.set_slot(stack.id, stack.amount)
		else:
			ui_slot.set_slot(&"", 0)
		ui_slot.add_theme_stylebox_override(&"panel", style_box)

		ui_slot.set_highlight(i == player_inventory.selected_hotbar_index)

	# --- inventory rows ---
	for i in range(hotbar_size, total_slots):
		var ui_slot = slot_scene.instantiate()
		inventory_grid.add_child(ui_slot)
		ui_slot.index = i
		ui_slot.clicked.connect(inventory_move_items._on_slot_clicked)

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
