extends Node

#global signals
@warning_ignore_start("UNUSED_SIGNAL")
signal updateGameState(newState : Global.GameState)
signal loadLevel(levelNum : int)
signal loadMainMenu()
@warning_ignore_restore("UNUSED_SIGNAL")
