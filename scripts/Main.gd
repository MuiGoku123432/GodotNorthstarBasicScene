extends XROrigin3D

@onready var left_eye_viewport = $LeftEyeViewport/Viewport  # The actual viewport for the left eye
@onready var right_eye_viewport = $RightEyeViewport/Viewport  # The actual viewport for the right eye
@onready var post_process_viewport = $PostProcessViewport/Viewport  # The final viewport that combines both eyes

@onready var left_eye_texture_rect = $LeftEyeViewport/TextureRect  # The TextureRect under LeftEyeViewport
@onready var right_eye_texture_rect = $RightEyeViewport/TextureRect  # The TextureRect under RightEyeViewport
@onready var post_process_texture_rect = $PostProcessViewport/TextureRect  # The TextureRect under PostProcessViewport


func _ready():
	# Create the ViewportTexture for the left eye and assign it to the TextureRect
	var left_viewport_texture = ViewportTexture.new()
	left_viewport_texture.viewport = left_eye_viewport
	left_eye_texture_rect.texture = left_viewport_texture  # Set the TextureRect texture

	# Create the ViewportTexture for the right eye and assign it to the TextureRect
	var right_viewport_texture = ViewportTexture.new()
	right_viewport_texture.viewport = right_eye_viewport
	right_eye_texture_rect.texture = right_viewport_texture  # Set the TextureRect texture
	
	# Now handle the PostProcessViewport
	var post_process_viewport_texture = ViewportTexture.new()
	post_process_viewport_texture.viewport = post_process_viewport
	post_process_texture_rect.texture = post_process_viewport_texture  # Set the TextureRect for PostProcessViewport
