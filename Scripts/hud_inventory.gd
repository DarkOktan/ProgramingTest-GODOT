# Class ini digunakan untuk menampilkan semua data inventory yang dimiliki pemain
# pemisahan class ini dilakukan agar jika ingin membuat HUD Inventory yang lebih variatif
# bisa dilakukan dengan mengextend class ini

class_name HUDInventory
extends Control

@onready var slotContainer : GridContainer = $HUD_Inventory_BG/HUD_Inventory/Slot_Container

var slotScene : PackedScene = preload("res://Scene/UserInterface/hud_inventory_slot.tscn")
var inventorySytem : InventorySystem

signal UpdateInventoryHUD(slotData : InventorySlot)

func OnInit() -> void:
	# Spawning Slot Based on Inventory System data
	inventorySytem = InventorySystem.GetInventorySystemInstance
	inventorySytem.UpdateInventory.connect(OnUpdateInventory)
	call_deferred("ShowingHUD")
	pass
	
func ShowingHUD() -> void:
	print("Spawning Slot" + str(inventorySytem.InventorySlotInstance.size()))
	for i in range(inventorySytem.InventorySlotInstance.size()):
		var slotScene = slotScene.instantiate() as HUDInventorySlot
		slotContainer.add_child(slotScene)
		slotScene.OnInit(self, inventorySytem.InventorySlotInstance[i])
	
func OnUpdateInventory() -> void:
	print("Update Inventory")
	UpdateInventoryHUD.emit()
	
func HEHE():
	print("HUD INVENTORY BASE")
