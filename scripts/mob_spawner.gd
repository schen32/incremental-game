extends Node2D

# tile_id (from TileSet custom data "item") -> PackedScene
@export var spawn_table: Dictionary = {}   # e.g. { &"grass": preload("res://mobs/slime.tscn"), &"stone": preload("res://mobs/golem.tscn") }

@export var spawn_interval := 5.0          # seconds between spawn checks
@export var spawn_chance := 0.05            # chance PER CELL per interval
@export var max_mobs := 100                 # global cap (still applies)

# per-block caps
@export var default_max_per_block := 20     # if a block id isn't in max_per_block
@export var max_per_block: Dictionary = {} # e.g. { &"grass": 10, &"stone": 3, &"sand": 6 }

@onready var spawn_sound: AudioStreamPlayer2D = $SpawnSound
@onready var world: Node2D = $"../WorldBlocks" # expects world.tilemap: TileMapLayer and helpers

var spawn_cells: Array[Vector2i] = []
var spawn_set := {} # Dictionary used as a set: cell -> true
var _acc := 0.0

# tracks alive mob counts per block id (tile custom data "item")
var alive_by_block: Dictionary = {} # tile_id -> int

func _ready() -> void:
	world.block_changed.connect(_on_block_changed)
	_rebuild_spawn_cells()

func _process(delta: float) -> void:
	_acc += delta
	if _acc < spawn_interval:
		return
	_acc = 0.0

	var existing := get_tree().get_nodes_in_group("mobs").size()
	if existing >= max_mobs:
		return
	if spawn_cells.is_empty():
		return

	spawn_cells.shuffle()

	for cell in spawn_cells:
		if existing >= max_mobs:
			break
		if randf() > spawn_chance:
			continue

		var tile_id := _get_block_id_for_air_cell(cell)
		if tile_id == &"":
			continue

		# enforce per-block cap
		var cap := int(max_per_block.get(tile_id, default_max_per_block))
		var current := int(alive_by_block.get(tile_id, 0))
		if current >= cap:
			continue

		var scene: PackedScene = spawn_table.get(tile_id, null)
		if scene == null:
			continue

		var mob := _spawn_cell_with(scene, cell)
		existing += 1

		# increment + decrement on despawn
		alive_by_block[tile_id] = current + 1
		mob.tree_exited.connect(func():
			alive_by_block[tile_id] = max(0, int(alive_by_block.get(tile_id, 0)) - 1)
		)

		if spawn_sound:
			SoundManager.play_player(spawn_sound, world.cell_to_world(cell))

func _get_block_id_for_air_cell(air_cell: Vector2i) -> StringName:
	var ground := air_cell + Vector2i(0, 1)
	var tile_data = world.tilemap.get_cell_tile_data(ground)
	if tile_data == null:
		return &""
	if not tile_data.has_custom_data("item"):
		return &""
	return tile_data.get_custom_data("item")

func _spawn_cell_with(scene: PackedScene, air_cell: Vector2i) -> Node:
	var mob := scene.instantiate()
	get_tree().current_scene.add_child(mob)
	mob.global_position = world.cell_to_world(air_cell)
	mob.add_to_group("mobs")
	return mob

func _on_block_changed(cell: Vector2i) -> void:
	_update_cell_as_ground(cell)
	_update_cell_as_ground(cell + Vector2i(0, 1))

func _update_cell_as_ground(ground: Vector2i) -> void:
	var air := ground + Vector2i(0, -1)

	var is_ground = world.is_solid(ground)
	var is_air = world.is_air(air)
	var can_spawn = is_ground and is_air

	if can_spawn:
		_add_spawn_cell(air)
	else:
		_remove_spawn_cell(air)

func _add_spawn_cell(cell: Vector2i) -> void:
	if spawn_set.has(cell):
		return
	spawn_set[cell] = true
	spawn_cells.append(cell)

func _remove_spawn_cell(cell: Vector2i) -> void:
	if not spawn_set.has(cell):
		return
	spawn_set.erase(cell)
	var idx := spawn_cells.find(cell)
	if idx != -1:
		spawn_cells.remove_at(idx)

func _rebuild_spawn_cells() -> void:
	spawn_cells.clear()
	spawn_set.clear()
	for ground in world.get_used_cells():
		_update_cell_as_ground(ground)
