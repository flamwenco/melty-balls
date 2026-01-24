extends Control

func _ready():
	if OS.get_name() == 'Web':
		$MarginContainer/HBoxContainer/VBoxContainer/QuitButton.hide()
	hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if isPauseInputAllowed():
			if get_tree().paused == false: #we only pause the game if its not already paused
				_pause()
			elif get_tree().paused == true: #if the game is already paused
				_resume()

#pauses the game tree
#NOTE: !!! IMPORTANT !!!
#		in the "Inspector" for pause UI, make sure Process -> Mode is set to Always
#		this means this Node will always process even if the scene tree is paused
#		if you do not do this then .paused() will pause everything INCLUDING the pause ui
func _pause():
	show()
	SignalBus.updateGameState.emit(Global.GameState.PAUSED) 
	get_tree().paused = true

#unpause the tree
func _resume():
	get_tree().paused = false
	SignalBus.updateGameState.emit(Global.GameState.PLAYING)
	hide()

func _on_main_menu_button_pressed() -> void:
	_resume()
	SignalBus.loadMainMenu.emit()
	
func _on_restart_button_pressed() -> void:
	SignalBus.loadLevel.emit(Global.Current_Level)
	_resume()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_resume_button_pressed() -> void:
	_resume()
	
func isPauseInputAllowed() -> bool:
	if Global.Current_GameState == Global.GameState.PLAYING:
		return true
	elif Global.Current_GameState == Global.GameState.PAUSED:
		return true
	else:
		return false
