extends Level
class_name testingLevel
@onready var timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.customer_npc_manager.populate_spots(self.waiting_container, ordering_container, eating_container, exit_spot.global_position)
