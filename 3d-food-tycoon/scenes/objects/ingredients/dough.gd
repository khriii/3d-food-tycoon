extends PickableItem

var inventory_component: InventoryComponent
var equipment_component: EquipmentComponent

func _ready() -> void:
	pickup_area.interaction = Callable(self, "pickup")
	if InteractionManager.player:
		inventory_component = InteractionManager.player.find_child("InventoryComponent")
		equipment_component = InteractionManager.player.find_child("EquipmentComponent")

func pickup() -> void:
	if inventory_component:
		if self.item_data:
			inventory_component.add_item(self.item_data)
			if equipment_component:
				equipment_component.equip_item(self.item_data)
	queue_free()
