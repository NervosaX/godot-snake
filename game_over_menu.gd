extends Node2D

func _ready() -> void:
    %Buttons.visibility_changed.connect(_on_visibility_changed)
    %Restart.pressed.connect(_on_restart_pressed)
    %Quit.pressed.connect(_on_quit_pressed)

func _on_restart_pressed() -> void:
    get_node("/root/Game").game_restarted.emit()

func _on_quit_pressed() -> void:
    get_tree().quit()

func _on_visibility_changed():
    if  %Buttons.visible:
        %ScoreLabel.text = "Score: " + str(get_node("/root/Game").score)
        %Restart.grab_focus()
