extends Control

func _ready():
	if OS.get_name() == 'Web':
		$MarginContainer/HBoxContainer/VBoxContainer/QuitButton.hide()

func _on_start_button_pressed() -> void:
	Global.Current_Level = 1
	SignalBus.loadLevel.emit(Global.Current_Level)


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_credits_button_pressed() -> void:
	SignalBus.loadCredits.emit()


func _on_licenses_button_pressed() -> void:
	SignalBus.loadLicenses.emit()
