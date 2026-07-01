extends Node

var interaction_areas:Array[InteractionAreaComponent]=[]
#should be handled by the single interaction areas (for example an interaction which makes the player open the fridge should stop the player from doing anything else)
var player_can_interact:bool=true
@onready var player:CharacterBody3D=get_tree().get_first_node_in_group("player")
var label:Label
const base_interaction_alert_label_text:String="Press [E] to "
var current_active_area: InteractionAreaComponent = null
# Registers an interaction area in the interaction areas
func add_interaction_area(area:InteractionAreaComponent):
	interaction_areas.push_back(area)

# Removes an interaction area from the interaction areas if present
func remove_interaction_area(area:InteractionAreaComponent):
	if area in interaction_areas:
		interaction_areas.erase(area)

# Sorts the interaction areas and changes the label's text accordingly
func _process(_delta: float) -> void:
	if not label:
		label = get_tree().get_first_node_in_group("message_label")
		
	if interaction_areas.size() > 0 && player_can_interact:
		interaction_areas.sort_custom(_sort_by_distance_to_mouse)
		
		var top_area = interaction_areas[0]
		if top_area != current_active_area:
			if current_active_area:
				hide_interaction_visually(current_active_area)
			
			current_active_area = top_area
			show_interaction_visually(current_active_area)
			
	else:
		if current_active_area:
			hide_interaction_visually(current_active_area)
			current_active_area = null

func show_interaction_visually(int_area:InteractionAreaComponent):
	label.text=base_interaction_alert_label_text+int_area.action_name
	label.show()
	
	if not int_area.interaction_object:
		return
		
	var meshes = int_area.interaction_object.find_children("*", "MeshInstance3D", true, false) as Array[MeshInstance3D]
	for mesh in meshes:
		var mat = mesh.get_active_material(0)
		if mat and mat is StandardMaterial3D:
			var highlight_mat = mat.duplicate()
			highlight_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
			highlight_mat.albedo_color = Color(1.0, 0.65, 0.0, 0.75)
			mesh.set_surface_override_material(0, highlight_mat)
			
func hide_interaction_visually(int_area:InteractionAreaComponent):
	label.hide()
	if not int_area.interaction_object:
		return
		
	var meshes = int_area.interaction_object.find_children("*", "MeshInstance3D", true, false) as Array[MeshInstance3D]
	for mesh in meshes:
		mesh.set_surface_override_material(0, null)

# Sorts the interaction area array based on the position of the player (closest to player first)
func _sort_by_distance_to_player(area1:InteractionAreaComponent,area2:InteractionAreaComponent):
	var area1_to_player_distance=player.global_position.distance_to(area1.global_position)
	var area2_to_player_distance=player.global_position.distance_to(area2.global_position)
	return area1_to_player_distance<area2_to_player_distance
	
# Sorts the interaction area array based on the position of the mouse cursor (closest to mouse cursor first)
func _sort_by_distance_to_mouse(area1: InteractionAreaComponent, area2: InteractionAreaComponent) -> bool:
	var camera: Camera3D = get_viewport().get_camera_3d()
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	
	# projects 3d positions to  2d coordinates (screen)
	var area1_screen_pos: Vector2 = camera.unproject_position(area1.global_position)
	var area2_screen_pos: Vector2 = camera.unproject_position(area2.global_position)
	
	# calculates distance between the mouse cursor and the projection areas
	var dist1: float = mouse_pos.distance_to(area1_screen_pos)
	var dist2: float = mouse_pos.distance_to(area2_screen_pos)
	
	return dist1 < dist2

# Performs interaction IF the player can interact
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_can_interact:
		if interaction_areas.size()>0:
			label.hide()
			print("interaction started")
			await interaction_areas[0].interaction.call()
