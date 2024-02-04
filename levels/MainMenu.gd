extends Control

func _on_quit_game_pressed():
	get_tree().quit()

func _on_start_game_pressed():
	get_tree().change_scene_to_file("res://Game.tscn")
