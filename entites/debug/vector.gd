class_name DebugVector

static var Instance:DebugVector

static func get_instance() -> DebugVector:
	if (Instance == null):
		Instance = DebugVector.new()
	return Instance

class Vector:
	var object:Node3D  # The node to follow
	var property:Vector3  # The property to draw
	var scale:float  # Scale factor
	var width:float  # Line width
	var color:Color  # Draw color

	func _init(_object:Node3D, _scale:float, _width:float, _color:Color):
		object = _object
		scale = _scale
		width = _width
		color = _color

	func draw(node:CanvasItem, camera:Camera3D):
		var start = camera.unproject_position(object.global_transform.origin)
		var end = camera.unproject_position(object.global_transform.origin + property * scale)
		node.draw_line(start, end, color, width)

var vectors: Array[Vector] = []  # Array to hold all registered values.
