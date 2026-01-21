class_name MeltyWall extends Node2D

const anim_name := &"melting"

@export var max_health := 100.0
var health: float
@export var percent_damaged_per_second: float

@export_group("Components")
@export var light_detector: LightDetector
@export var sprite: AnimatedSprite2D
@export var particles: GPUParticles2D
@export var occluder: LightOccluder2D

@onready var size := sprite.sprite_frames.get_frame_texture(anim_name, 0).get_size()
@onready var occ_top_left := Vector2(-size.x / 2, -size.y / 2)
@onready var occ_top_right := Vector2(size.x / 2, -size.y / 2)
@onready var occ_bot_left := occ_top_left
@onready var occ_bot_right := occ_top_right

var last_frame_idx: int = -1

var can_melt := false

var light: Sun:
	set(value):
		light = value
		light_detector.set_light_position(light.global_position)

var shaded: bool:
	get: return light_detector.is_colliding()

func _ready() -> void:
	health = max_health
	sprite.stop()
	sprite.frame = sprite.sprite_frames.get_frame_count(anim_name)
	particles.emitting = false

func _process(delta: float) -> void:
	
	# Hacky way to stop the weird issue where the wall would spawn with some damage already taken.
	# I'm guessing it has to do with the order things are instantiated,
	# so sometimes the raycast would spawn before occluders.
	if !can_melt:
		can_melt = true
		return
	
	handle_health(delta)
	particles.emitting = !shaded

func handle_health(delta: float) -> void:
	# When a melty wall is in light, it starts melting.
	# As it loses health, we switch to certain animation frames to depict various levels of melt.
	# At 0 - go away.
	
	# Return early so we're not running health calculations all the time.
	if shaded:
		return
	
	health -= percent_damaged_per_second * delta
	
	# If health is zero, delete self
	if health <= 0:
		queue_free()
		return
	
	# First determine how much health one frame represents
	var frame_count := sprite.sprite_frames.get_frame_count(anim_name)
	var health_interval := max_health / frame_count
	
	# Now we use integer division to determine which frame the current health value corresponds to.
	# Note that the animation frames were ordered in reverse to facilitate this match.
	# Subtract 1 because 0-indexing.
	var frame_idx := roundi(health / health_interval) - 1
	
	# Return early so we're not recalculating occlusion polygons all the time.
	if frame_idx == last_frame_idx:
		return
	
	sprite.frame = frame_idx
	last_frame_idx = frame_idx
	
	# Based on the number of frames and the height of the sprite,
	# calculate how far the occlusion polygon should extend down.
	# ASSUMES SQUARE SPRITE AND STATIC TOP EXTENT!
	var sprite_interval := size.y / frame_count
	var bottom_extent := (sprite_interval * frame_idx) - (size.y / 2)
	bottom_extent = clampf(bottom_extent, -size.y / 2, bottom_extent)
	occ_bot_left.y = bottom_extent
	occ_bot_right.y = bottom_extent
	
	var new_polygon: PackedVector2Array = PackedVector2Array([occ_top_left, occ_top_right, occ_bot_right, occ_bot_left])
	occluder.occluder.polygon = new_polygon
