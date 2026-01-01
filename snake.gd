class_name Snake extends Node2D


const tail_scene = preload("res://tail.tscn")

const TILESET_SIZE = 8
const MOVE_DELAY = 0.05

var tails: Array[Node2D] = []

@onready var head = %Head;
@onready var move_timer = Timer.new()
@onready var last_position = head.position;

var start_position: Vector2;

func _ready() -> void:
	start_position = head.position
	
	reset_tail()
	add_child(move_timer)
	move_timer.wait_time = MOVE_DELAY
	move_timer.timeout.connect(_on_move_timer_timeout)
	move_timer.start()
	
	get_node("/root/Game").cherry_collected.connect(_on_cherry_collected)

func _on_cherry_collected():
	var last_tail = tails.back()
	var new_pos = last_tail.position + (Vector2.RIGHT * TILESET_SIZE)
	add_tail_at_pos(new_pos)

func _on_move_timer_timeout():
	var previous_head_position = head.position
	head.update_position()
	update_tail(previous_head_position)
	
func update_tail(previous_head_position: Vector2):
	for i in range(len(tails) - 1, -1, -1):
		var tail = tails[i]
		if i == 0:
			tail.position = previous_head_position
		else:
			tail.position = tails[i - 1].position

func reset():
	head.reset(start_position)
	reset_tail()

func reset_tail():
	for tail in tails:
		tail.queue_free()
	tails = []
	
	for i in range(4):
		add_tail_at_pos(head.position - (Vector2.RIGHT * TILESET_SIZE * (i + 1)))

func add_tail_at_pos(pos: Vector2) -> void:
	var tail = tail_scene.instantiate()
	tail.position = pos
	add_child(tail)
	tails.append(tail)
