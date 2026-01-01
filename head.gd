class_name Head extends CharacterBody2D

const TILESET_SIZE = 8

var direction = Vector2.RIGHT

@onready var animated_sprite = %AnimatedSprite2D
@onready var detection_area = $AreaCollision

func _ready() -> void:
	detection_area.area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	update_input()
	move_and_collide(Vector2.ZERO)
	
func reset(start_position: Vector2):
	position = start_position
	direction = Vector2.RIGHT
	animated_sprite.play("right")
	
func update_position():
	var motion = direction * TILESET_SIZE
	move_and_collide(motion)
	
func update_input():
	var next_direction = direction
	
	if Input.is_action_pressed("ui_left"):
		animated_sprite.play("left")
		next_direction = Vector2.LEFT
	elif Input.is_action_pressed("ui_right"):
		animated_sprite.play("right")
		next_direction = Vector2.RIGHT
	elif Input.is_action_pressed("ui_down"):
		animated_sprite.play("down")
		next_direction = Vector2.DOWN
	elif Input.is_action_pressed("ui_up"):
		animated_sprite.play("up")
		next_direction = Vector2.UP
	
	if next_direction != -direction:
		direction = next_direction

func _on_area_entered(area: Area2D):
	if area.is_in_group("cherries"):
		area.queue_free()
		get_node("/root/Game").cherry_collected.emit()
		
	if area.is_in_group("tails"):
		get_node("/root/Game").game_ended.emit()
	
