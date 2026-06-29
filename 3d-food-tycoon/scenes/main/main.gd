extends Node3D

@export var level_container: Node

func _ready() -> void:
	if level_container:
		GameManager.level_container = level_container
		var pizzeria : String = "res://scenes/restaurants/pizzeria/pizzeria.tscn"
	
		GameManager.load_level(pizzeria)
