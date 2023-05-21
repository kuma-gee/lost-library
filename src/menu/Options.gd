extends Control

const CONFIG_FILE = "user://settings.cfg"

@export var _audio: AudioSettings
@export var _input: InputSettings

var _logger = Logger.new("Options")
var _config = ConfigFile.new()

func _ready():
	_load_settings()

func _load_settings():
	var error = _config.load(CONFIG_FILE)
	if error != OK:
		_logger.error("Failed to load settings: %s" % error)
		return
	
	_logger.debug("Loading settings")
	_audio.load_settings(_config)
	_input.load_settings(_config)

func _exit_tree():
	_save_config()

func _save_config():
	if Env.is_web(): return
	
	_logger.debug("Saving settings")
	_audio.save_settings(_config)
	_input.save_settings(_config)
	_config.save(CONFIG_FILE)


func _on_title_back_pressed():
	var cancel_event = InputEventAction.new()
	cancel_event.action = "ui_cancel"
	cancel_event.pressed = true
	Input.parse_input_event(cancel_event)
