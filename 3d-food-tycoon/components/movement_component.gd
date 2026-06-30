class_name MovementComponent
extends Node3D

@export var entity: CharacterBody3D
@export var speed: float = 5.0
@export var jump_velocity: float = 4.5
@export var gravity: float = 9.8

func apply_gravity(delta: float) -> void:
	if not entity.is_on_floor():
		entity.velocity.y -= gravity * delta

func apply_movement(dir: Vector2) -> void:
	var direction := Vector3(dir.x, 0, dir.y).normalized()
	
	if direction:
		entity.velocity.x = direction.x * speed
		entity.velocity.z = direction.z * speed
	else:
		entity.velocity.x = move_toward(entity.velocity.x, 0, speed)
		entity.velocity.z = move_toward(entity.velocity.z, 0, speed)

func move(delta: float, dir: Vector2) -> void:
	apply_gravity(delta)
	apply_movement(dir)
	entity.move_and_slide()
