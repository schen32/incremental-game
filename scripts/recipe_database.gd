extends Node2D

@export var recipe_folder := "res://resources/recipes/"

var recipes: Dictionary = {}

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
					recipes[res.output_id] = res
			file = dir.get_next()
		dir.list_dir_end()

func get_recipe(id: StringName) -> RecipeData:
	return recipes.get(id, null)
