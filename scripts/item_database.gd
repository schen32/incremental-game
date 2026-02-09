extends Node2D

@export var items_folder := "res://resources/items/"
@export var items: Array[ItemData] = []

var by_id: Dictionary = {}  # id -> ItemData

func _ready():
	by_id.clear()
	var dir := DirAccess.open(items_folder)
	if dir:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			if file.ends_with(".tres"):
				var res := load(items_folder + file)
				if res is ItemData:
					by_id[res.id] = res
			file = dir.get_next()
		dir.list_dir_end()

func get_item(id: StringName) -> ItemData:
	return by_id.get(id, null)
