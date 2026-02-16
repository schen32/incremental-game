extends Panel

signal hovered(index: int)
signal unhovered(index: int)
signal clicked(index: int, button: int)
var index: int = -1

@export var style_box: StyleBoxFlat
@onready var icon: TextureRect = $Icon
@onready var count: Label = $Icon/Count

func _ready() -> void:
	add_theme_stylebox_override(&"panel", style_box)
	mouse_entered.connect(func(): hovered.emit(index))
	mouse_exited.connect(func(): unhovered.emit(index))

func set_slot(item_id: StringName, amount: int) -> void:
	if item_id == &"" or amount <= 0:
		icon.visible = false
		count.text = ""
		return
	icon.visible = true
	
	var item_data: ItemData = ItemDatabase.get_item(item_id)

	var atlas := AtlasTexture.new()
	atlas.atlas = item_data.texture
	atlas.region = item_data.get_region()
	icon.texture = atlas

	count.text = str(amount) if amount > 0 else ""

func set_highlight(on: bool) -> void:
	modulate = Color(1.0, 1.0, 1.0) if on else Color(0.6, 0.6, 0.6)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		clicked.emit(index, event.button_index)
