# Class ini adalah container untuk Slot Inventory selama Runtime
# Seperti ID, Item Data didalam Slot, dan juga jumlah Itemnya

class_name InventorySlot
extends Object

var itemID : int
var itemdataOnSlot : ItemData
var itemQuantity : int

# Contructor untuk mengset default value untuk setiap variable
func _init(id : int = -1, data : ItemData = null, quantity : int = 0) -> void:
	itemID = id
	itemdataOnSlot = data
	itemQuantity = quantity

# Fungsi ini digunakan untuk mengecheck apakah ada Slot yang dipilih kosong atau tidak
func IsEmpty() -> bool:
	return itemdataOnSlot == null
