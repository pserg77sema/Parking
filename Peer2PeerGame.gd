extends CanvasLayer

func print_to_log(s):
	$MCStart/VBoxStart/TextEdit.text += s + "\n"
	$MCStart/VBoxStart/TextEdit.cursor_set_line($MCStart/VBoxStart/TextEdit.text.length())

func _ready():
	var la = IP.get_local_addresses()
	$MCIPs/VBoxIPs/TextEdit.text = ""
	$MCStart/VBoxStart/TextEdit.text = ""
	for i in la:
		$MCIPs/VBoxIPs/TextEdit.text += str(i) + "\n"
		get_tree().connect("network_peer_connected", self, "network_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "network_peer_disconnected")
	
	get_tree().connect("connected_to_server", self, "connected_to_server")
	get_tree().connect("connection_failed", self, "connection_failed")
	get_tree().connect("server_disconnected", self, "server_disconnected")

func _physics_process(delta):
	$MCStart/VBoxStart/StartServer.disabled = $"/root/Globals".CurNetState != $"/root/Globals".NetState.UNKNOWN
	$MCStart/VBoxStart/StartClient.disabled = $"/root/Globals".CurNetState != $"/root/Globals".NetState.UNKNOWN

func _input(event):
	if event is InputEventKey && event.is_pressed() && event.scancode == KEY_ESCAPE:
		get_tree().change_scene("res://MaiinMenu.tscn")

func _on_ToMenu_pressed():
	get_tree().change_scene("res://MaiinMenu.tscn")

func _on_StartServer_pressed():
	print_to_log("Пробую стартовать сервер")
	var peer = NetworkedMultiplayerENet.new()
	var err = peer.create_server($"/root/Globals".Port, 1)
	print_to_log(str("error = ", err))
	if err == 0:
		$"/root/Globals".CurNetState = $"/root/Globals".NetState.I_SERVER
		$"/root/Globals".Peer = peer
		get_tree().network_peer = peer
		print_to_log("ok")

func _on_StartClient_pressed():
	print_to_log("Пробую стартовать клиент")
	var serverip = $MCStart/VBoxStart/GridContainer/ServerAddress.text
	var peer = NetworkedMultiplayerENet.new()
	var err = peer.create_client(serverip, $"/root/Globals".Port)
	if err == 0:
		$"/root/Globals".CurNetState = $"/root/Globals".NetState.I_CLIENT
		$"/root/Globals".Peer = peer
		get_tree().network_peer = peer
		print_to_log("ok")

func network_peer_connected(id):
	#$"/root/Globals".CurNetState = $"/root/Globals".NetState.CONNECTED
	get_tree().change_scene("res://Main.tscn")
	$"/root/Globals".PeerId = id
	$"/root/Globals".CurGameMode = $"/root/Globals".GameMode.MULTIPLE
	print_to_log("- PEER connected")
	
func network_peer_disconnected(id):
	$"/root/Globals".CurNetState = $"/root/Globals".NetState.UNKNOWN
	print_to_log("- PEER disconnected")

func connected_to_server():
	print_to_log("- connected to server")
	
func connection_failed():
	print_to_log("- connection failed!")
	
func server_disconnected():
	print_to_log("- server disconnected")
