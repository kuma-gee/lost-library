extends CharacterBody2D

const U = "move_up"
const D = "move_down"
const L = "move_left"
const R = "move_right"

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
@export var chain_inputs: Control
@export var thunderstorm_scene: PackedScene
@export var health: HealthBox

@export var teleport_cast: TeleportCast

var thunderstorm_active = false
var casting = false
var stop = false

func _ready():
#	HP here does not matter anymore
#	health.health = GameManager.player_health
#	print("Init health ", GameManager.player_health)
	
	for spell in GameManager.spells:
		chain.add_chain(spell.get_inputs(), spell.get_action())

func _process(delta):
	if stop: return
	
	var dir = global_position.direction_to(get_global_mouse_position())
	cursor_root.rotation = dir.angle()
	
	casting = input.is_pressed("cast")
	sprite.flip_h = dir.x < 0

func _physics_process(delta):
	if stop: return
	
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
		for c in chain_inputs.get_children():
			chain_inputs.remove_child(c)
		
		var action = chain.get_chain_action()
		if action != null:
			match action:
				SpellResource.Action.THUNDERSTORM: _spawn_thunderstorm()
				SpellResource.Action.TELEPORT: teleport_cast.teleport()
				SpellResource.Action.FIREBALL: spell_caster.fireball()
			
			print("Action: %s" % SpellResource.Action.keys()[action])

func _spawn_thunderstorm():
	if thunderstorm_active: return
	
	thunderstorm_active = true
	var node = thunderstorm_scene.instantiate()
	node.finished.connect(func(): thunderstorm_active = false)
	add_child(node)
	
func _on_health_died():
	input.disable()
	stop = true
	anim.play("died")
	await anim.animation_finished
	died.emit()


func _on_health_hit(knockback):
	velocity += knockback
	GameManager.player_health = health.health
	GameManager.frame_freeze(0.05, 1 if GameManager.player_health <= 0 else 0.2)
	
	var mat = sprite.material as ShaderMaterial
	mat.set_shader_parameter("enable", true)
	await get_tree().create_timer(0.1).timeout
	mat.set_shader_parameter("enable", false)


func _on_input_chain_pressed(input):
	var tex = InputDirTexture.new()
	tex.input = input
	
	if chain_inputs.get_child_count() > 5:
		chain_inputs.remove_child(chain_inputs.get_child(0))
	chain_inputs.add_child(tex)
