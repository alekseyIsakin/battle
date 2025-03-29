extends CharacterBody3D
class_name BaseEntity

var Navigation: RID
var player: CharacterBody3D
func _ready() -> void:
	var nav = get_tree().get_first_node_in_group("npc_navigation")
	player = get_tree().get_first_node_in_group("player")
	if (nav is not NavigationRegion3D): return
	
	Navigation = get_world_3d().get_navigation_map()

func _physics_process(delta: float) -> void:
	if not is_inside_tree():
		return
	
	var path: PackedVector3Array = NavigationServer3D.map_get_path(
		Navigation, 
		self.global_position, 
		player.global_position, 
		true)
	
	if (path.size() == 0): return
	var cur_p_index = 0
	if (global_transform.origin.distance_to(path[cur_p_index]) < .1):
		cur_p_index += 1
		if (cur_p_index >= path.size()):
			path = []
			cur_p_index = 0
			return
	
	var move_to = global_transform.origin.direction_to(path[cur_p_index]) * delta
	move_to *= 75
	velocity += move_to
	move_and_slide()
	velocity -= move_to
