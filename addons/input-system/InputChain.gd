class_name InputChain
extends Node

signal pressed(input)

var valid_inputs = []
var chain = ChainNode.new("")
var active_chain = null

func handle_input(ev: InputEvent):
	var input = _find_input(ev)
	if input == null:
		print("invalid input: %s" % ev.as_text())
		return
	
	pressed.emit(input)
	
	var c = active_chain if active_chain != null else chain
	active_chain = c.find_child(input)
	print("Pressed %s chained to %s" % [ev.as_text(), active_chain])

func _find_input(ev: InputEvent):
	for i in valid_inputs:
		if ev.is_action_pressed(i):
			return i
	return null

func add_chain(inputs: Array[String], action):
	var curr = chain
	for input in inputs:
		if not input in valid_inputs:
			valid_inputs.append(input)
			
		var nextChain = curr.find_child(input)
		if nextChain:
			curr = nextChain
			continue
		
		var newChain = ChainNode.new(input)
		curr.children.append(newChain)
		curr = newChain
		
	curr.action = action

func get_chain_action():
	if active_chain == null:
		return null
	
	print("Active chain: %s" % active_chain)
	var action = active_chain.action
	active_chain = null
	return action

class ChainNode:
	var children: Array[ChainNode] = []
	var key: String
	var action
	
	func _init(key):
		self.key = key

	func find_for_event(ev: InputEvent):
		for child in children:
			if ev.is_action(child.key):
				return child
		return null

	func find_child(input: String):
		for child in children:
			if child.key == input:
				return child
		return null
		
	func _to_string():
		var c = []
		for child in children:
			c.append(child.key)
		return "%s: [%s]" % [key, ", ".join(c)]
