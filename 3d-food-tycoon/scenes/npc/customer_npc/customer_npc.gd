extends CharacterBody3D
class_name Customer_NPC
@export var movement_component: MovementComponent
var handler:CustomerNpcManager
@onready var navigation_agent:NavigationAgent3D=$NavigationAgent3D
enum Customer_NPC_state{
	WALK,
	IDLE,
	ORDER,
	EAT
}

var current_state:Customer_NPC_state
@onready var idle_timer: Timer=$IdleTimer
var is_going_to_order:bool=false
var is_going_to_eat:bool=false

var has_eaten:bool=false

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
			if not is_going_to_order and not is_going_to_eat:
				walk_to_waiting_spot()
		Customer_NPC_state.ORDER:
			#play order animation, show order request
			pass
			
		Customer_NPC_state.EAT:
			#play order animation, show order request
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
func walk_to_ordering_spot(pos: Vector3):
	navigation_agent.target_position=pos
	is_going_to_order = true
	change_state(Customer_NPC_state.WALK)

func walk_to_eating_spot(pos: Vector3):
	navigation_agent.target_position=pos
	is_going_to_eat = true
	change_state(Customer_NPC_state.EAT)

func _on_navigation_agent_3d_navigation_finished() -> void:
	if is_going_to_order:
		is_going_to_order = false
		change_state(Customer_NPC_state.ORDER)
	if is_going_to_eat:
		is_going_to_eat=false
		change_state(Customer_NPC_state.EAT)
	else:
		change_state(Customer_NPC_state.IDLE)
