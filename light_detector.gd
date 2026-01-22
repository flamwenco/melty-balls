class_name LightDetector
extends RayCast2D


func set_light_position(light_position: Vector2) -> void:
	target_position = to_local(light_position)
