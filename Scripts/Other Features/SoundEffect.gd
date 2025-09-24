# Class ini adalah derived class dari Base effect
# class ini khusus untuk membuat Effect Suara

class_name SoundEffect
extends BaseEffect

# Scene Effect yang akan dimunculkan
@export var EffectToShow : PackedScene

var SoundEffectInstace : AudioStreamPlayer2D

# Membuat Scene kedalam Root Node
func OnEffectExecuted(atPosition : Vector2, atNode : Node) -> void:
	SoundEffectInstace = EffectToShow.instantiate() as AudioStreamPlayer2D
	
	call_deferred("StartSFX", atPosition, atNode)

# Memulai SFX
func StartSFX(atPosition : Vector2, atNode : Node) -> void:
	OnEffectMessage("On Effect Executed")
	SoundEffectInstace.playing = true
	SoundEffectInstace.connect("finished", OnFinishedSound)
	
	atNode.add_child(SoundEffectInstace)

# Menghapus Sound Jika sudah selesai
func OnFinishedSound():
	OnEffectMessage("On SFX Finished")
	if SoundEffectInstace != null:
		SoundEffectInstace.queue_free()
