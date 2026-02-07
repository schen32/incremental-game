extends Control

@export var slot_scene: PackedScene
@export var max_slots := 30

@onready var grid: GridContainer = $Panel/GridContainer
@onready var player_inventory: Node2D = $"../../Player/Inventory"

func _ready() -> void:
	player_inventory.changed.connect(_refresh)
	_refresh()

func _refresh() -> void:
	# clear old slots
	for child in grid.get_children():
		child.queue_free()

	var keys = player_inventory.items.keys()
	var i := 0
	# 1) filled slots
	for id in keys:
		if i >= max_slots:
			break

		var item_amount = player_inventory.get_amount(id)
		var item_atlas_coords = player_inventory.get_atlas_coords(id)

		var slot = slot_scene.instantiate()
		grid.add_child(slot)

		slot.set_slot(item_atlas_coords, item_amount)
		i += 1

	# 2) empty slots
	while i < max_slots:
		var slot = slot_scene.instantiate()
		grid.add_child(slot)

		# Use a "no item" marker. Your Slot script should treat amount==0 as empty.
		slot.set_slot(Vector2i(-1, -1), 0)
		i += 1
