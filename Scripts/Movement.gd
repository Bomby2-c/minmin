extends CharacterBody3D


@export var SPEED: float = 5.0
@export var RotateSpeed: int
@export var Camera: Camera3D

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") * 2

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Calculate movement direction based on input
	var move_input: Vector2 = Vector2(
		Input.get_action_strength("Left") - Input.get_action_strength("Right"),
		Input.get_action_strength("Up") - Input.get_action_strength("Down")
	)

	# Get the camera's forward direction
	var camera_forward: Vector3 = -Camera.global_transform.basis.z
	camera_forward.y = 0  # Ensure it's horizontal
	camera_forward = camera_forward.normalized()

	# Calculate the movement direction in the camera's space
	var move_direction: Vector3 = camera_forward * move_input.y - Camera.global_transform.basis.x * move_input.x
	move_direction.y = 0  # Keep it in the horizontal plane
	move_direction = move_direction.normalized()

	# Look in move direction
	if velocity.length() > 0.2:
		var look_direction: Vector2 = Vector2(velocity.z, velocity.x)
		rotation.y = lerp_angle(rotation.y, look_direction.angle(), delta * RotateSpeed)

	# Actual movement
	if move_direction.length() > 0.1:
		$PlayerModel/AnimationPlayer.speed_scale = 1.5
		$PlayerModel/AnimationPlayer.play("Walk")
		velocity.x = move_direction.x * SPEED * delta
		velocity.z = move_direction.z * SPEED * delta
	else:
		$PlayerModel/AnimationPlayer.speed_scale = 1
		$PlayerModel/AnimationPlayer.play("Idle")
		velocity.x = 0
		velocity.z = 0

	# Move and slide
	move_and_slide()
