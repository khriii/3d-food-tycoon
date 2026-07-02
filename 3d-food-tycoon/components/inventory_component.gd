class_name InventoryComponent
extends Node

var inventory: Array = []
var count: int = 0
@export var size: int = 1

# Where items should be spawned
@export var hand: Marker3D
var current_hand_node: Node3D = null


func add_to_inventory(ingredient: Ingredient) -> int:
	if count >= size: 
		printerr("cannot add to inventory. out of bounds. current_items_in_inventory: " + str(count) + " of " + str(size))
		return -1
	inventory.append(ingredient)
	count += 1
	return count - 1


func remove_from_inventory(item_id: String) -> bool:
	var index = inventory.find_custom(func(item): return item.id == item_id)
	
	# if is find the index will be >= 0
	if index != -1:
		inventory.remove_at(index)
		count -= 1
		return true
	printerr("cannot remove " + item_id + ": not found")
	return false


func set_size(new_size) -> bool:
	if new_size < count:
		printerr("cannot change inventory size: items do not fit. remove them first. item_count: " + str(count))
		return false
	size = new_size
	return true


func reset() -> void:
	inventory.clear()


func get_size() -> int:
	return size;


func set_item_in_hand(index: int) -> bool:
	if index < 0 or index >= inventory.size():
		printerr("index not available")
		return false

	var item = inventory[index]

	if item.visual_scene_path == "":
		printerr("visual_scene_path missing")
		return false

	if is_instance_valid(current_hand_node):
		current_hand_node.queue_free()

	var scene_resource = load(item.visual_scene_path)
	current_hand_node = scene_resource.instantiate()

	hand.add_child(current_hand_node)
	
	if current_hand_node is RigidBody3D:
		current_hand_node.freeze = true
		current_hand_node.collision_layer = 0
		current_hand_node.collision_mask = 0
		
	var int_areas = current_hand_node.find_children("*", "InteractionAreaComponent", true, false)
	for area in int_areas:
		area.queue_free()
		
	var meshes = current_hand_node.find_children("*", "MeshInstance3D", true, false)
	for mesh in meshes:
		mesh.material_overlay = null

	current_hand_node.position = Vector3.ZERO
	current_hand_node.rotation = Vector3.ZERO

	return true
