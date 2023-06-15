extends Navigation

@export var character_path: NodePath: NodePath
var character: CharacterBody3D

var path: PackedVector3Array
var path_index: int = 0

var speed: float = 4.0

func _ready():
	
	character = get_node(character_path)

func _process(delta):
	if path_index < path.size():
		var distance_to_next = character.position.distance_to(path[path_index])
		if distance_to_next < 0.5:
			path_index += 1
		else:
			var direction = (path[path_index] - character.position).normalized()
			var velocity = direction * speed
			character.set_velocity(velocity)
			character.move_and_slide()
			character.velocity

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var viewport = get_viewport()
		var from = viewport.get_camera_3d().project_ray_origin(event.position)
		var to = from + viewport.get_camera_3d().project_ray_normal(event.position) * 1000
		var space_state = get_world_3d().direct_space_state
		var result = space_state.intersect_ray(from, to)
		if result:
			path = get_simple_path(character.position, result.position)
			path_index = 0
