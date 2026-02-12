extends Control

@export var slot_scene: PackedScene
@export var hotbar_size := 10

@onready var hotbar_grid: GridContainer = $HotbarGrid
@onready var item_name: Label = $ItemName
@onready var player_inventory: Node = $"../../Player/Inventory"

var expanded := false

func _ready() -> void:
	player_inventory.changed.connect(_refresh)
	_refresh()

func _refresh() -> void:
	_clear_children(hotbar_grid)

	# --- hotbar row (always shown) ---
	for i in range(hotbar_size):
		var ui_slot = slot_scene.instantiate()
		hotbar_grid.add_child(ui_slot)

		if player_inventory.slots[i] != null:
			var stack = player_inventory.slots[i]
			ui_slot.set_slot(stack.id, stack.amount)
		else:
			ui_slot.set_slot(&"", 0)

		ui_slot.set_selected(i == player_inventory.selected_hotbar_index)
	
	var selected_item = player_inventory.get_selected_item()
	item_name.text = &""
	if selected_item != null:
		item_name.text = ItemDatabase.get_item(selected_item.id).display_name

func _clear_children(node: Node) -> void:
	for c in node.get_children():
		c.queue_free()
