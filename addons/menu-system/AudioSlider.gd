class_name AudioSlider
extends HSlider

@export var bus_name := "Master"
@export var vol_range = 40
@export var vol_offset = 5

@export var hover_sound: AudioStreamPlayer

var master_id

func _ready():
	await owner.ready
	master_id = AudioServer.get_bus_index(bus_name)
	value_changed.connect(self._volume_changed)
	value = get_volume_percentage()
	
	mouse_entered.connect(_on_hover)
	focus_entered.connect(_on_hover)

func _on_hover():
	hover_sound.play()

func _volume_changed(v: float):
	if v == 0:
		AudioServer.set_bus_mute(master_id, true)
	else:
		AudioServer.set_bus_mute(master_id, false)
		AudioServer.set_bus_volume_db(master_id, get_volume(v))

func get_volume(percentage: float) -> float:
	var vol_value = -vol_range + (vol_range * percentage / 100) # Volume from -vol_range to 0
	vol_value += vol_offset
	return vol_value

func get_volume_percentage():
	var volume = AudioServer.get_bus_volume_db(master_id)
	return (volume - vol_offset + vol_range) * 100 / vol_range # Just reversed the equation of #get_volume
