extends Node

@onready var subview := $"../GameCanvas/SubViewportContainer/SubViewport"
@onready var mainmenu := $"../UiMainmenu"
@onready var levelselect := $"../UiLevelselect"
@onready var gamecanvas := $"../GameCanvas"
@onready var pausescreen := $"../UiPauseMenu"
@onready var hudscreen := $"../UiHud"
@onready var victoryscreen := $"../UiVictory"
@onready var gameoverscreen := $"../UiGameOver"
@onready var credits := $"../UiCredits"
@onready var licenses := $"../UiLicenses"

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
	hideUIs()
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
	hideUIs()
	mainmenu.show()

func loadLevelSelect():
	SignalBus.updateGameState.emit(Global.GameState.LEVELSELECT)
	unloadLevel()
	hideUIs()
	levelselect.show()

func loadCredits():
	SignalBus.updateGameState.emit(Global.GameState.CREDITS)
	unloadLevel()
	hideUIs()
	credits.show()
	
func loadLicenses():
	SignalBus.updateGameState.emit(Global.GameState.LICENSES)
	unloadLevel()
	hideUIs()
	licenses.show()
	
func loadVictory():
	SignalBus.updateGameState.emit(Global.GameState.VICTORY)
	victoryscreen.show() #we don't hide all screens, so level can still be visible behind victory screen
	
func loadGameOver():
	SignalBus.updateGameState.emit(Global.GameState.GAMEOVER)
	gameoverscreen.show() #we don't hide all screens, so level can still be visible behind game over screen
	
func hideUIs():
	mainmenu.hide()
	pausescreen.hide()
	victoryscreen.hide()
	gameoverscreen.hide()
	credits.hide()
	licenses.hide()
	gamecanvas.hide()
	hudscreen.hide()
