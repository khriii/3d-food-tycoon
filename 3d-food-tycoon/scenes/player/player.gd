class_name Player
extends CharacterBody3D

@export var input_component: InputComponent
@export var movement_component: MovementComponent

func _ready() -> void:
	if not movement_component:
		printerr("player.gd: movement_component missing")
	if not input_component:
		printerr("player.gd: input_component missing")
	
	# Reference the player for the interactions
	InteractionManager.player = self

func _physics_process(delta: float) -> void:
	var input_dir = input_component.input_dir
	movement_component.move(delta, input_dir)
