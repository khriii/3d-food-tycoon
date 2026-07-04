extends CharacterBody3D
class_name Customer_NPC

#VARIABLES
@export var movement_component: MovementComponent
var handler:CustomerNpcManager
@onready var navigation_agent:NavigationAgent3D=$NavigationAgent3D

enum Customer_NPC_state{WALK,IDLE,ORDER,EAT}
var current_state:Customer_NPC_state

var assigned_ordering_spot: Vector3
@onready var idle_timer: Timer=$IdleTimer
@onready var ordering_timer: Timer=$OrderingTimer
var max_ordering_time_before_crashout:float=20.0

var is_going_to_order:bool=false
var is_going_to_eat:bool=false
var has_eaten:bool=false
var has_ordered:bool=false
var is_leaving:bool=false
#METHODS
func _ready() -> void:
	change_state(Customer_NPC_state.WALK)

func _physics_process(delta: float) -> void:
	match current_state:
		Customer_NPC_state.IDLE:
			movement_component.move(delta, Vector2.ZERO)
			pass
		Customer_NPC_state.WALK:
			walk(delta)

func change_state(new_state:Customer_NPC_state)->void:
	current_state=new_state
	
	match current_state:
		Customer_NPC_state.IDLE:
			start_idle_timer()
			#play idle animation
		Customer_NPC_state.WALK:
			#play walk animation
			if not is_going_to_order and not is_going_to_eat and not is_leaving:
				walk_to_waiting_spot()
		Customer_NPC_state.ORDER:
			print("customer ORDERING")
			show_ordering_visual_effects()
			ordering_timer.start(randf_range(ordering_timer.wait_time,ordering_timer.wait_time+6.0))
		Customer_NPC_state.EAT:
			#play eating animation, start timer for a few seconds, make customer leave
			pass

func _on_idle_timer_timeout() -> void:
	if current_state==Customer_NPC_state.IDLE:
		if randf() < 0.7:
			change_state(Customer_NPC_state.WALK)
		else:
			change_state(Customer_NPC_state.IDLE)

func start_idle_timer()->void:
	idle_timer.start(7.0+(randf()*2))
	
func walk_to_waiting_spot():
	navigation_agent.target_position=handler.waiting_spots_positions.pick_random()
	
func walk(delta:float):
	var next_path_pos: Vector3 = navigation_agent.get_next_path_position()
	var dir_3d: Vector3 = global_position.direction_to(next_path_pos)
	var dir_2d: Vector2 = Vector2(dir_3d.x, dir_3d.z)
	movement_component.move(delta, dir_2d)
	var look_at_target:Vector3=Vector3(next_path_pos.x,global_position.y, next_path_pos.z)
	if not global_position.is_equal_approx(look_at_target):
		look_at(look_at_target)
func walk_to_ordering_spot():
	navigation_agent.target_position=assigned_ordering_spot
	is_going_to_order = true
	change_state(Customer_NPC_state.WALK)

func walk_to_eating_spot(pos: Vector3):
	handler.free_ordering_spot(assigned_ordering_spot)
	navigation_agent.target_position=pos
	is_going_to_eat = true
	change_state(Customer_NPC_state.EAT)

#TODO
func show_ordering_visual_effects()->void:
	pass

func _on_navigation_agent_3d_navigation_finished() -> void:
	if is_going_to_order==true:
		is_going_to_order = false
		change_state(Customer_NPC_state.ORDER)
		return
	if is_going_to_eat==true:
		is_going_to_eat=false
		change_state(Customer_NPC_state.EAT)
		return
	if is_leaving==true:
		remove_self_from_customers()
		self.queue_free()
		return
	if current_state == Customer_NPC_state.WALK:
		change_state(Customer_NPC_state.IDLE)
		return

#the customer gets angry and leaves because too much time elapsed
func _on_ordering_timer_timeout() -> void:
	print("CUSTOMER: i'm leaving, it's taking TOO MUCH TIME!")
	#show angry animation for afew seconds, then leave
	exit()
	
func exit():
	handler.free_ordering_spot(assigned_ordering_spot)
	navigation_agent.target_position=handler.exit_spot_position
	is_leaving=true
	change_state(Customer_NPC_state.WALK)
	
#removes self from the customers array
func remove_self_from_customers()->void:
	if self in handler.customers:
		handler.customers.erase(self)
