extends Node2D

signal cherry_collected
signal game_ended
signal game_restarted

func _ready() -> void:
	cherry_collected.connect(_on_cherry_collected)
	game_ended.connect(_on_game_ended)
	game_restarted.connect(_on_game_restarted)
	$"Main Menu".show_start_menu()
	generate_cherry()
	
func _on_cherry_collected():
	generate_cherry()

func generate_cherry():
	const cherry_scene = preload("res://cherry.tscn")
	
	var cherry = cherry_scene.instantiate()

	add_child(cherry)

	var viewport_size = get_viewport_rect().size
	
	var x = randi_range(1, (viewport_size.x / 8) - 2)
	var y = randi_range(1, (viewport_size.y / 8) - 2)
	
	cherry.position = Vector2(x * 8, y * 8)

func _on_game_ended():
	get_tree().paused = true
	$"Game Over Menu".visible = true
	
func _on_game_restarted():
	$Snake.reset()
	
	get_tree().paused = false
	$"Game Over Menu".visible = false


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		$"Main Menu".show_continue_menu()
