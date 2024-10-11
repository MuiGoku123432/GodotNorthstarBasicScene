extends Node

@export var calibration_file: String = "res://CalibrationData/cameraCalibration.json"

@onready var left_eye_texture_rect = $"/root/ARCamerRig/LeftEyeViewport/TextureRect"
@onready var right_eye_texture_rect = $"/root/ARCamerRig/RightEyeViewport/TextureRect"

func _ready():
	load_calibration_data()

# Loads and applies calibration data from a JSON file.
func load_calibration_data():
	var file = FileAccess.open(calibration_file, FileAccess.READ)

	if file:
		var json_text = file.get_as_text()
		file.close()

		# Create an instance of the JSON parser and parse the content.
		var json = JSON.new()
		var parse_result = json.parse(json_text)

		if parse_result == OK:
			var data = json.data
			print("Parsed data: ", data)  # Debug print to inspect the JSON data
			
			# Accessing the first device's cameras (as an example).
			var left_camera = data["deviceCalibrations"][0]["cameras"][0]  # First camera (left)
			var right_camera = data["deviceCalibrations"][0]["cameras"][1]  # Second camera (right)

			# Extract the camera matrices for both eyes
			var left_camera_matrix = array_to_matrix(left_camera["cameraMatrix"])
			var right_camera_matrix = array_to_matrix(right_camera["cameraMatrix"])

			# Apply the matrices to the shaders on the TextureRects.
			apply_to_shaders(left_camera_matrix, left_camera_matrix, right_camera_matrix, right_camera_matrix)
		else:
			print("Failed to parse JSON data!")
	else:
		print("Calibration file not found!")

# Converts a flat array to a 4x4 matrix (using Transform3D).
func array_to_matrix(arr: Array) -> Transform3D:
	var matrix = Transform3D()
	matrix.basis.x = Vector3(arr[0], arr[1], arr[2])
	matrix.basis.y = Vector3(arr[3], arr[4], arr[5])
	matrix.basis.z = Vector3(arr[6], arr[7], arr[8])
	return matrix

# Applies the parsed matrices to the left and right eye shaders on the TextureRects.
func apply_to_shaders(left_x, left_y, right_x, right_y):
	# Retrieve the ShaderMaterial from the TextureRect's material property.
	var left_eye_material = left_eye_texture_rect.material as ShaderMaterial
	var right_eye_material = right_eye_texture_rect.material as ShaderMaterial
	
	if left_eye_material:
		left_eye_material.set("shader_param/uv_to_rect_x", left_x)
		left_eye_material.set("shader_param/uv_to_rect_y", left_y)
	
	if right_eye_material:
		right_eye_material.set("shader_param/uv_to_rect_x", right_x)
		right_eye_material.set("shader_param/uv_to_rect_y", right_y)
