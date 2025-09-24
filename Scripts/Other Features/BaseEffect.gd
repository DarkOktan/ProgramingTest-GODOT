# Class ini berisikan Base Fungsi yang bisa digunakan untuk membuta variasi effect yang berbeda-beda
# contoh effect particle atau effect suara

class_name BaseEffect
extends Resource

# Fungsi yang akan dipanggil setiap ingin memulai effect
# akan berubah sesuai dengan derived class
func OnEffectExecuted(atPosition : Vector2, atNode : Node) -> void:
	pass

# Fungsi yang akan dipanggil untuk memunculkan text
# akan berubah sesuai dengan derived class
func OnEffectMessage(msg : String) -> void:
	print(msg)
