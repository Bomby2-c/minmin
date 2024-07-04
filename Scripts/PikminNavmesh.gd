extends CharacterBody3D

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var sh: Node3D = $StateHandler
@export var FollowTransform: Node3D = self
@export var AngularSpeed: float
@export var PlayerDistance: float
@export var Enabled: bool
@export var CurGoPos: Vector3
var FollowState: int
var AnimationOverride: String
var rng = RandomNumberGenerator.new()

var first = true
var speed = 100
var accel = 10
var current_location
var Distance = 0
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") * 2

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	current_location = global_transform.origin
	if(is_instance_valid(FollowTransform)):
		Distance = current_location.distance_to(FollowTransform.global_transform.origin)
	var next_location = nav.get_next_path_position()
	var new_velocity = (next_location - current_location) * speed * delta
	velocity = velocity.move_toward(new_velocity, 0.25)
	move_and_slide()

	if(FollowState == 0):
		if(Distance > PlayerDistance && Enabled && is_instance_valid(FollowTransform)):
			nav.target_position = FollowTransform.global_transform.origin
		else:
			nav.target_position = global_transform.origin
	elif(FollowState == 1):
		if(Enabled):
			nav.target_position = CurGoPos
	elif(FollowState == 2):
		if(!Enabled):
			if(is_instance_valid(FollowTransform)):
				global_transform.origin = FollowTransform.global_transform.origin
				global_rotation = FollowTransform.global_rotation

	if(velocity.length() > 0.1):
		if(AnimationOverride == ""):
			$minmin/AnimationPlayer.play("Walk")
		rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), delta * AngularSpeed)
	else:
		if(AnimationOverride == ""):
			$minmin/AnimationPlayer.play("Idle")
			
	if(AnimationOverride != ""):
		$minmin/AnimationPlayer.play(AnimationOverride)

func Call(player: Node3D, whistle: Node3D):
	AnimationOverride = ""
	FollowState = 0
	sh.Called(whistle)
	FollowTransform = player
	CurGoPos = player.global_transform.origin
	if(!first):
		$AudioStreamPlayer.play()
	first = false
	set_collision_mask_value(2, true)
	
func Send(Position: Node3D):
	$send.pitch_scale = rng.randf_range(0.8, 1.2)
	$send.play()
	AnimationOverride = ""
	FollowState = 1
	sh.CurState = sh.States.Sent
	CurGoPos = Position.global_transform.origin
	set_collision_mask_value(2, false)
	
func Carry(Position: Node3D):
	AnimationOverride = "Carry"
	set_collision_mask_value(2, true)
	FollowTransform = Position
	FollowState = 2
	sh.CurState = sh.States.Carry
	Position.get_parent().Failsafe(self)
	
func GoIdle():
	AnimationOverride = ""
	set_collision_mask_value(2, true)
	FollowState = 0
	FollowTransform = self
	sh.CurState = sh.States.Idle
	
func Attack(Enemy: Node3D):
	AnimationOverride = "walkAttack"
	set_collision_mask_value(2, true)
	FollowState = 0
	FollowTransform = Enemy
	sh.Attack(Enemy)
	sh.CurState = sh.States.Attack
