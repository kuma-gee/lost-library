extends CharacterBody2D

const U = "move_up"
const D = "move_down"
const L = "move_left"
const R = "move_right"

enum Action {
	THUNDERSTORM,
	FIREBALL,
	EARTHQUAKE,
	TELEPORT,
}

signal died()

@export var speed := 100
@export var accel := 500

@export var input: PlayerInput
@export var anim: SpriteAnimTool
@export var hand: Hand
@export var cast_circle: Sprite2D

@export var cursor_root: Node2D
@export var sprite: Sprite2D
@export var spell_caster: SpellCaster
@export var chain: InputChain

var casting = false

func _ready():
	chain.add_chain([U, D, U, L, R], Action.THUNDERSTORM)
	chain.add_chain([L, R, R, U, L], Action.FIREBALL)
	chain.add_chain([D, L, R, D, U], Action.EARTHQUAKE)
	chain.add_chain([R, L], Action.TELEPORT)

func _process(delta):
	var dir = global_position.direction_to(get_global_mouse_position())
	cursor_root.rotation = dir.angle()
	
	casting = input.is_pressed("cast")
	sprite.flip_h = dir.x < 0

func _physics_process(delta):
	if casting:
		anim.start_play("idle")
		cast_circle.visible = true
		velocity = Vector2.ZERO
	else:
		anim.start_play("move")
		cast_circle.visible = false
		var motion = Vector2(
			input.get_action_strength("move_right") - input.get_action_strength("move_left"),
			input.get_action_strength("move_down") - input.get_action_strength("move_up")
		)
		
		velocity = velocity.move_toward(motion * speed, accel * delta)
		move_and_slide()


func _on_player_input_just_pressed(ev: InputEvent):
	if not casting:
		if ev.is_action("fire"):
			spell_caster.fire()
		elif ev.is_action("interact"):
			hand.interact()
	else:
		chain.handle_input(ev)

func _on_player_input_just_released(ev: InputEvent):
	if ev.is_action("cast"):
		var action = chain.get_chain_action()
		if action != null:
			print("Action: %s" % Action.keys()[action])

func _on_health_died():
	input.disable()
	anim.play("died")
	await anim.animation_finished
	died.emit()


func _on_health_hit(knockback):
	velocity += knockback
