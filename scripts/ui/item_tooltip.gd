extends Panel

@onready var item_name: Label = $ItemName
@onready var description: Label = $Description

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	
func _process(_delta: float) -> void:
	if visible:
		global_position = get_global_mouse_position() + Vector2(8, 8)

func show_tooltip(_index: int, item_id: StringName) -> void:
	visible = true
	
	var item_data: ItemData = ItemDatabase.get_item(item_id)
	item_name.text = item_data.display_name
	
func hide_tooltip(_index: int, _item_id: StringName) -> void:
	visible = false
