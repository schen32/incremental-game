extends Panel

@onready var title: Label = $Title
@onready var description: Label = $Description

func _ready() -> void:
	visible = false

func _on_node_clicked(node_data: GuideNodeData) -> void:
	visible = not visible

	title.text = node_data.title
	description.text = node_data.description
