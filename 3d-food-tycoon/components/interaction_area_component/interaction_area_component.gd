extends Area3D
class_name InteractionAreaComponent

# Displayed in the label before interacting
@export var action_name:String="interact"

# Override this callable to implement interaction logic for specific objects
var interaction:Callable=func():
	pass

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("a player entered in this interaction area")
		InteractionManager.add_interaction_area(self)

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("a player exited from this interaction area")
		InteractionManager.remove_interaction_area(self)
