extends Control

@onready var main = get_tree().root.get_node("Main")
@onready var optionsMenu : Control = get_parent().get_node("OptionsMenu")
@onready var sound : AudioStreamPlayer = get_parent().get_node("ButtonSound")

@export var musicPlayer : AudioStreamPlayer
@export var screenCover : ColorRect
@export var screenCoverAnimation : AnimationPlayer

var pausable : bool = false

func _ready():
	optionsMenu.connect("close_settings", close_sound_settings)

func _on_start_button_pressed():
	sound.play()
	$VBoxContainer.visible = false
	get_tree().paused = false

func _on_restart_button_pressed():
	if (get_tree().paused and boss):
		# boss level, show conform screen
		$VBoxContainer.visible = false
		$DeathImage.visible = false
		$EscAnimatedSprite2D.visible = true
		$BackQuoteAnimatedSprite2D.visible = true
		$VBoxContainer/ResumeButton.disabled = false
		main.resetLevel()
		return
	restart()

func restart(from_beginning : bool = false):
	sound.play()
	$VBoxContainer.visible = false
	$DeathImage.visible = false
	$EscAnimatedSprite2D.visible = true
	$BackQuoteAnimatedSprite2D.visible = true
	$VBoxContainer/ResumeButton.disabled = false
	main.resetLevel()
	
	#if unpausing then close the optionsmenu and open this menu for the next time paused
	if (!get_tree().paused):
		visible = true
		optionsMenu.visible = false

func _on_settings_button_pressed() -> void:
	sound.play()
	optionsMenu.visible = true
	visible = false

func _on_quit_button_pressed():
	sound.play()
	musicPlayer.fadeOut()
	screenCover.show()
	screenCoverAnimation.play("FadeToBlack")
	await(screenCoverAnimation.animation_finished)
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Screens/MainMenu.tscn")

func _input(event: InputEvent) -> void:
	if event is InputEventKey and !event.is_echo():
		if event.keycode == KEY_ESCAPE and !$VBoxContainer/ResumeButton.disabled and pausable:
			if event.pressed:
				sound.play()
				$EscAnimatedSprite2D.frame = 1
				$VBoxContainer.visible = !$VBoxContainer.visible
				get_tree().paused = !get_tree().paused
				
				#if unpausing then close the optionsmenu and open this menu for the next time paused
				if (!get_tree().paused):
					visible = true
					optionsMenu.visible = false
			else:
				$EscAnimatedSprite2D.frame = 0
		if event.keycode == KEY_QUOTELEFT and event.pressed and pausable:
			$BackQuoteAnimatedSprite2D.frame = 1
			restart()
		else:
			$BackQuoteAnimatedSprite2D.frame = 0

func close_sound_settings():
	sound.play()
	visible = true

func set_pausability(pause : bool):
	pausable = pause
