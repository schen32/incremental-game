extends Node2D

var recipes: Array[RecipeData]

func _ready() -> void:
	for recipe in RecipeDatabase.recipes.values():
		recipes.append(recipe)
