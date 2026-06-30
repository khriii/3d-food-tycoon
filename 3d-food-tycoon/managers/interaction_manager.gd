extends Node

var interaction_areas:Array[InteractionAreaComponent]=[]
var player_can_interact:bool=true
@onready var player:CharacterBody3D=get_tree().get_first_node_in_group("player")
@onready var label:Label=get_tree().get_first_node_in_group("message_label")
const base_interaction_alert_label_text:String="Press [E] to "

# Registers an interaction area in the interaction areas
func add_interaction_area(area:InteractionAreaComponent):
	interaction_areas.push_back(area)

# Removes an interaction area from the interaction areas if present
func remove_interaction_area(area:InteractionAreaComponent):
	if area in interaction_areas:
		interaction_areas.erase(area)

# Sorts the interaction areas and changes the label's text accordingly
func _process(delta: float) -> void:
	if interaction_areas.size()>0 && player_can_interact:
		interaction_areas.sort_custom(_sort_by_distance_to_player)
		# Label text is set. This could be changed to whatever effect or shader one wants to play when an interaction becomes available.
		label.text=base_interaction_alert_label_text+interaction_areas[0].action_name
		label.show()
	else:
		label.hide()

# Sorts the interaction area array based on the position of the player (closest to player first)
func _sort_by_distance_to_player(area1:InteractionAreaComponent,area2:InteractionAreaComponent):
	var area1_to_player_distance=player.global_position.distance_to(area1.global_position)
	var area2_to_player_distance=player.global_position.distance_to(area1.global_position)
	return area1_to_player_distance<area2_to_player_distance
	
	
# Performs interaction IF the player can interact
func _input(event: InputEvent) -> void:
	if event.is_action("interact") and player_can_interact:
		if interaction_areas.size()>0:
			player_can_interact=false
			label.hide()
			print("interaction started")
			await interaction_areas[0].interaction.call()
			print("interaction finished")
			player_can_interact=true
