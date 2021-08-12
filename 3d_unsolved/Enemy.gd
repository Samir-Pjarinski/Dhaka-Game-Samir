extends KinematicBody

## Todo - 
## Find a way to make the enemy jump (Gravity)

enum{
	IDLE
	ACTIVE
}

onready var nav = $"../Navigation" as Navigation
onready var player = $"../Player"
onready var raycast = $RayCast
onready var rof_timer = $Timer2
onready var eyes = $Eyes
onready var gun = $Gun

var path = []
var current_node = 0
var speed = 2
var can_shoot = true
var state = IDLE
var target
var direction = Vector3.ZERO
var velocity = Vector3.ZERO
var y_velocity = 0
var gravity = 20
var acceleration = 10
var dying = false
var timer = 10

export(PackedScene) var Bullet
export var muzzle_speed = 10
export var millis_between_shots = 1000
export var health = 2
export var TURN_SPEED = 2 

func _ready():
	rof_timer.wait_time = millis_between_shots / 1000.0

func _process(delta):
#	shoot($RayCast3/Muzzle)
#	print(path)

## with sight range
	match state:
		ACTIVE:
#			if path.size() < 8:
			if current_node < path.size() and dying == false:
				direction = path[current_node] - global_transform.origin
				if direction.length() < 1:
					current_node += 1
				else:
#					print("Dir: ", direction)
					move_and_slide(direction.normalized() * speed)
		#			pass

			if raycast.is_colliding() and dying == false:
				var aim_at = raycast.get_collider()
				if aim_at.is_in_group("Player"):
					shoot($RayCast/Muzzle)

			eyes.look_at(player.global_transform.origin, Vector3.UP)
			rotate_y(deg2rad(eyes.rotation.y * TURN_SPEED))

			if health == 0:
				dying = true

			if dying == true:
				timer -= 0.1
				$AnimationPlayer.play("Die")

			if timer <= 0:
				queue_free()

			if !is_on_floor():
				y_velocity += gravity * delta
			else:
				y_velocity = 0

			velocity = lerp(velocity, speed * direction, delta * acceleration)
			move_and_slide(velocity + Vector3.DOWN * y_velocity, Vector3.UP)

#			if path[0].y < -0.3:
#				y_velocity = -8

## without site range
#	if path.size() < 8:
#		if current_node < path.size():
#			var direction: Vector3 = path[current_node] - global_transform.origin
#			if direction.length() < 1:
#				current_node += 1
#			else:
#		#		print("Dir: ", direction)
#				move_and_slide(direction.normalized() * speed)
#		#		pass
#
#		if raycast.is_colliding():
#			var aim_at = raycast.get_collider()
#			if aim_at.is_in_group("Player"):
#				shoot($RayCast/Muzzle)
#
#			eyes.look_at(player.global_transform.origin, Vector3.UP)
#			rotate_y(deg2rad(eyes.rotation.y * TURN_SPEED))

#			if health == 0:
#				print("enemy died")
#				queue_free()

func update_path(target_point):
	path = nav.get_simple_path(global_transform.origin, target_point)


func _on_Timer_timeout():
	update_path(player.global_transform.origin)
	current_node = 0

func shoot(loc):
	if can_shoot:
		var bullet = Bullet.instance()
		bullet.global_transform = loc.global_transform
		bullet.bullet_speed = muzzle_speed
		var scene_root = get_parent().get_parent()
		scene_root.add_child(bullet)
#		print("pew")
		can_shoot = false
		rof_timer.start()
		gun.ap.play("shoot")

func minus_health(damage):
	health = health - damage
#	print(health)

func _on_Timer2_timeout():
	can_shoot = true

func _on_Sight_Range_body_entered(body):
	if body.is_in_group("Player"):
		state = ACTIVE
		print("entered")


func _on_Sight_Range_body_exited(body):
	if body.is_in_group("Player"):
		state = IDLE
		print("exited")


