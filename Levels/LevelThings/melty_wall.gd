class_name MeltyWall extends Node2D

@export var max_health := 100.0
var health: float
@export var percent_damaged_per_second: float

@export_group("Components")
@export var light_detector: LightDetector
@export var sprite: AnimatedSprite2D
@export var particles: GPUParticles2D

var light: Sun:
	set(value):
		light = value
		light_detector.set_light_position(light.global_position)

var shaded: bool:
	get: return light_detector.is_colliding()

const anim_name := &"melting"

func _ready() -> void:
	health = max_health
	sprite.stop()
	sprite.frame = 0
	particles.emitting = false

func _process(delta: float) -> void:
	handle_health(delta)
	particles.emitting = !shaded

func handle_health(delta: float) -> void:
	# When a melty wall is in light, it starts melting.
	# As it loses health, we switch to certain animation frames to depict various levels of melt.
	# At 0 - go away.
	
	if not shaded:
		health -= percent_damaged_per_second * delta
	
	# First determine how much health one frame represents
	var frame_count := sprite.sprite_frames.get_frame_count(anim_name)
	var interval := max_health / frame_count
	
	# Now we use integer division to determine which frame the current health value corresponds to.
	# Note that the animation frames were ordered in reverse to facilitate this match.
	# Subtract 1 because 0-indexing.
	var frame_idx = int(health / interval) - 1
	sprite.frame = frame_idx
	
	# If health is zero, delete self
	if health <= 0:
		queue_free()
