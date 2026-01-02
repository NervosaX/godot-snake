class_name Snake extends Node2D

const tail_scene = preload("res://tail.tscn")

const TILESET_SIZE = 8
const MOVE_DELAY = 0.05

var tails: Array[Node2D] = []

@onready var head = %Head
@onready var move_timer = Timer.new()
@onready var start_position: Vector2 = head.position
@onready var head_target: Vector2 = head.position
@onready var reset_head_position: Vector2 = head.position

var interpolation_progress: float = 0.0
var tail_targets: Array[Vector2] = []

func _ready() -> void:

    reset_tail()
    add_child(move_timer)
    move_timer.wait_time = MOVE_DELAY
    move_timer.timeout.connect(_on_move_timer_timeout)
    move_timer.start()

    get_node("/root/Game").cherry_collected.connect(_on_cherry_collected)

func _process(delta: float) -> void:
    interpolation_progress = min(interpolation_progress + delta / MOVE_DELAY, 1.0)

    head.position = head.position.lerp(head_target, interpolation_progress)

    for i in range(tails.size()):
        tails[i].position = tails[i].position.lerp(tail_targets[i], interpolation_progress)

    if interpolation_progress >= 1.0:
        check_collisions()

func _on_cherry_collected():
    var last_tail = tails.back()
    if not last_tail:
        return
    var new_pos = last_tail.position + (Vector2.RIGHT * TILESET_SIZE)
    add_tail_at_pos(new_pos)
    tail_targets.append(new_pos)

func _on_move_timer_timeout():
    interpolation_progress = 0.0
    
    head.apply_next_direction()

    var previous_head_position = head.position
    head_target = head.position + (head.direction * TILESET_SIZE)

    update_tail_targets(previous_head_position)

func update_tail_targets(previous_head_position: Vector2):
    for i in range(len(tails) - 1, -1, -1):
        if i == 0:
            tail_targets[i] = previous_head_position
        else:
            tail_targets[i] = tail_targets[i - 1]

func reset():
    head.reset(reset_head_position)
    head_target = head.position + (Vector2.RIGHT * TILESET_SIZE)
    reset_tail()

func reset_tail():
    for tail in tails:
        tail.queue_free()

    tails = []
    tail_targets = []

    for i in range(4):
        var pos = head.position - (Vector2.RIGHT * TILESET_SIZE * (i + 1))
        add_tail_at_pos(pos)
        tail_targets.append(pos)

func add_tail_at_pos(pos: Vector2) -> void:
    var tail = tail_scene.instantiate()
    tail.position = pos
    add_child(tail)
    tails.append(tail)
    
func check_collisions():
    var overlapping_areas = head.detection_area.get_overlapping_areas()
    for area in overlapping_areas:
        if area.is_in_group("cherries"):
            area.queue_free()
            get_node("/root/Game").cherry_collected.emit()
        elif area.is_in_group("tails"):
            get_node("/root/Game").game_ended.emit()
