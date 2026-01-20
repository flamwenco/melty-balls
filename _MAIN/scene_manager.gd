extends Node

@onready var subview := $"../GameCanvas/SubViewportContainer/SubViewport"
@onready var mainmenu := $"../UiMainmenu"
@onready var gamecanvas := $"../GameCanvas"
@onready var pausescreen := $"../UiPauseMenu"
@onready var hudscreen := $"../UiHud"

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
	unloadLevel()
	levelPath = "res://Levels/Level" + str(levelNum) + ".tscn"
	levelNode = load(levelPath).instantiate()
	subview.add_child(levelNode)
	levelNode.show()
	hudscreen.show()

#unload current levelNode from memory
func unloadLevel():
	#verify the node exists and is valid (not already freed)
	if levelNode != null && is_instance_valid(levelNode):
		subview.remove_child(levelNode)
		levelNode.queue_free()
		await levelNode.tree_exited #verify the unload is finished

func loadMainMenu():
	SignalBus.updateGameState.emit(Global.GameState.MAINMENU)
	unloadLevel()
	gamecanvas.hide()
	hudscreen.hide()
	pausescreen.hide()
	mainmenu.show()
	
