extends Node2D

signal block_changed(cell: Vector2i)

@export var tilemap: TileMapLayer

func is_solid(cell: Vector2i) -> bool:
	return tilemap.get_cell_source_id(cell) != -1

func is_air(cell: Vector2i) -> bool:
	return tilemap.get_cell_source_id(cell) == -1

func get_used_cells() -> Array[Vector2i]:
	return tilemap.get_used_cells()

func cell_to_world(cell: Vector2i) -> Vector2:
	# cell center in world space
	return tilemap.to_global(tilemap.map_to_local(cell))

# Use these wrappers whenever you place/break tiles so spawners update
func set_block(cell: Vector2i, source_id: int, atlas_coords: Vector2i = Vector2i.ZERO) -> void:
	tilemap.set_cell(cell, source_id, atlas_coords)
	block_changed.emit(cell)

func erase_block(cell: Vector2i) -> void:
	tilemap.erase_cell(cell)
	block_changed.emit(cell)
