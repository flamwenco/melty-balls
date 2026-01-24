class_name Level extends Node2D
## Number of lil guys that need to reach goal for win condition.
@export var goal_min: int
## Max lil guys that will spawn.
@export var lilguys_max_to_spawn : int

@export_group("Components")

@export_subgroup("Nodes")
## The level's tiles.
@export var tile_map: TileMapLayer
## Where lil guys will spawn at.
@export var lilguy_spawn: Marker2D
## Where the player node.
@export var birbs: Birbs
## The light node.
@export var sun: Sun

@export_subgroup("Packed Scenes")
## The scene for the lil guys, for spawning purposes.
@export var lil_guy_scene: PackedScene

@onready var spawn_area : Area2D = $lilguy_spawn/lilguy_spawn_area
@onready var spawn_area_label : RichTextLabel = $lilguy_spawn/lilguy_spawn_area/SpawnLabel
@onready var goal_label : RichTextLabel = $goal_zone/GoalLabel
var lil_guy: LilGuy

var goal_counter := 0
var lilguy_counter := 0 
var lilguys_melted := 0
var lilguys_max_to_lose := 0

func _ready():
	updateHud()
	lilguys_max_to_lose = lilguys_max_to_spawn - goal_min #determines fail state if too many lilguys melt
	SignalBus.goalCountUp.connect(goalStateCounter)
	SignalBus.meltCountUp.connect(meltCounter)
	
	spawn_area_label.install_effect(preload("res://wave_effect.gd").new())
	goal_label.install_effect(preload("res://wave_effect.gd").new())
	
	# We defer this because the tiles we need to inform are scene tiles,
	# which don't get instantiated until AFTER the TileMapLayer is ready.
	call_deferred("inform_tiles_of_light")

func _physics_process(_delta: float):
	#spawn lilguys when spawn zone is clear and lilguy max not reached
	if spawnZoneIsClear() && lilguy_counter < lilguys_max_to_spawn:
		spawnLilGuy()
		lilguy_counter += 1
		updateHud()
	#trigger game over / fail state when lost too many lilguys
	if lilguys_melted > lilguys_max_to_lose:
		loseState()
	
func spawnLilGuy():
	lil_guy = lil_guy_scene.instantiate()
	#NOTE: may not be needed, but instantiating lilguys with unique names based off the counter
	#could potentially have a use case in future scope?  otherwise TODO: delete me
	lil_guy.set_name("LilGuys_"+ str(lilguy_counter))
	#needed for lil_guy to detect lightsource
	lil_guy.init(sun)
	lil_guy.global_position = lilguy_spawn.global_position
	add_child(lil_guy)
	lil_guy.show()
	
func spawnZoneIsClear() -> bool:
	for area in spawn_area.get_overlapping_areas():
		if area.is_in_group("lilguys"):
			return false
	return true
	
func goalStateCounter():
	goal_counter += 1
	updateHud()
	if goal_counter == goal_min:
		if Global.Current_Level + 1 <= Global.LAST_LEVEL: #current max levels that exist
			SignalBus.loadVictory.emit() #victory screen
		else:
			SignalBus.loadCredits.emit() #credits upon finishing last level

func meltCounter():
	lilguys_melted += 1
	updateHud()
		
func loseState():
	SignalBus.loadGameOver.emit()
	
func updateHud():
	var goal_count = goal_min - goal_counter
	spawn_area_label.text = "[custom_wave]" + str(lilguys_max_to_spawn - lilguy_counter) + "[/custom_wave]"
	goal_label.text = "[custom_wave]" + str(goal_count if goal_count >= 0 else 0) + "[/custom_wave]"

## We have certain tiles built from Scenes, and some of them need to know about the level's light.
## Those Nodes are put into the "sighted_tiles" group so we can easily grab them after the fact here.
func inform_tiles_of_light() -> void:
	get_tree().set_group("sighted_tiles", "light", sun)
