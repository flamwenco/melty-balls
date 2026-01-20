extends Node

#global signals
@warning_ignore_start("UNUSED_SIGNAL")
signal updateGameState(newState : Global.GameState)
signal loadLevel(levelNum : int)
signal loadMainMenu()
signal updateHud(current_goals : int, goals_needed : int, lilguys_remaining : int, lilguys_melted : int)
signal goalCountUp()
signal meltCountUp()
signal toggle_debug(debug: bool)
@warning_ignore_restore("UNUSED_SIGNAL")
