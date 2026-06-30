extends Node3D

@export var vending_machine : StaticBody3D


func _ready() -> void:
	await get_tree().create_timer(3.0).timeout
	
	print("Camera moved")
	if vending_machine:
		var camera_target: Marker3D = vending_machine.find_child("CameraTarget")
		
		if not camera_target:
			print("camera_target not found")
			return
		
		var camera = get_viewport().get_camera_3d()
		
		if not camera:
			print("camera not found")
		
		camera.global_transform = camera_target.global_transform
	
