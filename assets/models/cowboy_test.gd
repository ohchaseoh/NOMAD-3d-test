extends CharacterBody3D

@onready var navigation_agent := $NavigationAgent3D
var char_speed = 1.5
var char_speed_turn = 6

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimationTree.set("parameters/conditions/idle", navigation_agent.is_navigation_finished())
	$AnimationTree.set("parameters/conditions/walk", !navigation_agent.is_navigation_finished())
	if(navigation_agent.is_navigation_finished()):
		return
	move_to_point(delta, char_speed)
	
	
func move_to_point(delta, speed):
	var target_pos = navigation_agent.get_next_path_position()
	var direction = global_position.direction_to(target_pos)
	face_direction(target_pos)
	velocity = direction * speed
	move_and_slide()
	
func face_direction(direction):
	look_at(Vector3(-direction.x, global_position.y, -direction.z), Vector3.UP)
	
func _input(event):
	if Input.is_action_just_pressed("Left_Mouse"):
		var camera = get_tree().get_nodes_in_group("Camera")[0]
		var mouse_pos = get_viewport().get_mouse_position()
		var ray_length = 100
		var from = camera.project_ray_origin(mouse_pos)
		var to = from + camera.project_ray_normal(mouse_pos) * ray_length
		var space = get_world_3d().direct_space_state
		var ray_query = PhysicsRayQueryParameters3D.new()
		
		ray_query.from = from
		ray_query.to = to
		var result = space.intersect_ray(ray_query)
		print(result)
		
		navigation_agent.target_position = result.position
