extends Node2D

@onready var gameViewPort := $GameCanvas
@onready var sceneManager := $scene_manager
@onready var pauseMenu := $UiPauseMenu

func _ready():
	gameViewPort.hide()
	#start listening for signals to load level or main menu
	SignalBus.loadLevel.connect(sceneManager.loadLevel)
	SignalBus.loadMainMenu.connect(sceneManager.loadMainMenu)
	SignalBus.updateGameState.connect(sceneManager.updateGameState)
