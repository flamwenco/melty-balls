class_name LilGuy
extends CharacterBody2D

@onready var sprite := $AnimatedSprite2D
@onready var light_detector: LightDetector = $LightDetector
@onready var healthbar := $HealthBar

var direction : float
var rotation_speed : float
var shrink_scale : float
var just_hit_wall : bool #could be used for an animation handler that will set this false after playing hitting-wall animation for 1-2 seconds

var light: PointLight2D

@export var percent_damaged_per_second: float = 15
@export var min_shrink_scale : float = 0.5

func _ready():
	sprite.play("default")
	direction = 1 #right
	rotation_speed = 200.0
	
	healthbar.visible = false

func _process(_delta: float) -> void:
	if light:
		light_detector.set_light_position(light.global_position)

	# Add some logic to handle when our lil' guy is melting
	if not light_detector.is_colliding():
		healthbar.value -= percent_damaged_per_second * _delta
		sprite.play("melting")
	else:
		sprite.play("default")

	# Display and progress the progress bar
	if healthbar.value < 99:
		healthbar.visible = true

	if healthbar.value < 40:
		healthbar.tint_progress = Color(1, 0, 0)
	elif healthbar.value < 70:
		healthbar.tint_progress = Color(1, 1, 0)
	else:
		healthbar.tint_progress = Color(0, 1, 0)
		
	# Shrink/"melt" with health progress
	shrink_scale = (healthbar.value / healthbar.max_value)
	# minimum size of shrink
	if shrink_scale <= min_shrink_scale: 
		shrink_scale = min_shrink_scale
	scale = Vector2 (shrink_scale, shrink_scale)
	
	#if health is zero, delete self
	if healthbar.value == 0:
		queue_free()

func _physics_process(delta : float) -> void:
	
	velocity.x = direction * Global.LILGUY_SPEED
	sprite.rotation_degrees += rotation_speed * delta
	
	#if not on floor, apply gravity to y
	if !is_on_floor():
		velocity.y += Global.GRAVITY * delta
	else:
		velocity.y = 0
	
	move_and_slide()
	#NOTE: wall check MUST happen after move_and_slide
	#otherwise get stuck on the wall due to order of physics processing
	if is_on_wall():
		direction *= -1
		rotation_speed *= -1
		
#TODO: should have an animation handler that takes in things like light_detection, hitting wall, etc.
#		then processes the correct animation the AnimatedSprite2D should be playing at any given time
