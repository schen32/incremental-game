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

	var keys = player_inventory.items.keys()
	var slots := []

	# flatten inventory into a list like [ [atlas, amt], [atlas, amt], ... ]
	for id in keys:
		var amt = player_inventory.get_amount(id)
		var atlas = player_inventory.get_atlas_coords(id)
		slots.append([atlas, amt])

	# fill up to total_slots
	while slots.size() < total_slots:
		slots.append([Vector2i(-1, -1), 0])

	# hotbar row (always shown)
	for i in range(hotbar_size):
		var s = slot_scene.instantiate()
		hotbar_grid.add_child(s)
		s.set_slot(slots[i][0], slots[i][1])
		s.set_selected(i == player_inventory.selected_hotbar_index)

	# extra rows (only when expanded)
	if expanded:
		for i in range(hotbar_size, total_slots):
			var s = slot_scene.instantiate()
			inventory_grid.add_child(s)
			s.set_slot(slots[i][0], slots[i][1])

func _clear_children(node: Node) -> void:
	for c in node.get_children():
		c.queue_free()
