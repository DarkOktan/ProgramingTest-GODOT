# Class ini adalah derived class dari Base effect
# class ini khusus untuk membuat Effect Particle

class_name ParticleEffect
extends BaseEffect

# Scene Effect yang akan dimunculkan
@export var EffectToShow : PackedScene

var ParticleEffectInstance : Node2D

# Membuat Scene kedalam Root Node
func OnEffectExecuted(atPosition : Vector2, atNode : Node) -> void:
	ParticleEffectInstance = EffectToShow.instantiate() as CPUParticles2D
	
	call_deferred("EmmitParticle", atPosition, atNode)

# Memulai Particle
func EmmitParticle(atPosition : Vector2, atNode : Node) -> void:
	OnEffectMessage("On Effect Executed")
	ParticleEffectInstance.emitting = true
	ParticleEffectInstance.connect("finished",OnFinishedEffect)
	
	atNode.add_child(ParticleEffectInstance)

# Menghapus Particle Jika sudah selesai
func OnFinishedEffect():
	OnEffectMessage("On Effect Finished")
	if ParticleEffectInstance != null:
		ParticleEffectInstance.queue_free()
