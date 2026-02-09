extends Panel

@onready var icon: TextureRect = $Icon
@onready var count: Label = $Count

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

	count.text = str(amount) if amount > 1 else ""

func set_selected(on: bool) -> void:
	modulate = Color(1.0, 1.0, 1.0) if on else Color(0.6, 0.6, 0.6)
