extends Node

#global signals
@warning_ignore_start("UNUSED_SIGNAL")
signal updateGameState(newState : Global.GameState)
signal loadLevel(levelNum : int)
@warning_ignore_restore("UNUSED_SIGNAL")
