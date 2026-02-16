extends CanvasLayer

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_guide"):
		toggle()

func toggle() -> void:
	visible = not visible
	get_tree().paused = visible
