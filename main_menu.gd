extends Node2D

func _ready() -> void:
    %Buttons.visibility_changed.connect(_on_visibility_changed)
    %Start.pressed.connect(_on_start_pressed)
    %Quit.pressed.connect(_on_quit_pressed)
    
func show_start_menu():
    %Start.text = "Start"
    _show_menu(true)
    
func show_continue_menu():
    %Start.text = "Continue"
    _show_menu(true)
    
func _show_menu(show: bool):
    visible = show
    get_tree().paused = show

    if show:
        get_node("/root/Game").game_paused.emit()
    else:
        get_node("/root/Game").game_unpaused.emit()
        
func _on_start_pressed() -> void:
    _show_menu(false)

func _on_quit_pressed() -> void:
    get_tree().quit()
    
func _on_visibility_changed():
    if  %Buttons.visible:
        %Start.grab_focus()
