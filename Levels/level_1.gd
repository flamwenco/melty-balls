extends Node2D

@onready var snowball_spawner := $snowball_spawn
@onready var birbs_spawner := $birbs_spawn
@onready var sun_spawner := $sun_spawn
var goalMin : int
var lilguysMax : int
var goalCounter : int
var lilguyNode : LilGuy
var birbsNode : Node
var sunNode : Node
var light: PointLight2D

func _ready():
	goalMin = 10 #lilguys that need to reach goal for win condition
	lilguysMax = 20 #max lilguys that will spawn
	goalCounter = 0 #counter for current goals reached
	initSpawns() #spawn initial objects, TODO: lilguys should have continous spawn logic until max is reached
	
func initSpawns():
	#spawn sun object
	spawnSun()
	#get light source from the sun node
	for child in sunNode.get_children():
		if child is PointLight2D:
			light = child
			break #exit loop
	spawnBirbs()
	spawnLilGuys()

func spawnSun():
	sunNode = load(Global.sunPath).instantiate()
	sunNode.global_position = sun_spawner.global_position
	add_child(sunNode)
	sunNode.show()

func spawnLilGuys():
	lilguyNode = load(Global.lilguyPath).instantiate()
	lilguyNode.light = light
	lilguyNode.global_position = snowball_spawner.global_position
	add_child(lilguyNode)
	lilguyNode.show()
	
func spawnBirbs():
	birbsNode = load(Global.birbsPath).instantiate()
	birbsNode.global_position = birbs_spawner.global_position
	add_child(birbsNode)
	birbsNode.show()

func _on_goal_zone_body_entered(_body: Node2D) -> void:
	pass # Replace with function body.
	#emit a signal when _body_entered() detects a lilguy/snowball object
	#lilguy / snowballs need to interpret this and queue_free() to remove from memory
	#a counter needs to iterate to count how many have reached goal
	#this goal_counter should global signal to some sort of HUD
