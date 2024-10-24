extends CharacterBody3D

var  tempMouseSens = 0.3

const SPRINTING_SPEED = 5.0
const WALKING_SPEED   = 3.0
const CROUCHING_SPEED = 1.5
const JUMP_VELOCITY   = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(event.relative.x * -tempMouseSens))
		$Head.rotate_x(deg_to_rad(event.relative.y * -tempMouseSens))
		$Head.rotation.x = clamp($Head.rotation.x,deg_to_rad(-89),deg_to_rad(89))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if Input.is_action_pressed("Sprint") && !Input.is_action_pressed("Crouch"):
		if direction:
			velocity.x = direction.x * SPRINTING_SPEED
			velocity.z = direction.z * SPRINTING_SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPRINTING_SPEED)
			velocity.z = move_toward(velocity.z, 0, SPRINTING_SPEED)
	elif Input.is_action_pressed("Crouch"):
		if direction:
			velocity.x = direction.x * CROUCHING_SPEED
			velocity.z = direction.z * CROUCHING_SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, CROUCHING_SPEED)
			velocity.z = move_toward(velocity.z, 0, CROUCHING_SPEED)
	else:
		if direction:
			velocity.x = direction.x * WALKING_SPEED
			velocity.z = direction.z * WALKING_SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, WALKING_SPEED)
			velocity.z = move_toward(velocity.z, 0, WALKING_SPEED)

	move_and_slide()
