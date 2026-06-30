extends CharacterBody3D

@export var movement_component: MovementComponent


func _physics_process(delta: float) -> void:
	movement_component.move(delta, Vector2.UP)
