extends Node2D


const Player = preload("res://actors/Player.tscn")
const GameOverScreen = preload("res://UI/GameOverScreen.tscn")
const PauseScreen = preload("res://UI/PauseScreen.tscn")


onready var capturable_base_manager = $CapturableBaseManager
onready var ally_ai = $AllyMapAI
onready var enemy_ai = $EnemyMapAI
onready var bullet_manager = $BulletManager
onready var camera = $Camera2D
onready var gui = $GUI
onready var ground = $Ground
onready var pathfinding = $Pathfinding
onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	GlobalSignals.connect("bullet_fired", bullet_manager, "handle_bullet_spawned")

	var ally_respawns = $AllyRespawnPoints
	var enemy_respawns = $EnemyRespawnPoints

	pathfinding.create_navigation_map(ground)

	var bases = capturable_base_manager.get_capturable_bases()
	ally_ai.initialize(bases, ally_respawns.get_children(), pathfinding)
	enemy_ai.initialize(bases, enemy_respawns.get_children(), pathfinding)
	capturable_base_manager.connect("player_captured_all_bases", self, "handle_player_win")
	capturable_base_manager.connect("player_lost_all_bases", self, "handle_player_lost")

	spawn_player()


func spawn_player():
	var player = Player.instance()
	add_child(player)
	player.set_camera_transform(camera.get_path())
	player.connect("died", self, "spawn_player")
	gui.set_player(player)
	timer.start()


func handle_player_win():
	var game_over = GameOverScreen.instance()
	add_child(game_over)
	game_over.set_title(true)
	get_tree().paused = true


func handle_player_lost():
	var game_over = GameOverScreen.instance()
	add_child(game_over)
	game_over.set_title(false)
	get_tree().paused = true


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var pause_menu = PauseScreen.instance()
		add_child(pause_menu)


func _on_Timer_timeout():
	print("30 seconds survival reward! Damage up 10 ")
	var damage = GlobalSignals.DAMAGE
	damage += 10
	GlobalSignals.DAMAGE = damage
