extends RigidBody2D


var shooter: Node
onready var map_limits = get_parent().get_map_limits()


func _ready():
	$ExplosionTimer.wait_time = $ExplosionParticles2D.lifetime


func _physics_process(delta):
	process_map_limits()


func process_map_limits():
	if position.x < map_limits.position.x or position.x > map_limits.end.x or position.y < map_limits.position.y or position.y > map_limits.end.y:
		queue_free()


func shoot(position, direction, power):
	visible = true
	sleeping = false
	self.position = position
	self.rotation = direction
	apply_central_impulse(Vector2(cos(direction - PI / 2), sin(direction - PI / 2)) * power)


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
