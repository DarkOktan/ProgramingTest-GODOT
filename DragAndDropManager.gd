class_name DragAndDropManager
extends Node2D

static var _Instance : DragAndDropManager = null
static var GetInstance:
	get:
		return _Instance

func _init() -> void:
	_Instance = self

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Raycasting()
	pass


func Raycasting() -> void:
	var ray : RayCast2D = $RayCast2D
	ray.global_position = get_viewport().get_camera_2d().get_global_mouse_position()
	#ray.look_at(get_viewport().get_camera_2d().get_global_mouse_position())
	
	if Input.is_action_just_pressed("Click"):
		if ray.is_colliding():
			var collider = ray.get_collider()
			print("Ray Collide")
			#if collider && collider == WorldItemObject:
				#(collider as WorldItemObject).StartDragging()

func Testing():
	print("Testing")
