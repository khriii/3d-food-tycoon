extends Node

var level_container: Node
var player: CharacterBody3D
var current_level: Node

func register_main_scene(p_container: Node, p_player: Node3D):
	level_container = p_container
	player = p_player
	
	if level_container.get_child_count() > 0:
		current_level = level_container.get_child(0)

func load_level(level_path: String):
	print("sigma")
	
	if level_container == null:
		printerr("Errore: LevelContainer non è stato registrato nel GameManager!")
		return
		
	if current_level != null:
		current_level.queue_free()
	
	var next_level_resource = load(level_path)
	
	if next_level_resource:
		current_level = next_level_resource.instantiate()
		level_container.add_child(current_level)
