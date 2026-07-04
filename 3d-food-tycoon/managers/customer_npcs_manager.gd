#TODO: complete this shit
extends Node
class_name CustomerNpcManager

@export var max_no_order_customers:int=5
var is_initialized: bool = false
var waiting_spots_positions: Array[Vector3]
var ordering_spots_positions: Array[Vector3]
var free_ordering_spots: Array[Vector3]
var eating_spots_positions: Array[Vector3]
var exit_spot_position: Vector3
var customer_scene=preload("res://scenes/npc/customer_npc/customer_npc.tscn")
var customers:Array[Customer_NPC]=[]
@onready var customer_spawn_timer:Timer=Timer.new()
@export var customer_spawn_cooldown:float=25.0

func populate_spots(waiting_container:Node3D,ordering_container:Node3D,eating_container:Node3D, exit_spot:Vector3) -> void:
	exit_spot_position=exit_spot
	populate_spots_array(waiting_container, waiting_spots_positions)
	populate_spots_array(ordering_container, ordering_spots_positions)
	populate_spots_array(eating_container, eating_spots_positions)
	free_ordering_spots = ordering_spots_positions.duplicate() # Clona i posti inizialmente tutti liberi
	is_initialized=true
	
func populate_spots_array(container: Node3D, array: Array[Vector3]) -> void:
	array.clear()
	for node in container.get_children():
		if node is Marker3D:
			array.push_back(node.global_position)

func _ready() -> void:
	add_child(customer_spawn_timer)
	customer_spawn_timer.wait_time=customer_spawn_cooldown
	customer_spawn_timer.autostart=false
	customer_spawn_timer.one_shot=true
	customer_spawn_timer.timeout.connect(spawn_customer)

#implement customer spawning logic, customer ordering and eating spots assignment logic etc...
func _process(_delta: float) -> void:
	if not is_initialized: 
		return
	
	handle_customer_spawning()
	handle_ordering_spots_assignment()
	
#frees an ordering spot which had been assigned to a customer.
#NOTE: this is meant to be called by a customer npc itself when it is done ordering
func free_ordering_spot(spot: Vector3) -> void:
	if not free_ordering_spots.has(spot):
		free_ordering_spots.push_back(spot)

#handles customer spawning logic
func handle_customer_spawning()->void:
	if customers.size()==0:
		customer_spawn_timer.start(randf_range(2.0, 7.0))
		spawn_customer()
	if get_no_order_customers_count()<max_no_order_customers and customer_spawn_timer.is_stopped():
		customer_spawn_timer.start()

#handles ordering spot assignment for customer npcs
func handle_ordering_spots_assignment()->void:
	if free_ordering_spots.size()>0:
		for npc in customers:
			if not npc.is_going_to_order and not npc.has_ordered and not npc.is_leaving and not npc.current_state==Customer_NPC.Customer_NPC_state.ORDER:
				var chosen_spot=free_ordering_spots.pick_random()
				free_ordering_spots.erase(chosen_spot)
				npc.assigned_ordering_spot = chosen_spot
				npc.walk_to_ordering_spot()
				break

#returns the count of customer npcs that haven't placed an order yet
func get_no_order_customers_count()->int:
	var count:int=customers.size()
	for npc in customers:
		if npc.has_ordered==true:
			count=count-1
			
	return count

#returns the count of customers who are ordering or are walking towards an ordering spot to order
func get_ordering_customers_count()->int:
	var count:int=0
	for npc in customers:
		if npc.is_going_to_order or npc.current_state==Customer_NPC.Customer_NPC_state.ORDER:
			count+=1
	return count

#spawns a customer at the entrance of the level (ExitSpot)
func spawn_customer():
	var customer_npc:Customer_NPC=customer_scene.instantiate()
	customers.push_back(customer_npc)
	customer_npc.handler=self
	add_child(customer_npc)
	customer_npc.global_position=exit_spot_position
	print("customer spawned")
