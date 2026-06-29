extends StaticBody3D

const TILE_SIZE: Vector3 = Vector3(1.0, 1.0, 1.0)

func _physics_process(_delta: float) -> void:
	var camera: Camera3D = get_viewport().get_camera_3d()
	if not camera:
		return

	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var drop_plane: Plane = Plane(Vector3.UP, 0.0)

	var ray_origin: Vector3 = camera.project_ray_origin(mouse_pos)
	var ray_normal: Vector3 = camera.project_ray_normal(mouse_pos)

	var intersection = drop_plane.intersects_ray(ray_origin, ray_normal)

	if intersection != null:
		var snapped_pos: Vector3 = (intersection / TILE_SIZE).floor() * TILE_SIZE
		var final_pos: Vector3 = snapped_pos + (TILE_SIZE / 2.0)
		final_pos.y = 0.5 
		global_position = final_pos
