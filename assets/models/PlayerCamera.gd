extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	translation = lerp(translation, player.translation, char_speed * delta)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
