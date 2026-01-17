extends Node2D

@onready var snowball_spawner := $snowball_spawn
@onready var birbs_spawner := $birbs_spawn
var lilguyNode : Node
var birbsNode : Node

func _ready():
	spawnLilGuys()
	spawnBirbs()
	
func spawnLilGuys():
	lilguyNode = load(Global.lilguyPath).instantiate()
	lilguyNode.global_position = snowball_spawner.global_position
	add_child(lilguyNode)
	lilguyNode.show()
	
func spawnBirbs():
	birbsNode = load(Global.birbsPath).instantiate()
	birbsNode.global_position = birbs_spawner.global_position
	add_child(birbsNode)
	birbsNode.show()
