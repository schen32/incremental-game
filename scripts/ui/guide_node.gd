extends Panel

signal clicked(node_data: GuideNodeData)

@export var node_data: GuideNodeData

@onready var icon: TextureRect = $Icon
@onready var info_panel: Panel = $"../../Info"

func _ready() -> void:
	var atlas := AtlasTexture.new()
	atlas.atlas = node_data.texture
	atlas.region = node_data.get_region()
	icon.texture = atlas

	mouse_filter = Control.MOUSE_FILTER_STOP
	clicked.connect(info_panel._on_node_clicked)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		clicked.emit(node_data)
