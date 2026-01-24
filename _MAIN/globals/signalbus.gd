extends Node

#global signals
@warning_ignore_start("UNUSED_SIGNAL")
signal updateGameState(newState : Global.GameState)
signal loadLevel(levelNum : int)
signal loadMainMenu()
signal loadCredits()
signal loadLicenses()
signal loadVictory()
signal loadGameOver()
signal updateHud()
signal goalCountUp()
signal meltCountUp()
signal toggle_debug(debug: bool)
@warning_ignore_restore("UNUSED_SIGNAL")
