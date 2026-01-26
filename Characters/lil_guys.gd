class_name LilGuy
extends RigidBody2D

var direction : float
var shrink_scale : float
var just_hit_wall : bool #could be used for an animation handler that will set this false after playing hitting-wall animation for 1-2 seconds
var initial_mass := mass

var light: Sun
var shaded: bool:
	get: return light_detector.is_colliding()

@export var percent_damaged_per_second: float = 15
@export var min_shrink_scale : float = 0.5

@export_group("Components")
@export var sprite: AnimatedSprite2D
@export var light_detector: LightDetector
@export var health_bar: = TextureProgressBar
@export var detection_shape: Area2D
@export var physics_shape: CollisionShape2D

func init(sun: Sun) -> void:
	light = sun

func _ready():
	sprite.play("default")
	direction = 1 #right
	
	health_bar.visible = false

func _physics_process(delta: float) -> void:
	light_detector.set_light_position(light.global_position)
	handle_health(delta)
	
	#detect if overlapping a goal zone
	for area in detection_shape.get_overlapping_areas():
		if area.is_in_group("goal"):
			goalReached()
			break
		if area.is_in_group("killzone"):
			health_bar.value = 0
			break
	#NOTE: wall check MUST happen after move_and_slide
	#otherwise get stuck on the wall due to order of physics processing
	#if is_on_wall():
		#direction *= -1
		#rotation_speed *= -1

func handle_health(delta: float) -> void:
	# Add some logic to handle when our lil' guy is meltingdelta
	if not shaded:
		health_bar.value -= percent_damaged_per_second * delta
		sprite.play("melting")
	else:
		sprite.play("default")

	# Display and progress the progress bar
	if health_bar.value < 99:
		health_bar.visible = true

	if health_bar.value < 40:
		health_bar.tint_progress = Color(1, 0, 0)
	elif health_bar.value < 70:
		health_bar.tint_progress = Color(1, 1, 0)
	else:
		health_bar.tint_progress = Color(0, 1, 0)
		
	# Shrink/"melt" with health progress
	shrink_scale = (health_bar.value / health_bar.max_value)
	# minimum size of shrink
	if shrink_scale <= min_shrink_scale: 
		shrink_scale = min_shrink_scale
	var scale_v := Vector2(shrink_scale, shrink_scale)
	sprite.scale = scale_v
	physics_shape.scale = scale_v
	detection_shape.scale = scale_v
	
	mass = initial_mass * shrink_scale
	
	#if health is zero, delete self, signal melt counter
	if health_bar.value == 0:
		SignalBus.meltCountUp.emit()
		queue_free()

func goalReached():
	SignalBus.goalCountUp.emit()
	queue_free()
#TODO: should have an animation handler that takes in things like light_detection, hitting wall, etc.
#		then processes the correct animation the AnimatedSprite2D should be playing at any given time
