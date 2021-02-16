extends Node2D

onready var player = $Player1
onready var rul = $StaticCanvas/Rul
onready var rultexture = rul.get_node("rul")
onready var pedals = $StaticCanvas/Pedals
onready var pedal1 = $StaticCanvas/Pedals/p1
onready var pedal2 = $StaticCanvas/Pedals/p2
onready var parking = $ParkingPlace/parkPlace
onready var fr = $Player1/fr
onready var fl = $Player1/fl
onready var rr = $Player1/rr
onready var rl = $Player1/rl

var settings
var autoRotateBack

var left = false
var right = false
var to_zero = false

var is_clicked_rul = false
var rul_idx = -1
var is_clicked_p1 = false
var p1_idx = -1
var is_clicked_p2 = false
var p2_idx = -1


# сигналы на поворот колес
signal PLAYER_RIGHT
signal PLAYER_LEFT
signal BACK_RUL

# скорость поворота колес
export var ROTATION_SPEED = 3
export var MOVE_SPEED = 200
export var ROTATION_MULTIPLER = 0.0005

func _ready():
	settings = load("user://Settings.tres")
	if !settings:
		settings = load("res://Settings.tres")
	autoRotateBack = settings.autoRotateBack
	
	connect("PLAYER_RIGHT", player, "rotate_to")
	connect("PLAYER_LEFT", player, "rotate_to")

	connect("PLAYER_RIGHT", rul, "rotate_to")
	connect("PLAYER_LEFT", rul, "rotate_to")

	connect("BACK_RUL", player, "back_rul")
	connect("BACK_RUL", rul, "back_rul")
	
	$StaticCanvas/MessageTimer.start()

	#TODO: удалить! для теста
	$PoliceCar.drive_along_path($PoliceCarPath/PoliceCarPathFollow)

func _input(event):
	
	# ввод с кнопок
	if event is InputEventKey:
		if event.pressed && event.scancode == KEY_ESCAPE:
			#get_tree().quit()
			get_tree().change_scene("res://MaiinMenu.tscn")
		if event.pressed && event.scancode == KEY_D:
			right = true
		elif event.scancode == KEY_D:
			right = false
		if event.pressed && event.scancode == KEY_A:
			left = true
		elif event.scancode == KEY_A:
			left = false
		if event.pressed && event.scancode == KEY_W:
			is_clicked_p2 = true
			p2_idx = -1
		elif event.scancode == KEY_W:
			is_clicked_p2 = false
		if event.pressed && event.scancode == KEY_S:
			is_clicked_p1 = true
			p1_idx = -1
		elif event.scancode == KEY_S:
			is_clicked_p1 = false
	if event is InputEventScreenTouch:
		if event.pressed:
			if rultexture.get_rect().has_point(rultexture.to_local(event.position)):
				is_clicked_rul = true
				rul_idx = event.index
			if pedal1.get_rect().has_point(pedal1.to_local(event.position)):
				is_clicked_p1 = true
				p1_idx = event.index
			if pedal2.get_rect().has_point(pedal2.to_local(event.position)):
				is_clicked_p2 = true
				p2_idx = event.index
		else:
			if is_clicked_rul && rul_idx == event.index:
				is_clicked_rul = false
				rul_idx = -1
			elif is_clicked_p2 && p2_idx == event.index:
				is_clicked_p2 = false
				p2_idx = -1
			elif is_clicked_p1 && p1_idx == event.index:
				is_clicked_p1 = false
				p1_idx = -1
		
	if event is InputEventMouseMotion && is_clicked_rul:
		var re = event.relative
		if re.x > 0:
			#right = true
			emit_signal("PLAYER_RIGHT", ROTATION_SPEED)
		elif re.x < 0:
			#left = false
			emit_signal("PLAYER_LEFT", -ROTATION_SPEED)

		
func _physics_process(delta):
	if right:
		emit_signal("PLAYER_RIGHT", ROTATION_SPEED)
	if left:
		emit_signal("PLAYER_LEFT", -ROTATION_SPEED)
	if !is_clicked_rul && !left && !right && autoRotateBack:
		emit_signal("BACK_RUL", ROTATION_SPEED)
		
	# газ
	if is_clicked_p2:
		player.rotate(rul.rotation_degrees * ROTATION_MULTIPLER)
		player.move_and_slide(Vector2(cos(player.rotation) * MOVE_SPEED, sin(player.rotation) * MOVE_SPEED))
		pedal2.scale = Vector2(0.25, 0.25)
	else:
		pedal2.scale = Vector2(0.3, 0.3)

	# тормоз
	if is_clicked_p1:
		player.rotate(rul.rotation_degrees * -ROTATION_MULTIPLER)
		player.move_and_slide(Vector2(cos(player.rotation) * -MOVE_SPEED, sin(player.rotation) * -MOVE_SPEED))
		pedal1.scale = Vector2(0.25, 0.25)
	else:
		pedal1.scale = Vector2(0.3, 0.3)

	var collisionCount = player.get_slide_count()
	if !$StaticCanvas/StolbikiLbl.visible && collisionCount > 0:
		$StaticCanvas/StolbikiLbl.visible = true
		$StaticCanvas/StolbikiLbl.text = "Ээээй!!! Осторожнее!"
	
	var parkpos = parking.global_position
	var rc = parking.get_rect()
	var gl1 = parking.to_global(rc.position)
	var gl2 = parking.to_global(rc.end)

	var frcoord = fr.global_position
	var flcoord = fl.global_position
	var rrcoord = rr.global_position
	var rlcoord = rl.global_position
	var num = 0
	if frcoord.x > gl1.x && frcoord.x < gl2.x && frcoord.y > gl1.y && frcoord.y < gl2.y:
		num = num + 1
	if flcoord.x > gl1.x && flcoord.x < gl2.x && flcoord.y > gl1.y && flcoord.y < gl2.y:
		num = num + 1
	if rrcoord.x > gl1.x && rrcoord.x < gl2.x && rrcoord.y > gl1.y && rrcoord.y < gl2.y:
		num = num + 1
	if rlcoord.x > gl1.x && rlcoord.x < gl2.x && rlcoord.y > gl1.y && rlcoord.y < gl2.y:
		num = num + 1
	if num == 4:
		if !$StaticCanvas/StolbikiLbl.visible:
			$StaticCanvas/StolbikiLbl.visible = true
			$StaticCanvas/StolbikiLbl.text = "Вроде, припарковался. Молоток."
		
	#TODO: тоже для теста. слежение за полицейской машиной
	#var img = $Camera2D.get_viewport().get_texture().get_data()
	#var tex = ImageTexture.new()
	#tex.create_from_image(img)
	#$StaticCanvas/Minimap.texture = tex
		
func _on_MessageTimer_timeout():
	$StaticCanvas/StolbikiLbl.visible = false
