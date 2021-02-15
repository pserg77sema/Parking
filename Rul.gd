extends Node2D

onready var basic_rotation = rotation_degrees
onready var cur_rotation = basic_rotation

var is_clicked = false

func rotate_to(deg):

	cur_rotation += deg 
	if cur_rotation > basic_rotation + 45:
		cur_rotation = basic_rotation + 45
	elif cur_rotation < basic_rotation - 45:
		cur_rotation = basic_rotation - 45

	rotation_degrees = cur_rotation

