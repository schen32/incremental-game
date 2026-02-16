extends CanvasLayer

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta) -> void:
	if Input.is_action_just_pressed("toggle_guide"):
		toggle()

func toggle() -> void:
	visible = not visible
	get_tree().paused = visible
