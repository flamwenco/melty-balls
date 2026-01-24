extends StaticBody2D

@onready var sprite := $AnimatedSprite2D
@onready var light_detector: LightDetector = $LightDetector
@onready var collision := $CollisionShape2D
@export var light: Sun

var shaded: bool:
	get: return light_detector.is_colliding()

func _process(_delta: float) -> void:
	light_detector.set_light_position(light.global_position)
	
func _physics_process(_delta: float) -> void:
	if shaded:
		sprite.play("visible")
		collision.set_deferred("disabled", false) #enable collision
	else:
		sprite.play("invisible")
		collision.set_deferred("disabled", true) #disable collision
