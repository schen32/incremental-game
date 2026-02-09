extends Node2D

@onready var destroy_tile: Node2D = $"../DestroyTile"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("use_primary"):
		var holding := Input.is_action_pressed("use_primary")

		if holding:
			destroy_tile.try_break(delta)
		else:
			destroy_tile.cancel_break()
