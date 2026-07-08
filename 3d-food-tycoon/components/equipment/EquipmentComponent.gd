extends Node
class_name EquipmentComponent

var current_equipped_item_node: Node3D = null
@export var hand: Marker3D


func equip_item(item_data: ItemData):
	if current_equipped_item_node != null:
		current_equipped_item_node.queue_free()
		current_equipped_item_node = null
	
	# Without item in hand
	if item_data == null or item_data.world_scene_path == null:
		return
	
	var new_item_visual: Node3D = item_data.equip_scene.instantiate()
	
	hand.add_child(new_item_visual)
	
	new_item_visual.position = Vector3.ZERO
	new_item_visual.rotation = Vector3.ZERO
	
	current_equipped_item_node = new_item_visual
