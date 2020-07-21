extends KinematicBody2D


class_name Player

export (SpriteFrames) var move_sprite_frames = null
export (SpriteFrames) var aim_sprite_frames = null
export (int, 3) var joy_device_id = 0
export (float, 1) var joy_deadzone = 0.30
export (int) var max_velocity = 250
export (int) var max_acceleration = 1100
export (float) var cutoff_velocity = 5
export (int) var friction = 700
export (float) var fire_rate = 10

const aim_ray_length := 4096
var cutoff_velocity_squared := pow(cutoff_velocity, 2)
var joy_connected := false
var input_move := Vector2()
var input_fire := Vector2()
var velocity := Vector2(0, 0)

onready var ammo_count = $AmmoCountLabel
onready var weapon_factory = get_parent().get_node("WeaponFactory")
onready var weapons = [
	weapon_factory.make_weapon("pistol"),
	weapon_factory.make_weapon("minigun"),
	weapon_factory.make_weapon("pistol"),
	weapon_factory.make_weapon("minigun"),
	#weapon_factory.make_weapon("shotgun"),
	#weapon_factory.make_weapon("launcher"),
]
onready var weapon = weapons[0]


func _ready():
	if move_sprite_frames != null:
		$MoveSprite.frames = move_sprite_frames
	if aim_sprite_frames != null:
		$AimSprite.frames = aim_sprite_frames
	add_child(weapon)


func _physics_process(delta):
	# Apply player accelration from input.
	velocity += input_move * max_acceleration * delta
	
	if input_move.length_squared() == 0 and velocity.length_squared() < cutoff_velocity_squared:
		velocity = Vector2(0, 0)
	else:
		velocity = velocity.clamped(max_velocity)
	
	# Apply friction if not inputting movement.
	if velocity.length_squared() > 0 and input_move.length_squared() == 0:
		velocity -= velocity.normalized() * friction * delta
	
	velocity = move_and_slide(velocity)
	
	if input_fire.length_squared() > 0:
		$AimRayCast2D.rotation = -rotation
		$AimRayCast2D.enabled = true
		$AimRayCast2D.cast_to = input_fire * aim_ray_length
	else:
		$AimRayCast2D.enabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	process_input()
	process_aim()
	ammo_count.text = weapon.get_ammo_count()
	ammo_count.set_rotation(-rotation)

func process_input():
	if not joy_device_id in Input.get_connected_joypads():
		if joy_connected:
			print("Joy device " + str(joy_device_id) + " is not connected")
			joy_connected = false
		input_move = Vector2(0, 0)
		input_fire = Vector2(0, 0)
		return
	elif not joy_connected:
		print("Joy device " + str(joy_device_id) + " has been connected")
		joy_connected = true
	
	input_move.x = Input.get_joy_axis(joy_device_id, JOY_AXIS_0)
	input_move.y = Input.get_joy_axis(joy_device_id, JOY_AXIS_1)
	input_fire.x = Input.get_joy_axis(joy_device_id, JOY_AXIS_2)
	input_fire.y = Input.get_joy_axis(joy_device_id, JOY_AXIS_3)
	
	if input_move.length() < joy_deadzone:
		input_move = Vector2(0, 0)
	if input_fire.length() < joy_deadzone:
		input_fire = Vector2(0, 0)
	
	input_fire = input_fire.normalized()
	
	if Input.is_joy_button_pressed(joy_device_id, JOY_DPAD_UP):
		set_weapon(weapons[0])
	elif Input.is_joy_button_pressed(joy_device_id, JOY_DPAD_RIGHT):
		set_weapon(weapons[1])
	elif Input.is_joy_button_pressed(joy_device_id, JOY_DPAD_DOWN):
		set_weapon(weapons[2])
	elif Input.is_joy_button_pressed(joy_device_id, JOY_DPAD_LEFT):
		set_weapon(weapons[3])


func process_aim():
	if input_fire.length_squared() > 0:
		rotation = input_fire.angle() + PI / 2
		$AimSprite.animation = "shooting"
		
		$AimRayLine2D.visible = true
		$AimRayLine2D.points[0] = Vector2.ZERO
		if $AimRayCast2D.is_colliding():
			$AimRayLine2D.points[1] = to_local($AimRayCast2D.get_collision_point()) - Vector2(0, -6)
			$ReticleSprite.global_position = $AimRayCast2D.get_collision_point()
			$ReticleSprite.visible = true
			if $AimRayCast2D.get_collider().collision_layer & 1:
				$ReticleSprite.animation = "filled"
			else:
				$ReticleSprite.animation = "empty"
		else:
			$AimRayLine2D.points[1] = Vector2(0, -aim_ray_length)
			$ReticleSprite.visible = false
		
		if weapon != null:
			weapon.trigger(self)
	else:
		$AimSprite.animation = "idle"
		$AimRayLine2D.visible = false
		$ReticleSprite.visible = false
	
	if input_move.length_squared() > 0:
		$MoveSprite.move(input_move.angle() + PI / 2 - rotation, input_move.length())
	else:
		$MoveSprite.idle()


func hit(body, shooter):
	print(str(shooter) + " shoot " + str(body) + "!")


func set_weapon(new_weapon):
	remove_child(weapon)
	weapon = new_weapon
	add_child(weapon)

