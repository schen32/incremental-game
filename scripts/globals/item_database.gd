extends Node2D

@export var items_folder := "res://resources/items/"

var items: Dictionary = {}  # id -> ItemData

func _ready():
	items.clear()
	var dir := DirAccess.open(items_folder)
	if dir:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			if file.ends_with(".tres"):
				var res := load(items_folder + file)
				if res is ItemData:
					items[res.id] = res
			file = dir.get_next()
		dir.list_dir_end()

func get_item(id: StringName) -> ItemData:
	return items.get(id, null)
