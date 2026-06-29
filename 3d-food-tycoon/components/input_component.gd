class_name InputComponent
extends Node

signal action_triggered(action_name: String)

@export_category("Movement Actions")
@export var move_forward: String = "move_up"
@export var move_backward: String = "move_down"
@export var move_left: String = "move_left"
@export var move_right: String = "move_right"

@export_category("Other Actions")
@export var custom_actions: Array[String] = []

var input_dir: Vector2 = Vector2.ZERO

func _process(_delta: float) -> void:
	_update_movement_input()
	_check_other_actions()

func _update_movement_input() -> void:
	input_dir = Input.get_vector(
		move_left, 
		move_right, 
		move_forward, 
		move_backward
	)

func _check_other_actions() -> void:
	for action in custom_actions:
		if Input.is_action_just_pressed(action):
			action_triggered.emit(action)
