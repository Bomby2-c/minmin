extends CharacterBody3D

@export var MinminCarrying: Array[Node3D]
@export var CarryPositions: Array[Node3D]
@onready var nav: NavigationAgent3D = $NavigationAgent3D
@export var speed = 100
@export var CurGoPos: Node3D
@export var Cam: Camera3D
@onready var label: = $Label3D2
@export var minmintospawn: int
var accel = 15
var current_location
var Enabled = true

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 2

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	if(MinminCarrying.size() == CarryPositions.size()):
		nav.target_position = CurGoPos.global_transform.origin
		current_location = global_transform.origin
		var next_location = nav.get_next_path_position()
		var new_velocity = (next_location - current_location) * speed * delta
		velocity = velocity.move_toward(new_velocity, 0.25)
		if(Enabled):
			move_and_slide()
	else:
		nav.target_position = global_transform.origin
	
	label.text = str(MinminCarrying.size()) + "/" + str(CarryPositions.size())
	label.look_at(label.global_transform.origin + (label.global_transform.origin - Cam.global_transform.origin), Vector3.UP)

func _on_area_body_entered(body):
	if(body.is_in_group("Pikmin")):
		if(!MinminCarrying.has(body) && MinminCarrying.size() < CarryPositions.size()):
			if(body.sh.CurState == body.sh.States.Sent):
				MinminCarrying.append(body)
				body.Carry(CarryPositions[MinminCarrying.size() - 1])


func _on_area_body_exited(body):
	if(body.is_in_group("Pikmin")):
		if(MinminCarrying.has(body)):
			MinminCarrying.erase(body)
			body.velocity = Vector3.ZERO
			
func exit_all_pikmin():
	Enabled = false
	for item in MinminCarrying:
		if(MinminCarrying.has(item)):
			item.GoIdle()
			item.velocity = Vector3.ZERO
	for item in MinminCarrying:
		MinminCarrying.erase(item)
		
func Failsafe(body: Node3D):
	if(!MinminCarrying.has(body) && MinminCarrying.size() < CarryPositions.size()):
			MinminCarrying.append(body)
