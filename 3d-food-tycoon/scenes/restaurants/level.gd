extends Node3D
class_name Level
@onready var customer_npc_manager:CustomerNpcManager=$CustomerNpcManager
@onready var waiting_container:Node3D=$SpotsContainer/WaitingSpotsContainer
@onready var ordering_container:Node3D=$SpotsContainer/OrderingSpotsContainer
@onready var eating_container:Node3D=$SpotsContainer/EatingSpotsContainer
@onready var exit_spot:Marker3D=$SpotsContainer/ExitSpot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	customer_npc_manager.populate_spots(waiting_container,ordering_container,eating_container,exit_spot.global_position)
