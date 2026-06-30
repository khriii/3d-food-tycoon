class_name Food
extends Node3D

@export var ingredients: Array = []

func add_ingredient(ingr: String) -> void:
	ingredients.append(ingr)
	
	var o: Node3D = find_child("*_" + ingr)
	if o:
		o.visible = true

func show_ingredients() -> void:
	for i in ingredients:
		print(i)
