extends CharacterBody2D

@export_custom(PROPERTY_HINT_NONE, "suffix:px") var mouse_deadzone: int
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var max_speed_distance: int

@onready var sprite := $AnimatedSprite2D
var direction : float

func _ready():
	sprite.play("default")
	

func _physics_process(_delta: float) -> void:
	#get direction based on left or right being pressed
	#TODO: map mobile control buttons to these controls
	
	var multiplier := 1.0
	if Input.is_action_pressed("mouse_move"):
		var mouse_pos := get_global_mouse_position()
		var distance := mouse_pos.x - global_position.x
		if distance < mouse_deadzone * -1:
			Input.action_press("move_left")
			if distance > max_speed_distance * -1:
				multiplier = abs(distance / max_speed_distance)
		if distance > mouse_deadzone:
			Input.action_press("move_right")
			if distance < max_speed_distance:
				multiplier = abs(distance / max_speed_distance)

	direction = Input.get_axis("move_left", "move_right")
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		Input.action_release("move_left")
		Input.action_release("move_right")
		
	#movement
	if direction:
		velocity.x = direction * Global.PLAYER_SPEED * lerp_curve(multiplier)
	else:
		velocity.x = move_toward(velocity.x, 0, Global.FRICTION)
	
	if Input.is_action_pressed("slow_down"):
		velocity.x /= 2
	
	move_and_slide()

func lerp_curve(t: float) -> float:
	return t * t
