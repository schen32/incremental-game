extends Panel

@export var slot_scene: PackedScene
@export var style_box: StyleBoxFlat

@onready var tooltip: Panel = $"../ItemTooltip"
@onready var require_grid: GridContainer = $RequireGrid
@onready var reward_grid: GridContainer = $RewardGrid
@onready var title: Label = $Title
@onready var description: Label = $Description
@onready var requirement: Label = $Requirement
@onready var reward: Label = $Reward
@onready var button: Button = $Button

@onready var craft_item: Node2D = $"../../GameScripts/CraftItem"
var _current_data: GuideNodeData

func _ready() -> void:
	visible = false
	button.pressed.connect(_on_button_pressed)

func _on_node_clicked(node_data: GuideNodeData) -> void:
	visible = not visible
	_current_data = node_data

	title.text = node_data.title
	description.text = node_data.description
	_refresh(node_data)
	
func _refresh(node_data: GuideNodeData) -> void:
	_clear_children(require_grid)
	_clear_children(reward_grid)

	var i = 0
	for key in node_data.requirements.keys():
		var ui_slot = slot_scene.instantiate()
		require_grid.add_child(ui_slot)
		ui_slot.index = i
		ui_slot.set_slot(key, node_data.requirements[key])
		ui_slot.add_theme_stylebox_override(&"panel", style_box)
		
		ui_slot.hovered.connect(tooltip.show_tooltip)
		ui_slot.unhovered.connect(tooltip.hide_tooltip)
		i += 1
	
	for key in node_data.rewards.keys():
		var ui_slot = slot_scene.instantiate()
		reward_grid.add_child(ui_slot)
		ui_slot.index = i
		ui_slot.set_slot(key, node_data.rewards[key])
		ui_slot.add_theme_stylebox_override(&"panel", style_box)
		
		ui_slot.hovered.connect(tooltip.show_tooltip)
		ui_slot.unhovered.connect(tooltip.hide_tooltip)
		i += 1

func _clear_children(node: Node) -> void:
	for c in node.get_children():
		c.queue_free()
		
func _on_button_pressed() -> void:
	if _current_data == null:
		return
		
	craft_item.convert(_current_data.requirements, _current_data.rewards)
