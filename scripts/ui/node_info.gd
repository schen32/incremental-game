extends Panel

func _ready() -> void:
	visible = false

func _on_node_clicked(node_data: GuideNodeData) -> void:
	visible = not visible
