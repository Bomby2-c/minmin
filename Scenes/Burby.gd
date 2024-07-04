extends CharacterBody3D

@onready var nav = $NavigationAgent3D
@onready var blood = preload("res://Scenes/prefabs/blood.tscn")
@export var visual_ray: RayCast3D
@export var raySpeed: float
@export var rayRange: float
@export var speed: float
@export var AngularSpeed: float
@export var Distancetoloose: float
@export var DistanceToBite: float
@export var BiteArea: Area3D
@export var Health: Node3D
var current_location
var FollowTransform
var Distance: float
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var time = 0
var startpos
var bite = false
var dead = false
var firstenable = false
var Currentvictim = null

func _ready():
	startpos = global_transform.origin
	nav.target_position = startpos


func _physics_process(delta):
	if(!dead):
		time += delta * raySpeed
		visual_ray.rotation.y = sin(time) * rayRange
		if visual_ray.is_colliding():
			var collider = visual_ray.get_collider()
			if collider and collider.is_in_group("Pikmin"):
				FollowTransform = collider

		if not is_on_floor():
			velocity.y -= gravity * delta
		current_location = global_transform.origin
		if(is_instance_valid(FollowTransform)):
			nav.target_position = FollowTransform.global_transform.origin
			Distance = current_location.distance_to(startpos)
		else:
			nav.target_position = startpos
		if(firstenable == true):
			var next_location = nav.get_next_path_position()
			var new_velocity = (next_location - current_location)
			velocity = new_velocity
			move_and_slide()
		
		if(velocity.length() > 0.5):
			if(!bite && !dead):
				$burbymodel/AnimationPlayer.play("Walk")
			rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), delta * AngularSpeed)
		else:
			if(!bite && !dead):
				$burbymodel/AnimationPlayer.play("Idle")
		
		if(Distance > Distancetoloose):
			if(is_instance_valid(FollowTransform)):
				FollowTransform = null
				visual_ray.enabled = false
				$Timer.start()
		if(is_instance_valid(FollowTransform)):
			if(current_location.distance_to(FollowTransform.global_transform.origin) < DistanceToBite):
				bite = true
				$burbymodel/AnimationPlayer.play("Bite")
				if($BiteColliderTimer.time_left <= 0):
					$BiteColliderTimer.start()
			else:
				bite = false
				
		firstenable = true

func _on_timer_timeout():
	visual_ray.enabled = true
	bite = false
	FollowTransform = null

func _on_bite_collider_timer_timeout():
	var bodies: Array[Node3D] = BiteArea.get_overlapping_bodies()
	var count = 0
	for item in bodies:
		if(item == FollowTransform):
			FollowTransform = null
			bite = false
		item.sh.die()
		count += 1
		if(count > 0):
			return

func _on_attackarea_body_entered(body):
	if(body.is_in_group("Pikmin")):
		if(body.sh.CurState == body.sh.States.Sent):
			body.Attack(self)
			Currentvictim = body
			$attacktimer.start($attacktimer.time_left + 0.30)
			if($attacktimer.time_left == 0):
				$attacktimer.start()

func die():
	if(!dead):
		$DeathTimer.start()
		dead = true
	$burbymodel/AnimationPlayer.play("Die")

func remove():
	var bloodeffect = blood.instantiate()
	get_tree().get_root().add_child(bloodeffect)
	bloodeffect.global_transform.origin = global_transform.origin
	bloodeffect.emitting = true
	queue_free()

func _on_attacktimer_timeout():
	if(is_instance_valid(Currentvictim)):
		FollowTransform = Currentvictim
