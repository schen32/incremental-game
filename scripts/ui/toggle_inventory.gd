extends Node2D

@onready var hotbar: Control = $"../../GameUI/HotbarUI"
@onready var inventory: Control = $"../../GameUI/Inventory"

var inventory_shown := false

func _ready() -> void:
	hotbar.visible = true
	inventory.visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_inventory"):
		inventory_shown = not inventory_shown
		hotbar.visible = not inventory_shown
		inventory.visible = inventory_shown
