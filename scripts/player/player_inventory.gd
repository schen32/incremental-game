extends Node2D
signal changed

class ItemData:
	var index: int
	var id: StringName
	var amount: int
	var atlas_coords: Vector2i
	func _init(index := 0, id: StringName = &"", amount := 0, atlas_coords := Vector2i.ZERO) -> void:
		self.index = index
		self.id = id
		self.amount = amount
		self.atlas_coords = atlas_coords

@export var total_slots := 30
@export var hotbar_size := 10
var selected_hotbar_index := 0

# slots[0..total_slots-1] each holds an ItemStack or null
var slots: Array[ItemData] = []

func _ready() -> void:
	slots.resize(total_slots)
	for i in range(total_slots):
		slots[i] = null

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("hotbar_next"):
		set_selected_index(selected_hotbar_index + 1)
	elif Input.is_action_just_pressed("hotbar_prev"):
		set_selected_index(selected_hotbar_index - 1)

func set_selected_index(i: int) -> void:
	selected_hotbar_index = wrapi(i, 0, hotbar_size)
	changed.emit()

func add_item(id: StringName, atlas_coords: Vector2i, amount: int = 1) -> void:
	# 1) Try to stack into existing slot
	for s in slots:
		if s != null and s.id == id:
			s.amount += amount
			changed.emit()
			return

	# 2) Put into first empty slot
	for i in range(slots.size()):
		if slots[i] == null:
			slots[i] = ItemData.new(i, id, amount, atlas_coords)
			changed.emit()
			return

func remove_item_from_slot(slot_index: int, amount: int = 1) -> bool:
	if slot_index < 0 or slot_index >= slots.size():
		return false

	var s := slots[slot_index]
	if s == null or s.amount < amount:
		return false

	s.amount -= amount
	if s.amount <= 0:
		slots[slot_index] = null

	changed.emit()
	return true

func get_selected_data() -> ItemData:
	return slots[selected_hotbar_index]
