extends Node3D

@export var ray: RayCast3D
@export var timer: Timer
@export var Placer: Node3D
@export var PlaceRay: RayCast3D
@onready var seedy = preload("res://Scenes/seed.tscn")
var object: Node3D

func _process(_delta):
	$AnimationPlayer.play("Spin")
	if ray.is_colliding():
		var collider = ray.get_collider()
		if collider and collider.is_in_group("Carry"):
			if(object != collider):
				collider.exit_all_pikmin()
				object = collider
				PlantMinmin(collider.minmintospawn)
				timer.start()
	
	if(object):
		object.global_transform.origin = lerp(object.global_transform.origin, global_transform.origin, 0.1)
		object.scale = lerp(object.scale, Vector3.ZERO, 0.1)


func _on_timer_timeout():
	if(object):
		object.queue_free()
		object = null
		
func PlantMinmin(ammount: int):
	for i in range(ammount):
		var sed = seedy.instantiate()
		get_tree().get_root().get_child(0).add_child(sed)
		PlaceRay.force_raycast_update( )
		sed.global_transform.origin = PlaceRay.get_collision_point()
		Placer.rotate_y(95)
