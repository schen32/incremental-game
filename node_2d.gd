extends Node2D

const speed = 250

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var horizontal_input_dir = Input.get_axis("move_left", "move_right")
	var vertical_input_dir = Input.get_axis("move_up", "move_down")
	
	position.x += horizontal_input_dir * speed * delta
	position.y += vertical_input_dir * speed * delta
	
	
