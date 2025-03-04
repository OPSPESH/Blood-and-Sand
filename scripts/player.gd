extends Node

signal update

var health: int = 20
var speed = 400

func set_health(new_health):
	health = new_health
	update.emit()

func set_speed(new_speed):
	speed = new_speed
	update.emit()
