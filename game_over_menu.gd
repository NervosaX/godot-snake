extends VisibleOnScreenNotifier2D

func _ready() -> void:
	screen_entered.connect(_on_screen_entered)
	%Restart.pressed.connect(_on_restart_pressed)
	%Quit.pressed.connect(_on_quit_pressed)

func _on_screen_entered() -> void:
	%Restart.grab_focus()

func _on_restart_pressed() -> void:
	get_node("/root/Game").game_restarted.emit()

func _on_quit_pressed() -> void:
	get_tree().quit()
