extends Control

@export var button: Button

func _ready() -> void:
	if button:
		button.pressed.connect(_on_button_pressed)


func _on_button_pressed() -> void:
	print("button pressed")
