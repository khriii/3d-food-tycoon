extends Node
class_name EquipmentComponent

var current_equipped_item_node: Node3D = null
var current_equipped_item_data: ItemData = null
@export var hand: Marker3D
@export var drop: Marker3D


func equip_item(item_data: ItemData):
	if current_equipped_item_node != null:
		current_equipped_item_node.queue_free()
		current_equipped_item_data = null
		current_equipped_item_node = null
	
	# Without item in hand
	if item_data == null or item_data.world_scene_path == null:
		return
	
	var new_item_visual: Node3D = item_data.equip_scene.instantiate()
	
	hand.add_child(new_item_visual)
	
	new_item_visual.position = Vector3.ZERO
	new_item_visual.rotation = Vector3.ZERO
	
	current_equipped_item_node = new_item_visual
	current_equipped_item_data = item_data


func drop_item():
	if drop != null:
		if current_equipped_item_node != null:
			var loaded_scene: PackedScene = load(current_equipped_item_data.world_scene_path)
			
			if loaded_scene == null:
				return
			
			var new_item: Node3D = loaded_scene.instantiate()
			
			get_tree().current_scene.add_child(new_item)
			new_item.global_position = drop.global_position
			hand.get_child(0).queue_free()
