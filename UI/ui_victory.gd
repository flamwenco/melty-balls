extends Control

func _ready():
	if OS.get_name() == 'Web':
		$MarginContainer/HBoxContainer/VBoxContainer/QuitButton.hide()

func _on_next_level_button_pressed() -> void:
	Global.Current_Level += 1
	SignalBus.loadLevel.emit(Global.Current_Level)

func _on_replay_button_pressed() -> void:
	SignalBus.loadLevel.emit(Global.Current_Level)

func _on_main_menu_button_pressed() -> void:
	SignalBus.loadMainMenu.emit()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
