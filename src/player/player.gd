extends CharacterBody2D

@export var speed := 100

@export var input: PlayerInput
@export var anim: SpriteAnimTool

@export var cursor_root: Node2D
@export var sprite: Sprite2D
@export var spell_caster: SpellCaster

func _ready():
	anim.start_play("move")

func _process(delta):
	var dir = global_position.direction_to(get_global_mouse_position())
	cursor_root.rotation = dir.angle()
	
	sprite.flip_h = dir.x < 0

func _physics_process(delta):
	var motion = Vector2(
		input.get_action_strength("move_right") - input.get_action_strength("move_left"),
		input.get_action_strength("move_down") - input.get_action_strength("move_up")
	)
	
	velocity = motion * speed
	move_and_slide()


func _on_player_input_just_pressed(ev: InputEvent):
	if ev.is_action("fire"):
		spell_caster.fire()
