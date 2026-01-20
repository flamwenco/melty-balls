class_name LightDetector
extends RayCast2D


func _process(_delta: float) -> void:
	var in_light_color: Color = Color.RED
	var out_light_color: Color = Color.GREEN
	
	# DEBUG
	if Global.debug:
		$DebugLine.visible = true
		if is_colliding():
			$DebugLine.default_color = out_light_color
		else:
			$DebugLine.default_color = in_light_color
		$DebugLine.points = [position, target_position]
	else:
		$DebugLine.visible = false

func set_light_position(light_position: Vector2) -> void:
	target_position = to_local(light_position)
