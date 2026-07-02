extends Node3D
class_name level
@export var waiting_spots_container:Node3D
@export var ordering_spots_container:Node3D
@export var eating_spots_container:Node3D
@export var exit_spot:Marker3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	NpcManager.populate_spots(waiting_spots_container, ordering_spots_container, eating_spots_container,exit_spot.global_position)
