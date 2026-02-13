extends Control

@export var style_box: StyleBoxFlat

@onready var held_slot: Panel = $HeldSlot
@onready var inventory_move_items: Node2D = $"../../../GameScripts/InventoryMoveItems"

func _ready() -> void:
	_set_mouse_ignore_recursive(held_slot)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	held_slot.add_theme_stylebox_override(&"panel", style_box)
	held_slot.visible = false
	
	inventory_move_items.held_changed.connect(_update_held_ui)

func _set_mouse_ignore_recursive(n: Node) -> void:
	if n is Control:
		(n as Control).mouse_filter = Control.MOUSE_FILTER_IGNORE
	for c in n.get_children():
		_set_mouse_ignore_recursive(c)

func _process(_delta: float) -> void:
	if held_slot.visible:
		held_slot.global_position = get_viewport().get_mouse_position() - Vector2(12, 12)

func _update_held_ui(held_stack) -> void:
	if held_stack == null:
		held_slot.visible = false
		return

	held_slot.visible = true
	held_slot.set_slot(held_stack.id, held_stack.amount)
