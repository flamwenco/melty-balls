class_name LightDetector
extends RayCast2D


@export var light: PointLight2D


func _process(_delta: float) -> void:
	target_position = to_local(light.global_position)
	
	var in_light_color: Color = Color.RED
	var out_light_color: Color = Color.GREEN
	if is_colliding():
		$DebugLine.default_color = out_light_color
	else:
		$DebugLine.default_color = in_light_color
	
	# DEBUG
	$DebugLine.points = [position, target_position]
	
