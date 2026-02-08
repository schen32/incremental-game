extends Node

signal changed(current: int, max: int)
signal died

@export var max_health: int = 100
var current_health: int

func _ready() -> void:
	current_health = max_health
	changed.emit(current_health, max_health)

func damage(amount: int) -> void:
	if amount <= 0 or current_health <= 0:
		return
	current_health = max(current_health - amount, 0)
	changed.emit(current_health, max_health)
	if current_health == 0:
		died.emit()

func heal(amount: int) -> void:
	if amount <= 0 or current_health <= 0:
		return
	current_health = min(current_health + amount, max_health)
	changed.emit(current_health, max_health)

func set_max_health(new_max: int, refill: bool = true) -> void:
	max_health = max(new_max, 1)
	if refill:
		current_health = max_health
	else:
		current_health = min(current_health, max_health)
	changed.emit(current_health, max_health)
