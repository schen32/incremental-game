extends Node2D
signal changed

@export var selected_item: StringName = &"grass"  # later: hotbar index

@export var hotbar_size := 10
var selected_hotbar_index := 0

class ItemData:
	var amount: int
	var atlas_coords: Vector2i
	func _init(amount := 0, atlas_coords := Vector2i.ZERO) -> void:
		self.amount = amount
		self.atlas_coords = atlas_coords

# item_id -> ItemData
var items: Dictionary = {}

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("hotbar_next"):
		set_selected_index(selected_hotbar_index + 1)
	elif Input.is_action_just_pressed("hotbar_prev"):
		set_selected_index(selected_hotbar_index - 1)

func set_selected_index(i: int) -> void:
	selected_hotbar_index = wrapi(i, 0, hotbar_size)
	changed.emit()

func add_item(id: StringName, atlas_coords: Vector2i = Vector2i.ZERO, amount: int = 1) -> void:
	var data: ItemData = items.get(id, null)
	if data == null:
		data = ItemData.new(0, atlas_coords)
		items[id] = data
	data.amount += amount
	# optionally update coords if you want latest to win:
	data.atlas_coords = atlas_coords
	changed.emit()

func remove_item(id: StringName, amount: int = 1) -> bool:
	var data: ItemData = items.get(id, null)
	if data == null or data.amount < amount:
		return false
	data.amount -= amount
	if data.amount <= 0:
		items.erase(id)
	changed.emit()
	return true

func get_amount(id: StringName) -> int:
	var data: ItemData = items.get(id, null)
	return 0 if data == null else data.amount

func get_atlas_coords(id: StringName) -> Vector2i:
	var data: ItemData = items.get(id, null)
	return Vector2i.ZERO if data == null else data.atlas_coords
