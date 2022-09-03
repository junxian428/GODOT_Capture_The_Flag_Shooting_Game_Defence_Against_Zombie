extends CanvasLayer


func _on_PlayButton_pressed() -> void:
	get_tree().change_scene("res://Main.tscn")


func _on_QuitButton_pressed() -> void:
	get_tree().quit()




func _on_PlayButton2_pressed():
	get_tree().change_scene("res://Network_setup.tscn")
