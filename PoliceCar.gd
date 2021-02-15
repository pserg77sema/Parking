extends Car

enum DRIVE_MODE {STOP = 0, DRIVE_ALONG_PATH = 1}
var cur_mode = DRIVE_MODE.STOP

# для режима следования вдоль пути
var path_follow = null
var dal_points = 20.0
var dal_offset = 0
var dal_step = 0.0
var dal_next_point = Vector2(0, 0)
var dal_base_velocity = 100.0
var dal_delta = 150

func drive_along_path(pf):
	cur_mode = DRIVE_MODE.DRIVE_ALONG_PATH
	path_follow = pf
	dal_step = 1.0 / dal_points
	path_follow.unit_offset = 0
	dal_next_point = path_follow.position

func _ready():
	._ready()
	# сразу включаю мигалки
	$Migalka.play("Migalka")

func _move_to_point(pt):
	# 1. поворот колес в сторону точки
	
	# 1.1 Вектор направления машины
	var pl_direction = Vector2(cos(rotation), sin(rotation))

	# 1.2 Вектор к следующей точке
	var to_point = pt - position
	
	# 1.3 Угол, на который надо бы повернуться (радианы)
	# то есть, татраектория, на которую надо выйти
	var need_angle = pl_direction.angle_to(to_point)
	
	# поворот колес
	var r = rotate_to(rad2deg(need_angle) * 0.2)
	
	# и машины
	rotation_degrees += (r - basic_rotation) * 0.01
	
	# ну и едем
	pl_direction = Vector2(cos(rotation), sin(rotation))
	move_and_slide(pl_direction * 100)
	
	# 2.0 Достигли точки - дальше к следующей
	
	if Vector2(to_point).length() < dal_delta:
		if path_follow.unit_offset < 1:
			path_follow.unit_offset += dal_step
		else:
			path_follow.unit_offset = 0
		dal_next_point = path_follow.position

func _physics_process(delta):
	if cur_mode == DRIVE_MODE.DRIVE_ALONG_PATH:
		_move_to_point(dal_next_point)
	pass
