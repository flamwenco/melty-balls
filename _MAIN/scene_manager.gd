extends Node

@onready var subview := $"../SubViewportContainer/SubViewport"
@onready var mainmenu := $"../../UiMainmenu"
var level : Node
	
func loadLevel(levelNum : int):
	#TODO: properly build tree path to level nodes, using this for now to start with just level 1
	#TODO: how can we build levels at a lower native res of 384x216 then use subview port to scale up x5???
	mainmenu.hide()
	if levelNum == 1:
		level = load("res://Levels/Level1.tscn").instantiate()
		subview.add_child(level)
		level.show()
