extends Node2D

var game_manager = GameManager

#Options menu
@onready var ui_colorblind = $Options_menu/HBoxContainer/rightcontainer/ui_colorblind
@onready var ui_fullscreen = $Options_menu/HBoxContainer/rightcontainer/ui_fullscreen
@onready var ui_mute = $Options_menu/HBoxContainer/rightcontainer/ui_mute
@onready var ui_volume = $Options_menu/HBoxContainer/rightcontainer/MarginContainer/HSlider
@onready var volume_label = $"Options_menu/HBoxContainer/leftcontainer/volume label"
@onready var options_menu = $Options_menu
@onready var SFX_slider = $Options_menu/HBoxContainer/rightcontainer/MarginContainer/HSlider
@onready var music_volume_label = $"Options_menu/HBoxContainer/leftcontainer/music label"
@onready var music_slider = $"Options_menu/HBoxContainer/rightcontainer/musicslidercontainer/music slider"
@onready var overtime_display = $OvertimeStarDisplay
#@onready var sfx_generator = $SFX_Generator
@onready var start_button = $options/Start
@onready var ui_colorblind_button = $Options_menu/HBoxContainer/rightcontainer/ui_colorblind

@onready var endless_prep = $"Endless Prep"

@onready var main_menu = $options
@onready var title_label = $Title
var full_screen_index:int 
var is_game_mute:bool
var options_displayed:bool
# Called when the node enters the scene tree for the first time.
func _ready():
	overtime_display.visible = game_manager.highscore_lib.level_5_complete
	options_menu.visible = false
	setup_options()
	start_button.call_deferred("grab_focus")





#MAIN MENU
func _on_quit_button_down():
	game_manager.play_sfx(game_manager.button_select)
	get_tree().quit()
func _on_start_button_down():
	game_manager.play_sfx(game_manager.start_button_sfx)
	game_manager.change_scene(self, game_manager.level_select_screen)
func _on_credits_button_down():
	game_manager.play_sfx(game_manager.button_select)
	game_manager.change_scene(self, game_manager.credits_screen)
func _on_options_button_down():
	game_manager.play_sfx(game_manager.button_select)
	display_options()
func _on_endless_button_down():
	game_manager.endless_mode = true
	hide_start_menu()
	endless_prep.setup_prep(game_manager.prep_lib.endless_prep_data)
	game_manager.play_sfx(game_manager.button_select)
	#game_manager.change_scene(self, game_manager.endless_mode_prefab)



func display_options():
	options_displayed = !options_displayed
	if options_displayed == true:
		options_menu.visible = options_displayed
		main_menu.visible = !options_displayed
		title_label.visible = !options_displayed
		if game_manager.highscore_lib.level_5_complete:
			overtime_display.visible = !options_displayed
		ui_colorblind_button.grab_focus()

func hide_start_menu():
		main_menu.visible = false
		title_label.visible = false
		
func show_start_menu():
		main_menu.visible = true
		title_label.visible = true


#OPTIONS MENU
func _on_ui_colorblind_button_down():
	game_manager.play_sfx(game_manager.button_select)
	toggle_colorblind()
func _on_ui_fullscreen_button_down():
	game_manager.play_sfx(game_manager.button_select)
	cycle_fullscreen()
func _on_ui_mute_button_down():
	game_manager.play_sfx(game_manager.button_select)
	toggle_mute()
func _on_h_slider_value_changed(value):
	game_manager.change_volume(1,value)
func _on_music_slider_value_changed(value):
	game_manager.change_volume(2,value)
func _on_options_quit_button_down():
	game_manager.play_sfx(game_manager.button_select)
	options_displayed = !options_displayed
	if options_displayed == false:
		options_menu.visible = options_displayed
		main_menu.visible = !options_displayed
		title_label.visible = !options_displayed
	start_button.grab_focus()

func toggle_colorblind():
	game_manager.highscore_lib.colorblind_mode = !game_manager.highscore_lib.colorblind_mode
	if game_manager.highscore_lib.colorblind_mode:
		ui_colorblind.text = "ON"
	else:
		ui_colorblind.text = "OFF"
	#send to highscoure resource
	#game_manager.highscore_lib.colorblind_mode = 
	game_manager.save_game()
	
	
func cycle_fullscreen():
	print("cycling fullscreen index from: ",full_screen_index)
	if full_screen_index <2:
		full_screen_index +=1
	else:
		full_screen_index = 0
		
	print("to: ",full_screen_index)
	var fullscreen_text = "Fullscreen"
	
	match full_screen_index:
		0:#windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			fullscreen_text = "Windowed"
		1:#fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			fullscreen_text = "Fullscreen"
		2:#borderless
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			fullscreen_text = "Borderless"
	ui_fullscreen.text = fullscreen_text
	
	game_manager.highscore_lib.fullscreen = full_screen_index
	game_manager.highscore_lib.values_set = true
	#send to highscoure resource
	game_manager.save_game()


func toggle_mute():
	print("MUTING GAME")
	is_game_mute = !is_game_mute
	if is_game_mute:
		ui_mute.text = "ON"
		show_slider(false)
		game_manager.mute_audio()
	else:
		ui_mute.text = "OFF"
		show_slider(true)
		game_manager.unmute_audio()
	
#func change_volume(bus:int,amount:int):
	#print("CHANGING VOLUME BUS:", bus, " TO: ", amount)
	#AudioServer.set_bus_volume_db(bus,amount)
	#match  bus:
		#1:
			#game_manager.highscore_lib.sfx_volume = amount
		#2:
			#game_manager.highscore_lib.music_volume = amount
			#
	#game_manager.save_game()
	
func show_slider(slider_on:bool):
	ui_volume.visible = slider_on
	volume_label.visible = slider_on
	music_volume_label.visible = slider_on
	music_slider.visible = slider_on
		


func setup_options():
	var colorblind_text
	if game_manager.highscore_lib.colorblind_mode:
		colorblind_text = "ON"
	else:
		colorblind_text = "OFF"
	#set values
	ui_colorblind_button.text = colorblind_text
	
	match game_manager.highscore_lib.fullscreen:
		0:
			ui_fullscreen.text = "Windowed"
		1:
			ui_fullscreen.text = "Fullscreen"
		2:
			ui_fullscreen.text = "Borderless"
	full_screen_index = game_manager.highscore_lib.fullscreen
	if game_manager.highscore_lib.game_muted:
		ui_mute.text = "ON"
		show_slider(false)
		toggle_mute()
		SFX_slider.value = game_manager.highscore_lib.sfx_volume
		music_slider.value = game_manager.highscore_lib.music_volume
	else:
		ui_mute.text = "OFF"
		show_slider(true)
		SFX_slider.value = game_manager.highscore_lib.sfx_volume
		music_slider.value = game_manager.highscore_lib.music_volume




func reset_focus():
	start_button.grab_focus()






func _on_video_stream_player_finished():
	$VideoStreamPlayer.play()
