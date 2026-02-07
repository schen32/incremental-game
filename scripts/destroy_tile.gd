extends Node2D

@export var break_time := 0.5
@export var pickup_item: PackedScene

@onready var highlight_controller: Node2D = $"../HighlightTile"
@onready var ground: TileMapLayer = $"../../Tiles/Ground"
@onready var highlight: Node2D = $"../../Tiles/Highlight"
@onready var break_sound: AudioStreamPlayer2D = $BreakSound

var breaking := false
var break_progress := 0.0
var breaking_cell: Vector2i = Vector2i(999999, 999999)
var shrink_tween: Tween

func _process(delta: float) -> void:
	var holding := Input.is_action_pressed("destroy_tile")

	if holding:
		_try_break(delta)
	else:
		_cancel_break()

func _try_break(delta: float) -> void:
	var cell = highlight_controller.current_hover_cell
	if cell.x > 100000 or ground.get_cell_source_id(cell) == -1:
		_cancel_break()
		return

	# If player moved hover to a different tile, reset progress
	if not breaking or cell != breaking_cell:
		breaking = true
		breaking_cell = cell
		break_progress = 0.0
		set_break_animation(0.0)

	break_progress += delta
	set_break_animation(break_progress / break_time)
	
	if break_progress >= break_time:
		var tile_data := ground.get_cell_tile_data(cell)
		if tile_data == null:
			return
			
		var item: StringName = tile_data.get_custom_data("item")
		var atlas_coords: Vector2i = ground.get_cell_atlas_coords(cell)
		
		ground.erase_cell(breaking_cell)
		spawn_item(breaking_cell, item, atlas_coords)
		
		play_break_sound()
		_cancel_break()

func _cancel_break() -> void:
	breaking = false
	break_progress = 0.0
	breaking_cell = Vector2i(999999, 999999)
	set_break_animation(break_progress / break_time)
	
func spawn_item(cell: Vector2i, item: StringName, atlas_coords: Vector2i) -> void:
	var p := pickup_item.instantiate()
	get_tree().current_scene.add_child(p)
	p.global_position = ground.to_global(ground.map_to_local(cell))
	
	p.item = item
	p.atlas_coords = atlas_coords
	p.apply_appearance()
	p.pop()
	
func set_break_animation(r: float) -> void:
	var break_ratio = clamp(r, 0.0, 1.0)

	# scale from 1.0 -> 0.2
	var target_scale = Vector2.ONE * lerp(1.0, 0.2, break_ratio)

	if shrink_tween:
		shrink_tween.kill()

	shrink_tween = create_tween()
	shrink_tween.tween_property(highlight, "scale", target_scale, 0.05)
	
func play_break_sound() -> void:
	break_sound.pitch_scale = randf_range(0.8, 1.2)
	break_sound.volume_db = -6 + randf_range(-2.0, 2.0)
	break_sound.global_position = ground.to_global(ground.map_to_local(breaking_cell))
	break_sound.play()
