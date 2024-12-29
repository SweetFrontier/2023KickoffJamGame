extends baseTrigger
class_name invisibleBlock

# Exported variable for controlling the opacity when the block is invisible.
@export var translucent_opacity = 0.3
@export var body : StaticBody2D
@export var implodeable_polygon: explodeablePolygon
@export var sound_child : AudioStreamPlayer2D

func _ready():
	super._ready()
	reset()

# Override the baseTrigger's react method to toggle visibility and collision.
func react():
	super.react()
	if !activated:
		activated = true
		# Implode the Block
		implodeable_polygon.implode()
		# Enable collision.
		body.enable()
		#play the boom sound
		sound_child.play()

func reset(state : int = 0):
	print_debug("THE INVISIBLE BLOCKS ARE NOT BOSS COMPATIBLE")
	super.reset(state)
	implodeable_polygon.reset()
	# Make the block translucent
	implodeable_polygon.color.a = translucent_opacity
	# Make sure there will be no collisions
	body.disable()
	if startActivated:
		react()
		if show_button:
			button_fade_timer = 0
			TriggerKeySprite.modulate.a = 0

func destroy():
	activated = true
	implodeable_polygon.reset()
	# Make the block translucent
	implodeable_polygon.color.a = translucent_opacity
	body.disable()
	button_fade_timer = 0
	if show_button:
		TriggerKeySprite.modulate.a = 0
