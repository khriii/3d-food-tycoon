extends PickableItem

var inventory_component: InventoryComponent

func _ready() -> void:
	pickup_area.interaction = Callable(self, "pickup")
	if InteractionManager.player:
		inventory_component = InteractionManager.player.find_child("InventoryComponent")

func pickup() -> void:
	if inventory_component:
		var index = inventory_component.add_to_inventory(item_data)
		
		if index != -1:
			inventory_component.set_item_in_hand(index)
			
			print("picked up dough")
			
			
			queue_free()
		else:
			print("inventory full")
