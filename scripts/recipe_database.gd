extends Node2D

@export var recipe_folder := "res://resources/recipes/"

var recipes: Array[StringName]

func _ready():
	recipes.clear()
	var dir := DirAccess.open(recipe_folder)
	if dir:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			if file.ends_with(".tres"):
				var res := load(recipe_folder + file)
				if res is RecipeData:
					recipes.append(res.output_id)
			file = dir.get_next()
		dir.list_dir_end()
