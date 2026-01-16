extends Control


func _on_start_button_pressed() -> void:
	SignalBus.loadLevel.emit(1)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
