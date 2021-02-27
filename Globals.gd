extends Node

enum NetState {UNKNOWN, I_SERVER, I_CLIENT}
var CurNetState = NetState.UNKNOWN
var Port = 23232

enum GameMode {SINGLE, MULTIPLE}
var CurGameMode = GameMode.SINGLE

var Peer = null
var PeerId = -1
