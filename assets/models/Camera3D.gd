extends Camera3D

@onready var camera_base := $PlayerCamera

# Called when the node enters the scene tree for the first time.
func _ready():
	look_at_from_position((Vector3.UP + (Vector3.BACK * sqrt(2))), get_parent().translation, Vector3.UP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
