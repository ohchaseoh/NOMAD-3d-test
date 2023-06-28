extends CharacterBody3D

@onready var navigation_agent := $Player/NavigationAgent3D
@onready var nav_label := $MoveHereNode
@onready var camera := $Player/PlayerCamera/Camera3D

@export var char_speed = 1.5
@export var char_speed_turn = 6
@export var camera_follow_speed = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Player/AnimationTree.set("parameters/conditions/idle", navigation_agent.is_navigation_finished())
	$Player/AnimationTree.set("parameters/conditions/walk", !navigation_agent.is_navigation_finished())
	if(navigation_agent.is_navigation_finished()):
		nav_label.visible = false
		return
	move_to_point(delta, char_speed)
	nav_label.visible = true
	
#func _physics_process(delta):
	#var camera_target = global_transform.origin + Vector3(0, 3, 1) # adjust offset as desired
	#camera.global_transform.origin = camera.global_transform.origin.lerp(camera_target, camera_follow_speed)
	
func move_to_point(_delta, speed):
	var target_pos = navigation_agent.get_next_path_position()
	var direction = global_position.direction_to(target_pos)
	velocity = direction * speed
	move_and_slide()
	
func _input(event):
	if Input.is_action_just_pressed("Left_Mouse"):
		var camera = get_tree().get_nodes_in_group("Camera")[0]
		var mouse_pos = get_viewport().get_mouse_position()
		var ray_length = 1000
		
		var ray_origin = camera.project_ray_origin(mouse_pos)
		var ray_end = ray_origin + camera.project_ray_normal(mouse_pos) * ray_length
		
		var space = get_world_3d().direct_space_state
		var ray_query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
		var intersection = space.intersect_ray(ray_query)
		print(intersection)
		
		if "position" in intersection:
			navigation_agent.target_position = intersection.position
			nav_label.global_position = navigation_agent.target_position
		
		if intersection != null:
			var pos = intersection.position
			$Player/Cowboy_Test.look_at(Vector3(pos.x, global_position.y, pos.z), Vector3(0, 1, 0))
			print("turning")
