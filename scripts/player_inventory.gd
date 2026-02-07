extends Node2D

signal changed

# item_id -> amount
var items: Dictionary = {}

func add_item(id: StringName, amount: int = 1) -> void:
	items[id] = int(items.get(id, 0)) + amount
	changed.emit()

func remove_item(id: StringName, amount: int = 1) -> bool:
	var have := int(items.get(id, 0))
	if have < amount:
		return false
	have -= amount
	if have <= 0:
		items.erase(id)
	else:
		items[id] = have
	changed.emit()
	return true

func get_amount(id: StringName) -> int:
	return int(items.get(id, 0))
