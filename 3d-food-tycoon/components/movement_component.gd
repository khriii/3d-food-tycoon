class_name MovementComponent
extends Node3D

@export var entity: CharacterBody3D
@export var input_component: InputComponent
@export var speed: float = 5.0
@export var jump_velocity: float = 4.5
@export var gravity: float = 9.8

func apply_gravity(delta: float) -> void:
	if not entity.is_on_floor():
		entity.velocity.y -= gravity * delta

func apply_movement() -> void:
	if input_component:
		var direction := Vector3(input_component.input_dir.x, 0, input_component.input_dir.y).normalized()
		
		if direction:
			entity.velocity.x = direction.x * speed
			entity.velocity.z = direction.z * speed
		else:
			entity.velocity.x = move_toward(entity.velocity.x, 0, speed)
			entity.velocity.z = move_toward(entity.velocity.z, 0, speed)

func move(delta: float) -> void:
	apply_gravity(delta)
	apply_movement()
	entity.move_and_slide()

func _physics_process(delta: float) -> void:
	if entity:
		move(delta)
