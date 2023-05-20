extends CharacterBody2D

signal died()

@export var speed := 100
@export var accel := 500

@export var input: PlayerInput
@export var anim: SpriteAnimTool
@export var hand: Hand

@export var cursor_root: Node2D
@export var sprite: Sprite2D
@export var spell_caster: SpellCaster

@export var chain: InputChain
@export var chain_inputs: Control
@export var thunderstorm_scene: PackedScene
@export var health: HealthBox

@export var teleport_cast: TeleportCast

@export var hit_sound: AudioStreamPlayer
@export var effect_player: AnimationPlayer
@export var cast_player: AnimationPlayer

@export var dissolve_texture: Texture2D

enum {
	CAST,
	MOVE,
	DEAD,
	WARP,
	SPAWN,
}

var thunderstorm_active = false
var state = SPAWN
var portal

func _ready():
	# in the final build, the texture does not exit for some reason
	var mat = sprite.material as ShaderMaterial
	mat.set_shader_parameter("dissolve_texture", dissolve_texture)
	
	effect_player.play("RESET")
	anim.play("RESET")
	health.health = GameManager.player_health
	for spell in GameManager.spells:
		chain.add_chain(spell.get_inputs(), spell.get_action())
		
	await anim.animation_finished
	anim.play("spawn")
	await anim.animation_finished
	state = MOVE

func _process(delta):
	if state == CAST or state == MOVE:
		var dir = global_position.direction_to(get_global_mouse_position())
		cursor_root.rotation = dir.angle()
		sprite.flip_h = dir.x < 0

func _physics_process(delta):
	if state == CAST:
		velocity = Vector2.ZERO
	elif state == MOVE:
		anim.start_play("move")
		var motion = Vector2(
			input.get_action_strength("move_right") - input.get_action_strength("move_left"),
			input.get_action_strength("move_down") - input.get_action_strength("move_up")
		)
		
		velocity = velocity.move_toward(motion * speed, accel * delta)
		move_and_slide()
	elif state == WARP:
		var target = portal.global_position
		var dir = target - global_position
		if dir.length() < 5:
			dir = Vector2.ZERO
		else:
			dir = dir.normalized()
		
		velocity = velocity.move_toward(dir * speed, accel * delta)
		move_and_slide()


func _on_player_input_just_pressed(ev: InputEvent):
	if state == MOVE:
		if ev.is_action("cast"):
			state = CAST
			anim.play("cast")
			cast_player.play("cast")
		elif ev.is_action("fire"):
			spell_caster.fire()
		elif ev.is_action("interact"):
			hand.interact()
	elif state == CAST:
		chain.handle_input(ev)

func _on_player_input_just_released(ev: InputEvent):
	if state == CAST and ev.is_action("cast"):
		var action = chain.get_chain_action()
		if action != null:
			match action:
				SpellResource.Action.THUNDERSTORM: _spawn_thunderstorm()
				SpellResource.Action.TELEPORT: teleport_cast.teleport()
				SpellResource.Action.FIREBALL: spell_caster.fireball()
			
			print("Action: %s" % SpellResource.Action.keys()[action])
			cast_player.play("activate")
		else:
			cast_player.play("stop_cast")
			
		for c in chain_inputs.get_children():
			chain_inputs.remove_child(c)
		state = MOVE

func _spawn_thunderstorm():
	if thunderstorm_active: return
	
	thunderstorm_active = true
	var node = thunderstorm_scene.instantiate()
	node.finished.connect(func(): thunderstorm_active = false)
	add_child(node)
	
func _on_health_died():
	input.disable()
	state = DEAD
	anim.play("died")
	await anim.animation_finished
	died.emit()


func _on_health_hit(dmg, knockback):
	velocity += knockback
	hit_sound.play()
	GameManager.reduce_hp(dmg)
	GameManager.frame_freeze(0.05, 1 if GameManager.player_health <= 0 else 0.2)
	
	effect_player.play("hit")


func _on_input_chain_pressed(input):
	if state == CAST:
		var tex = InputDirTexture.new()
		tex.input = input
		
		if chain_inputs.get_child_count() > 5:
			chain_inputs.remove_child(chain_inputs.get_child(0))
		chain_inputs.add_child(tex)


func _on_health_invincible_timeout():
	effect_player.play("RESET")


func _on_hand_interacted(obj):
	if obj is Portal:
		state = WARP
		portal = obj
		anim.play("warp")
	
func next_level():
	GameManager.next_level()
