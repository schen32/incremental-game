extends Node2D

@onready var place_tile: Node2D = $"../PlaceTile"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("use_secondary"):
		place_tile.try_place()
