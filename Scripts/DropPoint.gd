# Class ini digunakan untuk membuat fungsi dari Lokasi node yang dapat
# membuat Slot Item menjadi World Item

extends Control

# Set node ini sebagai tempat yang bisa di drop oleh item
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true

# Fungsi ini memiliki kegunaan untuk mengubah Slot item menjadi World Item
# Jika Mendrop di lokasi yang telah dimasukkan script ini
func _drop_data(at_position: Vector2, data: Variant) -> void:
	InventorySystem.GetInventorySystemInstance.OnDroppingItem(data)
