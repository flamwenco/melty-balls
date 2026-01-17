class_name LilGuy
extends CharacterBody2D

@onready var sprite := $AnimatedSprite2D
@onready var light_detector: LightDetector = $LightDetector

var direction : float
var rotation_speed : float
var just_hit_wall : bool #could be used for an animation handler that will set this false after playing hitting-wall animation for 1-2 seconds

var light: PointLight2D

@export var percent_damaged_per_second: float = 15

func _ready():
	sprite.play("default")
	direction = 1 #right
	rotation_speed = 200.0
	
	$HealthBar.visible = false

func _process(_delta: float) -> void:
	if light:
		light_detector.set_light_position(light.global_position)

	# Add some logic to handle when our lil' guy is melting
	if not light_detector.is_colliding():
		$HealthBar.value -= percent_damaged_per_second * _delta
		$AnimatedSprite2D.play("melting")
	else:
		$AnimatedSprite2D.play("default")

	# Display and progress the progress bar
	if $HealthBar.value < 99:
		$HealthBar.visible = true

	if $HealthBar.value < 40:
		$HealthBar.tint_progress = Color(1, 0, 0)
	elif $HealthBar.value < 70:
		$HealthBar.tint_progress = Color(1, 1, 0)
	else:
		$HealthBar.tint_progress = Color(0, 1, 0)

func _physics_process(_delta : float) -> void:
	
	velocity.x = direction * Global.LILGUY_SPEED
	sprite.rotation_degrees += rotation_speed * _delta
	
	move_and_slide()
	
	if is_on_wall():
		direction *= -1
		rotation_speed *= -1
		
#TODO: should have an animation handler that takes in things like light_detection, hitting wall, etc.
#		then processes the correct animation the AnimatedSprite2D should be playing at any given time
