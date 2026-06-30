extends Node3D

@export var food: Food

func _ready() -> void:
	await get_tree().create_timer(3.0).timeout
	food.add_ingredient("wurstel")
	
	food.show_ingredients()
