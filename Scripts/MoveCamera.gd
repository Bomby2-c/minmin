extends Node3D

@export var Player: Node3D
var CurrentGoToRot: float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = Player.position
	if(Input.is_action_just_pressed("MiddleClick")):
		CurrentGoToRot = Player.rotation.y
	rotation.y = lerp_angle(rotation.y, CurrentGoToRot, delta * 10)
