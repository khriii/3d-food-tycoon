class_name MovementComponent
extends Node3D

@export var entity: CharacterBody3D
@export var gravity: float = 9.8

func move(delta: float):
	if !entity.is_on_floor():
		entity.velocity.y -= gravity * delta
	
	# 2. Applicare effettivamente il movimento
	entity.move_and_slide()

func _physics_process(delta: float) -> void:
	if entity:
		move(delta)
