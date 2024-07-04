extends Area3D

@export var Cam: Camera3D
@export var Player: Node3D
@export var MinMen: Array[Node3D]
@export var whissfx: AudioStreamPlayer
var Enabled: bool = true

func _process(_delta):
	if(Enabled):
		var MousePos = get_viewport().get_mouse_position()
		var RayLength = 40
		var from = Cam.project_ray_origin(MousePos)
		var to = from + Cam.project_ray_normal(MousePos) * RayLength
		var space = get_world_3d().direct_space_state
		var rayQuery = PhysicsRayQueryParameters3D.new()
		rayQuery.from = from
		rayQuery.to = to
		rayQuery.collision_mask = 0b00010000
		var result = space.intersect_ray(rayQuery)
	
		if(result):
			position = result.position
			visible = true
		else:
			visible = false
			whissfx.stop()
		if(Input.is_action_pressed("RightClick") && result):
			scale = lerp(scale, Vector3(5, 1, 5), 0.1)
			$CollisionShape3D.shape.height = 5
			if(!whissfx.playing):
				whissfx.play()
		else:
			scale = lerp(scale, Vector3(1, 0.2, 1), 0.1)
			$CollisionShape3D.shape.height = 0
			whissfx.stop()
		
		if(Input.is_action_just_released("LeftClick") && visible):
			if(MinMen.size() != 0):
				if(is_instance_valid(MinMen[0])):
					MinMen[0].Send(self)
					MinMen.pop_front()
				else:
					MinMen.pop_front()
					
		if(Input.is_action_pressed("regroup")):
			for minny in MinMen:
				if(is_instance_valid(minny)):
					remove_minmin(minny)
					minny.GoIdle()
			MinMen.clear()
	else:
		whissfx.stop()

func _on_body_entered(body):
	if(Input.is_action_pressed("RightClick")):
		if(body.has_method("Call")):
			if(!MinMen.has(body)):
				body.Call(Player, self)
				MinMen.append(body)

func remove_minmin(body: Node3D):
	if(MinMen.has(body)):
		MinMen.erase(body)

func add_minmin(body: Node3D):
	if(body.has_method("Call")):
		if(!MinMen.has(body)):
			body.Call(Player, self)
			MinMen.append(body)
