extends CanvasItem

class T:
	var a:int
	var b:float

var v:DebugVector = DebugVector.get_instance()

func _enter_tree() -> void:
	var p = self.get_parent().get_parent()
	#v.vectors.append(DebugVector.Vector.new(p, "move_vector", .2, 1., Color.RED ))
	pass

func _process(delta: float) -> void:
	queue_redraw()

func _init() -> void:
	
	#v.vectors.append(DebugVector.Vector.new(Camera, ))
	pass

func _draw():
	get_viewport()
	var camera = get_viewport().get_camera_3d()
	for vector in v.vectors:
		vector.draw(self, camera)
