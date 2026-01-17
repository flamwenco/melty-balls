extends Node

@onready var subview := $"../GameCanvas/SubViewportContainer/SubViewport"
@onready var mainmenu := $"../UiMainmenu"
@onready var gamecanvas := $"../GameCanvas"
@onready var pausescreen := $"../UiPauseMenu"

var levelNode : Node
var levelPath : String

#hide main menu ui, show gamecanvas
#unload any previously loaded level
#instantiate the level node based on levelnum
#add as child to our subviewport
#show the levelNode
func updateGameState(newState : Global.GameState):
	Global.Current_GameState = newState

func loadLevel(levelNum : int):
	SignalBus.updateGameState.emit(Global.GameState.PLAYING)
	mainmenu.hide()
	pausescreen.hide()
	gamecanvas.show()
	unloadLevel(Global.Current_Level)
	levelPath = "res://Levels/Level" + str(levelNum) + ".tscn"
	levelNode = load(levelPath).instantiate()
	subview.add_child(levelNode)
	levelNode.show()

#queue_free to unload passed level num from memory
func unloadLevel(levelToUnload : int):
	levelPath = "res://Levels/Level" + str(levelToUnload) + ".tscn"
	levelNode = load(levelPath).instantiate()
	levelNode.queue_free()

func loadMainMenu():
	SignalBus.updateGameState.emit(Global.GameState.MAINMENU)
	if Global.Current_Level:
		unloadLevel(Global.Current_Level)
	gamecanvas.hide()
	pausescreen.hide()
	mainmenu.show()
