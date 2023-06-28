extends Node3D

@onready var nav_label := $MoveHereNode
@onready var player := $Player
#@onready var player_vars = get_node("/root/CowboyTest.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	#$Cowboy_Test.connect("nav_label", self, "on_nav_label")
	pass
	
func _process(delta):
	turn_face(player, 2.0, delta)
	
# Slowly rotate towards object in 3D space
func turn_face(target, rotationSpeed, delta):
	var global_pos = global_transform.origin
	var wtransform = global_transform.looking_at(Vector3(target.x,global_pos.y,target.z),Vector3(0,1,0))
	var wrotation = Quaternion(global_transform.basis).slerp(Quaternion(wtransform.basis), rotationSpeed*delta)

	global_transform = Transform3D(Basis(wrotation), global_transform.origin)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if "position" in player_vars.intersection:
#		nav_label.visible = true
#		return
#	nav_label.visible = false
	
#func on_nav_label():
#	if !"position" in intersection:
#		nav_label.visible = true
#		nav_label.global_position = intersection.position

#func _input(event):
#	if Input.is_action_just_pressed("Left_Mouse"):
#		if "position" in player_vars.intersection:
#			nav_label.global_position = player_vars.intersection.position
#			nav_label.visible = true
#		else:
#			nav_label.visible = false
			
