extends Node3D

func _process(delta):
	rotate_x(2 * delta)
	rotate_y(1 * delta)
	rotate_z(-0.5 * delta)
