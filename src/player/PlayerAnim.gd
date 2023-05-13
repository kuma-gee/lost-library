@tool
extends SpriteAnimTool

@export var sprite: NodePath

func update():
	add_animation(Builder.new(sprite).setName("move").setRange(0, 1).setDuration(0.4))
	add_animation(Builder.new(sprite).setName("idle").setRange(0, 0).setDuration(0.1))
	add_animation(Builder.new(sprite).setName("died").setRange(2, 3).setDuration(0.5).setLoop(false))
