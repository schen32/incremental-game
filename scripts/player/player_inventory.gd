extends Node2D
signal changed

class ItemStack:
	var id: StringName
	var amount: int

	func _init(_id: StringName, _amount: int) -> void:
		id = _id
		amount = _amount

@export var total_slots := 30
@export var hotbar_size := 10
var selected_hotbar_index := 0

# slots[0..total_slots-1] each holds an item id
var slots: Array[ItemStack] = []

func _ready() -> void:
	slots.resize(total_slots)
	for i in range(total_slots):
		slots[i] = null

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("hotbar_next"):
		set_selected_index(selected_hotbar_index + 1)
	elif Input.is_action_just_pressed("hotbar_prev"):
		set_selected_index(selected_hotbar_index - 1)
	
	if Input.is_action_just_pressed("hotbar_1"):
		set_selected_index(0)
	elif Input.is_action_just_pressed("hotbar_2"):
		set_selected_index(1)
	elif Input.is_action_just_pressed("hotbar_3"):
		set_selected_index(2)
	elif Input.is_action_just_pressed("hotbar_4"):
		set_selected_index(3)
	elif Input.is_action_just_pressed("hotbar_5"):
		set_selected_index(4)
	elif Input.is_action_just_pressed("hotbar_6"):
		set_selected_index(5)
	elif Input.is_action_just_pressed("hotbar_7"):
		set_selected_index(6)
	elif Input.is_action_just_pressed("hotbar_8"):
		set_selected_index(7)
	elif Input.is_action_just_pressed("hotbar_9"):
		set_selected_index(8)
	elif Input.is_action_just_pressed("hotbar_0"):
		set_selected_index(9)

func set_selected_index(i: int) -> void:
	selected_hotbar_index = wrapi(i, 0, hotbar_size)
	changed.emit()

func add_item(id: StringName, amount: int = 1) -> void:
	# 1) Try to stack into existing slot
	for s in slots:
		if s != null and s.id == id:
			s.amount += amount
			changed.emit()
			return

	# 2) Put into first empty slot
	for i in range(slots.size()):
		if slots[i] == null:
			slots[i] = ItemStack.new(id, amount)
			changed.emit()
			return

func add_items(items: Dictionary) -> void:
	for key in items.keys():
		add_item(key, items[key])

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

func get_selected_item() -> ItemStack:
	return slots[selected_hotbar_index]
	
func new_item_stack(_id: StringName, _amount: int) -> ItemStack:
	return ItemStack.new(_id, _amount)
	
func count_item(id: StringName) -> int:
	var total := 0
	for s in slots:
		if s != null and s.id == id:
			total += s.amount
	return total

func has_requirements(req: Dictionary) -> bool:
	for id in req.keys():
		if count_item(id) < int(req[id]):
			return false
	return true

func consume_item(id: StringName, amount: int) -> bool:
	var remaining := amount

	for i in range(slots.size()):
		var s = slots[i]
		if s == null or s.id != id:
			continue

		var take = min(s.amount, remaining)
		s.amount -= take
		remaining -= take

		if s.amount <= 0:
			slots[i] = null

		if remaining <= 0:
			return true

	return false  # not enough (shouldn’t happen if checked)

func consume_requirements(req: Dictionary) -> bool:
	# 1) check first so we don’t partially consume
	if not has_requirements(req):
		return false

	# 2) consume
	for id in req.keys():
		consume_item(id, int(req[id]))

	changed.emit()
	return true
