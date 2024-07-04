extends StaticBody3D


@export var ray: RayCast3D
@export var shipParts: int
@export var end: Node2D
var object: Node3D

func _process(_delta):
	if ray.is_colliding():
		var collider = ray.get_collider()
		if collider and collider.is_in_group("Ship"):
			if(object != collider):
				collider.exit_all_pikmin()
				object = collider
				if(object):
					object.queue_free()
					object = null
					shipParts += 1
					if(shipParts == 7):
						end.get_child(0).play("fade")
						end.get_child(1).start()

