extends Node3D

@onready var viewport: SubViewport = $SubViewport
@onready var monitor_mesh: MeshInstance3D = $pc/Plane
@onready var area_3d: Area3D = $pc/Plane/InteractionArea

var is_mouse_inside: bool = false
var last_mouse_pos_2d: Vector2 = Vector2.ZERO

func _ready():
	area_3d.input_event.connect(_on_area_3d_input_event)
	area_3d.mouse_exited.connect(_on_mouse_exited)

func _on_area_3d_input_event(_camera: Camera3D, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int):
	var local_pos: Vector3 = monitor_mesh.global_transform.affine_inverse() * event_position
	
	var mesh_size: Vector2 = Vector2(2.0, 2.0) 
	if monitor_mesh.mesh:
		if "size" in monitor_mesh.mesh:
			mesh_size = monitor_mesh.mesh.size
	
	# Convert coordinates
	var nx: float = (local_pos.x / mesh_size.x) + 0.5
	var ny: float = 0.5 - (local_pos.y / mesh_size.y)

	var viewport_pos: Vector2 = Vector2(
		nx * viewport.size.x,
		ny * viewport.size.y
	)
	
	if event is InputEventMouse:
		var duplicated_event: InputEventMouse = event.duplicate()
		duplicated_event.position = viewport_pos
		duplicated_event.global_position = viewport_pos
		
		if event is InputEventMouseMotion:
			duplicated_event.relative = viewport_pos - last_mouse_pos_2d
			last_mouse_pos_2d = viewport_pos
			
		viewport.push_input(duplicated_event)
		is_mouse_inside = true

func _on_mouse_exited():
	is_mouse_inside = false
