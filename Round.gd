extends RigidBody2D


export (int) var round_speed = 600

var shooter: Node
onready var map_limits = get_parent().get_map_limits()


func _ready():
	$ExplosionTimer.wait_time = $ExplosionParticles2D.lifetime


func _physics_process(_delta):
	process_map_limits()


func process_map_limits():
	if position.x < map_limits.position.x or position.x > map_limits.end.x or position.y < map_limits.position.y or position.y > map_limits.end.y:
		queue_free()


func shoot():
	visible = true
	sleeping = false
	apply_central_impulse(Vector2(cos(rotation - PI / 2), sin(rotation - PI / 2)) * round_speed)


func hit(_body, _shooter):
	sleeping = 1
	collision_layer = 0
	collision_mask = 0
	$RoundSprite.visible = false
	$Particles2D.visible = false
	$ExplosionParticles2D.emitting = true
	$ExplosionTimer.start()


func _on_Round_body_entered(body):
	if body.has_method("hit"):
		body.hit(self, shooter)
	hit(body, shooter)


func _on_ExplosionTimer_timeout():
	queue_free()
