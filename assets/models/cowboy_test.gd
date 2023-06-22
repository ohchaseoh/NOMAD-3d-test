extends CharacterBody3D

@onready var navigation_agent := $NavigationAgent3D
@onready var camera := $PlayerCamera/Camera3D
@export var char_speed = 1.5
@export var char_speed_turn = 6
@export var camera_follow_speed = 0.1
@export var turn_speed = 0.1

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
	
func _physics_process(_delta):
	var camera_target = global_transform.origin + Vector3(0, 3, 4)
	camera.global_transform.origin = camera.global_transform.origin.lerp(camera_target, camera_follow_speed)
	
func move_to_point(_delta, speed):
	var target_pos = navigation_agent.get_next_path_position()
	var direction = global_position.direction_to(target_pos)
	face_direction(target_pos)
	velocity = direction * speed
	move_and_slide()
	
func shortest_angular_distance(angle1, angle2):
	var difference = fmod(angle2 - angle1, 2 * PI)
	if difference < -PI:
		difference += 2 * PI
	elif difference > PI:
			difference -= 2 * PI
	return difference

func face_direction(direction):
	var target_direction = Vector3(-direction.x, 0, -direction.z).normalized()
	var current_direction = Vector3(-transform.basis.z.x, 0, -transform.basis.z.z).normalized()

	var current_angle = atan2(current_direction.x, current_direction.z)
	var target_angle = atan2(target_direction.x, target_direction.z)
	
	var new_angle = current_angle + shortest_angular_distance(current_angle, target_angle)
	
	rotation.y = new_angle
	
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
		
		if "position" in result:
			navigation_agent.target_position = result.position
