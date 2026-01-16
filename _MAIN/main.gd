extends Node2D

@onready var gameViewPort := $GameCanvas
@onready var sceneManager := $GameCanvas/scene_manager

func _ready():
	gameViewPort.hide()
	SignalBus.loadLevel.connect(sceneManager.loadLevel)
