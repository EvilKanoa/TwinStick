extends Area2D


signal round_fired(shooter, position, direction)

export (int) var fire_rate_rpm = 300
export (int) var clip_size = 15
export var ammo_name = ["Round", "Rounds"]

var reloading = false
var cooldown = false
var continue_firing = false

onready var current_ammo = clip_size
onready var sprite = $AnimatedSprite
onready var timer = $FiringTimer
onready var firing_position = $FiringPosition2D

func _ready():
	sprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")
	timer.connect("timeout", self, "_on_FiringTimer_timeout")
	timer.wait_time = 60.0 / fire_rate_rpm


func trigger(shooter) -> bool:
	if reloading or cooldown:
		continue_firing = true
		return false
	elif current_ammo == 0:
		reload()
		return false
	
	current_ammo -= 1
	cooldown = true
	timer.start()
	if sprite.animation != "firing":
		sprite.play("firing")
	emit_signal("round_fired", shooter, firing_position.global_position, firing_position.global_rotation)
	return true


func reload():
	if current_ammo == clip_size or reloading:
		return
	
	reloading = true
	cooldown = false
	current_ammo = clip_size
	sprite.play("reloading")
	timer.stop()


func get_ammo_count():
	if reloading:
		return "... / %03d" % clip_size
	else:
		return "%03d / %03d" % [current_ammo, clip_size]


func _on_AnimatedSprite_animation_finished():
	if sprite.animation == "reloading":
		reloading = false
		sprite.play("idle")
	elif sprite.animation == "firing" and not continue_firing:
		sprite.play("idle")


func _on_FiringTimer_timeout():
	cooldown = false
	if not continue_firing:
		sprite.play("idle")
	else:
		continue_firing = false
	if current_ammo == 0:
		reload()
