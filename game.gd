extends Node2D

signal cherry_collected
signal game_ended
signal game_restarted

var score = 0

func _ready() -> void:
    cherry_collected.connect(_on_cherry_collected)
    game_ended.connect(_on_game_ended)
    game_restarted.connect(_on_game_restarted)
    $"CanvasLayer/Main Menu".show_start_menu()
    generate_cherry()
    
func _on_cherry_collected():
    score += 7
    %ScoreLabel.text = str(score)
    generate_cherry()
    
func get_occupied_positions() -> Array[Vector2]:
    var occupied: Array[Vector2] = []

    # Add head position
    occupied.append($Snake.head.position)

    # Add all tail positions
    for tail in $Snake.tails:
        occupied.append(tail.position)

    return occupied

func generate_cherry():
    const cherry_scene = preload("res://cherry.tscn")
    const TILESET_SIZE = 8

    var viewport_size = get_viewport_rect().size
    var max_x = int(viewport_size.x / TILESET_SIZE) - 2
    var max_y = int(viewport_size.y / TILESET_SIZE) - 2

    var occupied_positions = get_occupied_positions()
    var valid_position: Vector2
    var attempts = 0
    var max_attempts = 100

    # Keep trying until we find an unoccupied position
    while attempts < max_attempts:
        var x = randi_range(1, max_x)
        var y = randi_range(3, max_y)
        valid_position = Vector2(x * TILESET_SIZE, y * TILESET_SIZE)

        # Check if position is occupied
        var is_occupied = false
        for pos in occupied_positions:
            if pos.distance_to(valid_position) < 1.0:  # Same grid cell
                is_occupied = true
                break

        if not is_occupied:
            break

        attempts += 1

    var cherry = cherry_scene.instantiate()
    cherry.position = valid_position
    $Cherries.add_child(cherry)

func _on_game_ended():
    get_tree().paused = true
    $"CanvasLayer/Game Over Menu".visible = true
    
func _on_game_restarted():
    $Snake.reset()
    get_tree().paused = false
    $"CanvasLayer/Game Over Menu".visible = false

    var cherries = get_tree().get_nodes_in_group("cherries")
    for cherry in cherries:
        cherry.queue_free()
        
    generate_cherry()

func _input(event):
    if event.is_action_pressed("ui_cancel"):
        $"CanvasLayer/Main Menu".show_continue_menu()
