extends Node2D

@export var break_time := 0.05
@export var pickup_item: PackedScene

@onready var highlight_controller: Node2D = $"../HighlightTile"
@onready var highlight: Node2D = $"../HighlightTile/Highlight"
@onready var break_sound: AudioStreamPlayer2D = $BreakSound
@onready var world: Node2D = $"../../GameNodes/WorldBlocks"

var breaking := false
var break_progress := 0.0
var breaking_cell: Vector2i = Vector2i(999999, 999999)
var shrink_tween: Tween

func try_break(delta: float) -> void:
	var tilemap = world.tilemap
	var cell: Vector2i = highlight_controller.current_hover_cell

	# your sentinel check
	if cell.x > 100000:
		cancel_break()
		return

	# must be a block
	if tilemap.get_cell_source_id(cell) == -1:
		cancel_break()
		return

	# If player moved hover to a different tile, reset progress
	if not breaking or cell != breaking_cell:
		breaking = true
		breaking_cell = cell
		break_progress = 0.0
		set_break_animation(0.0)

	break_progress += delta
	set_break_animation(break_progress / break_time)

	if break_progress < break_time:
		return

	# --- break happens ---
	var tile_data = tilemap.get_cell_tile_data(breaking_cell)
	if tile_data == null:
		cancel_break()
		return

	var item_id: StringName = tile_data.get_custom_data("item")

	world.erase_block(breaking_cell)
	spawn_item(breaking_cell, item_id)

	SoundManager.play_player(break_sound, world.cell_to_world(breaking_cell))
	cancel_break()

func cancel_break() -> void:
	breaking = false
	break_progress = 0.0
	breaking_cell = Vector2i(999999, 999999)
	set_break_animation(0.0)

func spawn_item(cell: Vector2i, item_id: StringName) -> void:
	if pickup_item == null:
		return

	var p := pickup_item.instantiate()
	get_tree().current_scene.add_child(p)

	# spawn at the broken block's world position
	p.global_position = world.cell_to_world(cell)

	p.set_item(item_id)
	p.pop()

func set_break_animation(r: float) -> void:
	var break_ratio = clamp(r, 0.0, 1.0)

	# scale from 1.0 -> 0.2
	var target_scale = Vector2.ONE * lerp(1.0, 0.2, break_ratio)

	if shrink_tween:
		shrink_tween.kill()

	shrink_tween = create_tween()
	shrink_tween.tween_property(highlight, "scale", target_scale, 0.05)
