extends Node2D

onready var basic_rotation = rotation_degrees
onready var cur_rotation = basic_rotation

var is_clicked = false

const accuracy = 2.0
func is_basic_rotation():
	return abs(cur_rotation - basic_rotation) < accuracy

func rotate_to(deg):

	cur_rotation += deg 
	if cur_rotation > basic_rotation + 45:
		cur_rotation = basic_rotation + 45
	elif cur_rotation < basic_rotation - 45:
		cur_rotation = basic_rotation - 45

	rotation_degrees = cur_rotation

func back_rul(deg):
	if !is_basic_rotation():
		var delta = cur_rotation - basic_rotation
		if delta > 0:
			rotate_to(-deg)
		else:
			rotate_to(deg)
