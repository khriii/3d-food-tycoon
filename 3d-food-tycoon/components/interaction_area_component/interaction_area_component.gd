extends Area3D
class_name InteractionAreaComponent

# Displayed in the label before interacting
@export var action_name:String="interact"
@export var interaction_object:Node3D

# setter property to handle changes to the availability of the interaction
@export var interaction_available:bool=true:
	set(value):
		interaction_available = value
		if not is_inside_tree():
			return
		if interaction_available:
			# if interaction becomes available, check if player is overlapping and add the interaction
			for body in get_overlapping_bodies():
				if body.is_in_group("player"):
					InteractionManager.add_interaction_area(self)
					break
		else:
			# if interaction becomes unavailable, remove it
			InteractionManager.remove_interaction_area(self)

# Override this callable to implement interaction logic for specific objects
var interaction:Callable=func():
	#start job frullato.
	fai_frullato()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and interaction_available:
		InteractionManager.add_interaction_area(self)

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		InteractionManager.remove_interaction_area(self)

func fai_frullato():
	interaction_available=false
	await get_tree().create_timer(5).timeout
	print("fatto frullato")
	interaction_available=true
