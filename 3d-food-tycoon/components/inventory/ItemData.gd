extends Resource
class_name ItemData

@export var id: String = ""
@export var name: String = ""
@export var description: String = ""
@export var icon: Texture2D
@export_file("*.tscn") var world_scene_path: String
@export var equip_scene: PackedScene
@export var stackable: bool = false
@export var max_stack: int = 100
