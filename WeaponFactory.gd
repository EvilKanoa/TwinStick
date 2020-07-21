extends Node


signal round_fired(round_node)

const weapons = {
	"pistol": preload("res://Pistol.tscn"),
	"minigun": preload("res://Minigun.tscn"),
}
const rounds = {
	"pistol": preload("res://PistolRound.tscn"),
	"minigun": preload("res://MinigunRound.tscn"),
}


func make_weapon(type):
	if not weapons.has(type):
		return null
	
	var weapon = weapons[type].instance()
	weapon.connect("round_fired", self, "_on_round_fired", [ type ])
	return weapon


func is_weapon(type):
	return weapons.has(type)


func _on_round_fired(shooter, position, direction, type):
	if not rounds.has(type):
		return
	
	var round_node = rounds[type].instance()
	round_node.shooter = shooter
	round_node.global_position = position
	round_node.global_rotation = direction
	round_node.shoot()
	emit_signal("round_fired", round_node)
