extends Control

# Using an @export var gives an error when trying to add_child later... wtf
@onready var level_container := $MarginContainer/HBoxContainer/VBoxContainer

var level_directory := "res://Levels/"
var level_name_regex := RegEx.create_from_string("Level(\\d+).tscn")

func _ready() -> void:
	"""
	Dynamically loads all level scenes named in the standard way,
	and adds them to the list of buttons.
	"""
	
	# Uncomment to test without the adhoc node creation
	#return
	
	# We basically only care about the level numbers, because that's what the loader cares about
	var levels := get_level_nums()
	
	for level in levels:
		var level_node := Button.new()
		level_node.text = "Level %d" % level
		level_node.pressed.connect(_on_level_select_pressed.bind(level))
		level_container.add_child(level_node)
	
	hide()

func get_level_nums() -> Array[int]:
	var levels: Array[int] = []
	
	# There is a function DirAccess.get_files()
	# However, docs indicate that only returns imported resources.
	# So this kind of iteration is preferred.
	var dir = DirAccess.open(level_directory)
	if dir:
		dir.list_dir_begin()
		
		var file_name := dir.get_next()
		while file_name != "":
			var rmatch := level_name_regex.search(file_name)
			if !dir.current_is_dir() && rmatch:
				# Convert first capture group (the digit in the level path) to an int and store it
				levels.append(int(rmatch.get_string(1)))
			file_name = dir.get_next()
			
		dir.list_dir_end()
	
	levels.sort()
	return levels

func _on_level_select_pressed(level: int) -> void:
	hide()
	SignalBus.loadLevel.emit(level)
