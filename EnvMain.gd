extends Node2D

onready var gnd = $Ground
onready var wall = preload("res://Wall.tscn")

export var width = 0.1

func _ready():
	# подтягиваю полик площадки
	var groundPoly = gnd.polygon
	
	# и чуть захардкожу в плане границ полигона
	var minx = groundPoly[0].x
	var miny = groundPoly[0].y
	var maxx = groundPoly[2].x
	var maxy = groundPoly[2].y
	# центры стен тоже
	var minctx1 = minx + width
	var maxctx1 = maxx - width
	var mincty1 = miny + width
	var maxcty1 = maxy - width
	#var poly = Rect2()
	
	var poly = PoolVector2Array()
	
	# левая стена
	poly.append(Vector2(minx, miny))
	poly.append(Vector2(minx + width, miny))
	poly.append(Vector2(minx + width, maxy))
	poly.append(Vector2(minx, maxy))
	
	var wallLeft = wall.instance()
	wallLeft.get_node("Polygon2D").polygon = poly
	wallLeft.get_node("CollisionPolygon2D").polygon = poly
	$Ground.add_child(wallLeft)

	# правая стена
	poly.resize(0)
	poly.append(Vector2(maxx, miny))
	poly.append(Vector2(maxx, maxy))
	poly.append(Vector2(maxx - width, maxy))
	poly.append(Vector2(maxx - width, miny))
	
	wallLeft = wall.instance()
	wallLeft.get_node("Polygon2D").polygon = poly
	wallLeft.get_node("CollisionPolygon2D").polygon = poly
	$Ground.add_child(wallLeft)

	# верхняя стена
	poly.resize(0)
	poly.append(Vector2(minx + width, miny))
	poly.append(Vector2(maxx - width, miny))
	poly.append(Vector2(maxx - width, miny + width))
	poly.append(Vector2(minx + width, miny + width))
	
	wallLeft = wall.instance()
	wallLeft.get_node("Polygon2D").polygon = poly
	wallLeft.get_node("CollisionPolygon2D").polygon = poly
	$Ground.add_child(wallLeft)

	# нижняя стена
	poly.resize(0)
	poly.append(Vector2(minx + width, maxy - width))
	poly.append(Vector2(maxx - width, maxy - width))
	poly.append(Vector2(maxx - width, maxy))
	poly.append(Vector2(minx + width, maxy))
	
	wallLeft = wall.instance()
	wallLeft.get_node("Polygon2D").polygon = poly
	wallLeft.get_node("CollisionPolygon2D").polygon = poly
	$Ground.add_child(wallLeft)

