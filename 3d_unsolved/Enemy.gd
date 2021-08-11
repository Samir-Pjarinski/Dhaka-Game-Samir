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

export(PackedScene) var Bullet
export var muzzle_speed = 10
export var millis_between_shots = 1000
export var health = 20
export var TURN_SPEED = 2 

func _ready():
	rof_timer.wait_time = millis_between_shots / 1000.0

func _process(delta):
#	shoot($RayCast3/Muzzle)
#	print(path.size())

## with sight range
	match state:
		ACTIVE:
#			if path.size() < 8:
			if current_node < path.size():
				var direction: Vector3 = path[current_node] - global_transform.origin
				if direction.length() < 1:
					current_node += 1
				else:
		#			print("Dir: ", direction)
					move_and_slide(direction.normalized() * speed)
		#			pass

			if raycast.is_colliding():
				var aim_at = raycast.get_collider()
				if aim_at.is_in_group("Player"):
					shoot($RayCast/Muzzle)

			eyes.look_at(player.global_transform.origin, Vector3.UP)
			rotate_y(deg2rad(eyes.rotation.y * TURN_SPEED))

			if health == 0:
				print("enemy died")
				queue_free()

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
