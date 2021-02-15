extends KinematicBody2D

class_name Car

onready var fr = $fr
onready var fl = $fl

onready var basic_rotation = fr.rotation_degrees
onready var cur_rotation = basic_rotation

func rotate_to(deg):
	cur_rotation += deg
	if cur_rotation > basic_rotation + 45:
		cur_rotation = basic_rotation + 45
	elif cur_rotation < basic_rotation - 45:
		cur_rotation = basic_rotation - 45

	fr.rotation_degrees = cur_rotation
	fl.rotation_degrees = cur_rotation
	
	return cur_rotation
