extends RigidBody2D
var explotion_sound = AudioStreamPlayer.new()
var explotion_sound_file = load("res://Resources/AudioFiles/GunShoot/Explosion.wav")
var one_motion = true
const speed=400
var last_pos
var motion=Vector2()
var direction=1
var explosion_timer =Timer.new()
var explosion_ready = false
func _ready():
	set_explosion_timer()
	explosion_timer.start()
	set_sounds()
	
func set_sounds():
	explotion_sound.set_stream(explotion_sound_file)
	explotion_sound.volume_db = 1
	explotion_sound.pitch_scale = 1
	add_child(explotion_sound)
	
func set_explosion_timer():
	explosion_timer.connect("timeout",self,"on_explosion_timer") 
	add_child(explosion_timer) #to process
	explosion_timer.set_wait_time(1.5)
	
func on_explosion_timer():
	explosion_ready = true
	$AnimatedSprite.play("explosion")
	$CollisionShape2D.disabled = true
	$Area2D/CollisionShape2D2.disabled = false
	last_pos = get_global_position()
	explotion_sound.play()

	
	
func set_bullet_direction(dir):
	direction=dir
	if dir==-1:
		$AnimatedSprite.flip_h=true
		$AnimatedSprite.position.x+=45
		$CollisionShape2D.position.x+=45
	

func _physics_process(delta):
	motion.x = speed * direction
	if one_motion:
		set_linear_velocity(Vector2(motion.x  , 10))
		one_motion = false
	if explosion_ready:
		$AnimatedSprite.play("explosion")
		set_global_rotation(0) 
		set_global_position(last_pos)
	else:
		$AnimatedSprite.play("shoot")
	pass


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.get_animation() == "explosion":
		queue_free()
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	if "Zombie" in body.name:
		body.dead(10,"player") 
	pass # Replace with function body.
