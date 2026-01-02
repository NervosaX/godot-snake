class_name Head extends CharacterBody2D

const TILESET_SIZE = 8

var direction = Vector2.RIGHT
var next_direction = Vector2.RIGHT

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
    next_direction = direction
    animated_sprite.play("right")
    
func update_input():
    if Input.is_action_pressed("ui_left"):
        next_direction = Vector2.LEFT
    elif Input.is_action_pressed("ui_right"):
        next_direction = Vector2.RIGHT
    elif Input.is_action_pressed("ui_down"):
        next_direction = Vector2.DOWN
    elif Input.is_action_pressed("ui_up"):
        next_direction = Vector2.UP        

func apply_next_direction():
    if next_direction != -direction:  # Prevent 180° turns
        direction = next_direction

        if direction == Vector2.LEFT:
            animated_sprite.play("left")
        elif direction == Vector2.RIGHT:
            animated_sprite.play("right")
        elif direction == Vector2.UP:
            animated_sprite.play("up")
        elif direction == Vector2.DOWN:
            animated_sprite.play("down")
            
func _on_area_entered(area: Area2D):
    if area.is_in_group("cherries"):
        $PickupPlayer.play()
        area.queue_free()
        get_node("/root/Game").cherry_collected.emit()
        
    if area.is_in_group("tails"):
        get_node("/root/Game").game_ended.emit()
    
