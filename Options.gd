extends CanvasLayer

var settings

func _ready():
	settings = load("user://Settings.tres")
	if !settings:
		settings = load("res://Settings.tres")
	$CenterContainer/VBoxContainer/AutoRotateBack.pressed = settings.autoRotateBack
	print(settings)
	
func _on_Exit_button_down():
	settings.autoRotateBack = $CenterContainer/VBoxContainer/AutoRotateBack.pressed
	ResourceSaver.save("user://Settings.tres", settings)
	get_tree().change_scene("res://MaiinMenu.tscn")
