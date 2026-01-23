extends Node2D

@onready var gameViewPort := $GameCanvas
@onready var sceneManager := $scene_manager
@onready var pauseMenu := $UiPauseMenu

func _ready():
	gameViewPort.hide()
	#start listening for signals to load level or main menu
	SignalBus.loadLevel.connect(sceneManager.loadLevel)
	SignalBus.loadMainMenu.connect(sceneManager.loadMainMenu)
	SignalBus.loadCredits.connect(sceneManager.loadCredits)
	SignalBus.loadLicenses.connect(sceneManager.loadLicenses)
	SignalBus.loadVictory.connect(sceneManager.loadVictory)
	SignalBus.loadGameOver.connect(sceneManager.loadGameOver)
	SignalBus.updateGameState.connect(sceneManager.updateGameState)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_debug", false, true):
		Global.debug = !Global.debug
		SignalBus.toggle_debug.emit(Global.debug)
