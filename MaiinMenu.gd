extends CanvasLayer

func _on_Exit_button_down():
	get_tree().quit()

func _on_NewSinglePlayerGame_button_down():
	get_tree().change_scene("res://Main.tscn")

func _on_NewPVP_button_down():
	pass
	
func _on_Options_button_down():
	get_tree().change_scene("res://Options.tscn")
