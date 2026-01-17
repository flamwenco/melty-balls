extends Control


func _on_start_button_pressed() -> void:
	Global.Current_Level = 1
	SignalBus.loadLevel.emit(Global.Current_Level)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
