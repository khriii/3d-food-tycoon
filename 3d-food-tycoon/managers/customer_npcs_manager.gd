#TODO: complete this shit
extends Node
class_name CustomerNpcManager

var is_initialized: bool = false
var waiting_spots_positions: Array[Vector3]
var ordering_spots_positions: Array[Vector3]
var eating_spots_positions: Array[Vector3]
var exit_spot_position: Vector3
var customer_scene=preload("res://scenes/npc/customer_npc/customer_npc.tscn")
var customers:Array[Customer_NPC]=[]
func populate_spots(waiting_container:Node3D,ordering_container:Node3D,eating_container:Node3D, exit_spot:Vector3) -> void:
	exit_spot_position=exit_spot
	populate_spots_array(waiting_container, waiting_spots_positions)
	populate_spots_array(ordering_container, ordering_spots_positions)
	populate_spots_array(eating_container, eating_spots_positions)
	is_initialized=true
	
func populate_spots_array(container: Node3D, array: Array[Vector3]) -> void:
	array.clear()
	for node in container.get_children():
		if node is Marker3D:
			array.push_back(node.global_position)

func _ready() -> void:
	pass

#implement customer spawning logic, customer ordering and eating spots assignment logic etc...
func _process(delta: float) -> void:
	if not is_initialized: 
		return
	if customers.size()==0:
		spawn_npc()
	
	if customers.size()>0:
		customers[0].walk_to_ordering_spot(ordering_spots_positions.pick_random())
	
#TODO
func spawn_npc():
	var customer_npc:Customer_NPC=customer_scene.instantiate()
	customer_npc.handler=self
	add_child(customer_npc)
	customers.push_back(customer_npc)
