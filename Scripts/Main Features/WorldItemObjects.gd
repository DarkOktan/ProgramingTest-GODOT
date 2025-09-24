# Class digunakan untuk membuat fungsi dari Item yang telah di drop ke world object
# Seperti untuk menampilkan object, membuat feature drag on drop object

class_name WorldItemObjects
extends RigidBody2D

# Referensi dari Sprite 2D yang ada di Scene
# Digunakan untuk menampilkan Gambar dari item
@onready var DisplaySprite : Sprite2D = $"2DDisplay"

# Data item dari World Item
var item : ItemData = null
# Kondisi apakah world item ini sedang di drag
var isDraggingObject : bool = false

# Fungsi ini untuk mengset Instance item yang dibuat
func OnInit(item : ItemData) -> void:
	self.item = item
	DisplaySprite.texture = item.ItemTexture

# Fungsi ini berfungsi untuk mengecheck apakah drag and drop ke dalam UI Element (HUD_InventorySlot)
# dan mengset atau memasukkan World Item ini kedalam Container
func DropToUI() -> void:
	print("Drop Object")
	var mousePosition = get_viewport().get_mouse_position()  
	var ui_slots = get_tree().get_nodes_in_group("HUDInventorySlot")
	for groupSlot in ui_slots:
		var slot : HUDInventorySlot = groupSlot as HUDInventorySlot
		var control_global_pos = slot.get_global_position()
		var control_rect = Rect2(slot.global_position, slot.size)
		if control_rect.has_point(mousePosition):
			print("Dropped inside UI control")
			slot.NodeObjectDrop(self)
			return
		
	print("Dropped outside UI control")

# Untuk mengupdate posisi Object berdasarkan posisi dari mousenya ketika di drag
func _process(delta: float) -> void:
	if isDraggingObject:
		global_position = get_viewport().get_camera_2d().get_global_mouse_position()

# Untuk mengecheck apakah ada input dari mouse saat sedang menghover diatas World Object
# jika ada maka akan mulai drag, dan jika dilepas maka akan masuk drop
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		print("Input Mouse")
		if event.is_pressed():
			print("Start Dragging")
			isDraggingObject = true
		else:
			print("Drop")
			isDraggingObject = false
			DropToUI()

# Fungsi ketika Mouse menghover ke arah object
func _on_mouse_entered() -> void:
	if linear_velocity.length() < 0.1 && item.OnHoverWorldObjectEffect != null:
		item.OnHoverWorldObjectEffect.OnEffectExecuted(global_position, self)
	
