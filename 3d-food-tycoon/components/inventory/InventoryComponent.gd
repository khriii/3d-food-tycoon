extends Node
class_name InventoryComponent

signal inventory_updated # TODO: connect to ui

@export var slots: Array[SlotData] = []
@export var inventory_size: int = 16


func _ready() -> void:
	slots.resize(inventory_size)


func add_item(new_item: ItemData, amount: int = 1) -> bool:
	if new_item.stackable:
		for slot in slots:
			if slot != null and slot.item == new_item:
				if slot.quantity + amount <= new_item.max_stack:
					slot.quantity += amount
					inventory_updated.emit()
					return true

	for i in range(slots.size()):
		if slots[i] == null or slots[i].item == null:
			if slots[i] == null:
				slots[i] = SlotData.new()
			
			slots[i].item = new_item
			slots[i].quantity = amount
			
			inventory_updated.emit()
			return true

	return false
