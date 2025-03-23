extends CharacterBody3D

@onready var Camera = $CameraPoint
@onready var GroundRay = $GroundCheck

var speed:float = 50
var speed_mod:float = 1
var free_fall_speed:float = 0

func _enter_tree() -> void:
	pass

func get_forward()-> Vector3:
	var cb:Basis = Camera.global_basis
	return cb.z

func get_right()-> Vector3:
	var cb:Basis = Camera.global_basis
	return cb.x

func _ready() -> void:
	set_process_input(true)

var baseVelocity:Vector3 = Vector3.ZERO
var move_vector = Vector3.ZERO
var inertion:float = .02
var _move_vector = Vector3.ZERO

var skip = 0

func pprint(v:Vector3) -> String:
	return "%+8.3f %+8.3f %+8.3f" % [v.x, v.y, v.z]

func _physics_process(delta: float) -> void:
	var jump = Input.is_action_just_pressed("ui_accept")
	var fwd = Input.get_axis("ui_up", "ui_down")
	var rgh = Input.get_axis("ui_left", "ui_right")
	var friction = .8
	
	if (!is_on_floor()):
		speed_mod = 1 if GroundRay.is_colliding() else .2
		free_fall_speed = max(-30, free_fall_speed - .9)
		friction = 1
	else:
		speed_mod = 1
		free_fall_speed = 0
	
	if (jump and (GroundRay.is_colliding() or is_on_floor())):
		free_fall_speed = 10
	
	_move_vector.z = max(-15, min(15, _move_vector.z + fwd * speed_mod))
	_move_vector.x = max(-15, min(15, _move_vector.x + rgh * speed_mod))
	
	if (fwd == 0):
		_move_vector.z *= friction
	if (rgh == 0):
		_move_vector.x *= friction
	
	if(_move_vector.length() < 0.001):
		_move_vector = Vector3.ZERO
	velocity.y = free_fall_speed
	
	var _spd = speed * delta
	
	if (_move_vector != Vector3.ZERO):
		var n = _move_vector.normalized()
		var l:float =  max(abs(_move_vector.x),  abs(_move_vector.z))
		var f:Vector3 = get_forward()  * n.z * .1
		var r:Vector3 = get_right() * n.x * .1
		
		#pprint((f + r).normalized())
		move_vector = _spd * (f + r).normalized() * l
		print(move_vector.length())
		#pprint(move_vector)
	
	#velocity = baseVelocity + move_vector
	if (move_vector != Vector3.ZERO):
		baseVelocity = velocity
		velocity = baseVelocity + move_vector
		move_and_slide()
		velocity = baseVelocity
		if(move_vector.length() < 0.01): move_vector = Vector3.ZERO
	else:
		move_and_slide()

func _input(event: InputEvent) -> void:
	
	if (event is InputEventMouseMotion):
		var input:InputEventMouseMotion = event as InputEventMouseMotion
