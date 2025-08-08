extends Node2D
var game_manager = GameManager


var scroll_bar
var done_button

func  _ready():
	scroll_bar = $ScrollContainer/_v_scroll
	done_button = $ScrollContainer/MarginContainer/Container/done
	scroll_bar.focus_mode = Control.FOCUS_ALL
	scroll_bar.step = game_manager.scroll_window_speed
	scroll_bar.grab_focus()
	done_button.focus_neighbor_right = NodePath(scroll_bar.get_path())
	scroll_bar.focus_neighbor_left = NodePath(done_button.get_path())




func _on_done_button_down():
	game_manager.play_sfx(game_manager.button_select)
	game_manager.change_scene(self,game_manager.level_select_screen)
