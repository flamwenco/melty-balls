extends Control

func _ready():
	if OS.get_name() == 'Web':
		$MarginContainer/HBoxContainer/VBoxContainer/QuitButton.hide()

func _on_resume_button_pressed() -> void:
	SignalBus.loadLevel.emit(Global.Current_Level)

func _on_main_menu_button_pressed() -> void:
	SignalBus.loadMainMenu.emit()
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()
