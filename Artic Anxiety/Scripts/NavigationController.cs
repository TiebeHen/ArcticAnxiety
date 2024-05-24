using Godot;
using System;
using System.Xml.Schema;
using System.Linq;

public partial class NavigationController : Control
{
	private bool _HasLobby = false;
	
	[Export]
	private int port = 8910;

	[Export]
	private string address = "127.0.0.1";

	private ENetMultiplayerPeer peer;
	
	// TEMP BUTTON FOR QUICK DEBUGGING - NO MULTIPLAYER
	public void _on_button_test_play_pressed()
	{
		Node newMenu = ResourceLoader.Load<PackedScene>("res://Scenes/Game/GameLevel.tscn").Instantiate();
		GetTree().Root.AddChild(newMenu);
		QueueFree();
	}
	
	// TEST BUTTON FOR QUICK JOINING
	public void _on_button_test_join_pressed()
	{
		peer = new ENetMultiplayerPeer();
		peer.CreateClient(address, port);

		peer.Host.Compress(ENetConnection.CompressionMode.RangeCoder);
		Multiplayer.MultiplayerPeer = peer;
		GD.Print("Joining Game!");
	}

	public override void _Ready()
	{
		Multiplayer.PeerConnected += PeerConnected;
		Multiplayer.PeerDisconnected += PeerDisconnected;
		Multiplayer.ConnectedToServer += ConnectedToServer;
		Multiplayer.ConnectionFailed += ConnectionFailed;
		if(OS.GetCmdlineArgs().Contains("--server")){
			hostGame();
		}
		
		//GetNode<ServerBrowser>("ServerBrowser").JoinGame += joinGame;
	}
	
	private void ConnectionFailed()
	{
		GD.Print("CONNECTION FAILED");
	}
		
	private void ConnectedToServer()
	{
		GD.Print("Connected To Server");
		RpcId(1, "sendPlayerInformation", GetNode<LineEdit>("MultiplayerMenuOverlay/LobbyNameInput").Text, Multiplayer.GetUniqueId());
	}
	
	private void PeerDisconnected(long id)
	{
		GD.Print("Player Disconnected: " + id.ToString());
		GameManager.Players.Remove(GameManager.Players.Where(i => i.Id == id).First<PlayerInfo>());
		var players = GetTree().GetNodesInGroup("Player");
		
		foreach (var item in players)
		{
			if(item.Name == id.ToString()){
				item.QueueFree();
			}
		}
		GetNode<Node2D>("MultiplayerMenuOverlay/StartGame").Hide();
	}
	
	private void PeerConnected(long id)
	{
		GD.Print("Player Connected! " + id.ToString());
		GetNode<Node2D>("MultiplayerMenuOverlay/StartGame").Show();
	}

	public override void _Process(double delta)
	{
		
	}
	
	private void hostGame(){
		peer = new ENetMultiplayerPeer();
		var error = peer.CreateServer(port, 2);
		if(error != Error.Ok){
			GD.Print("error cannot host! :" + error.ToString());
			return;
		}
		peer.Host.Compress(ENetConnection.CompressionMode.RangeCoder);

		Multiplayer.MultiplayerPeer = peer;
		GD.Print("Waiting For Players!");
		//GetNode<ServerBrowser>("ServerBrowser").SetUpBroadcast(GetNode<LineEdit>("LineEdit").Text + "'s Server");
	}
	
	[Rpc(MultiplayerApi.RpcMode.AnyPeer)]
	private void sendPlayerInformation(string name, int id){
		PlayerInfo playerInfo = new PlayerInfo(){
			Name = name,
			Id = id
		};
		
		if(!GameManager.Players.Contains(playerInfo)){
			
			GameManager.Players.Add(playerInfo);
			
		}

		if(Multiplayer.IsServer()){
			foreach (var item in GameManager.Players)
			{
				Rpc("sendPlayerInformation", item.Name, item.Id);
			}
		}
	}
	

	[Rpc(MultiplayerApi.RpcMode.AnyPeer, CallLocal = true, TransferMode = MultiplayerPeer.TransferModeEnum.Reliable)]
	private void startGame()
	{
		//GetNode<ServerBrowser>("ServerBrowser").CleanUp();
		Node newMenu = ResourceLoader.Load<PackedScene>("res://Scenes/Game/GameLevel.tscn").Instantiate();
		GetTree().Root.AddChild(newMenu);
		QueueFree();
	}

	//region Pressed buttons
		//region StartMenuOverlay
		public void _on_button_multiplayer_pressed()
		{
			GetNode<Node2D>("StartMenuOverlay").Hide();
			GetNode<Node2D>("MultiplayerMenuOverlay").Show();
			
			// Show this Button
			GetNode<Node2D>("Back").Show();
			GetNode<Node2D>("TestJoin").Show();
			
			// Show buttons to create lobby again if there is no lobby
			if(_HasLobby == false)
			{
				GetNode<LineEdit>("MultiplayerMenuOverlay/LobbyNameInput").Show();
				GetNode<LineEdit>("MultiplayerMenuOverlay/LobbyNameInput").Text = "";
				GetNode<Node2D>("MultiplayerMenuOverlay/Create").Show();
			}
		}

		public void _on_button_settings_pressed()
		{
			GetNode<Node2D>("StartMenuOverlay").Hide();
			GetNode<Node2D>("SettingsMenuOverlay").Show();
			
			// Show this Button
			GetNode<Node2D>("Back").Show();
		}
	
		public void _on_button_exit_pressed()
		{
			GetTree().Quit();
		}
		//endregion
		//region MultiplayerMenuOverlay
		public void _on_button_create_lobby_pressed()
		{
			GetNode<LineEdit>("MultiplayerMenuOverlay/LobbyNameInput").Hide();
			GetNode<Node2D>("MultiplayerMenuOverlay/Create").Hide();
			
			if(_HasLobby == false)
			{
				hostGame();
				sendPlayerInformation(GetNode<LineEdit>("MultiplayerMenuOverlay/LobbyNameInput").Text, 1);
				_HasLobby = true;
			}
		}
		

		public void _on_button_start_game_pressed()
		{			
			Rpc("startGame");
		}


		//endregion
	//endregion
	
	// Back Button always goes to StartMenuOverlay
	public void _on_button_back_pressed()
	{
			GetNode<Node2D>("SettingsMenuOverlay").Hide();
			GetNode<Node2D>("MultiplayerMenuOverlay").Hide();
			GetNode<Node2D>("StartMenuOverlay").Show();
			
			// Hide this Button
			GetNode<Node2D>("Back").Hide();
			
			// Reset the play button
			GetNode<Node2D>("MultiplayerMenuOverlay/StartGame").Hide();
			GetNode<Node2D>("TestJoin").Hide();
			
			// Cancel lobby
			_HasLobby = false;
	}
	
	//region Responsive buttons
		//region StartMenuOverlay
		public void _on_button_multiplayer_mouse_entered()
		{
			GetNode<Sprite2D>("StartMenuOverlay/Multiplayer/TextureMultiplayerHover").Show();
			GetNode<LineEdit>("StartMenuOverlay/Multiplayer/LineEditMultiplayerHover").Show();
		}

		public void _on_button_multiplayer_mouse_exited()
		{
			GetNode<Sprite2D>("StartMenuOverlay/Multiplayer/TextureMultiplayerHover").Hide();
			GetNode<LineEdit>("StartMenuOverlay/Multiplayer/LineEditMultiplayerHover").Hide();
		}
		
		public void _on_button_settings_mouse_entered()
		{
			GetNode<Sprite2D>("StartMenuOverlay/Settings/TextureSettingsHover").Show();
			GetNode<LineEdit>("StartMenuOverlay/Settings/LineEditSettingsHover").Show();
		}

		public void _on_button_settings_mouse_exited()
		{
			GetNode<Sprite2D>("StartMenuOverlay/Settings/TextureSettingsHover").Hide();
			GetNode<LineEdit>("StartMenuOverlay/Settings/LineEditSettingsHover").Hide();
		}

		public void _on_button_exit_mouse_entered()
		{
			GetNode<Sprite2D>("StartMenuOverlay/Exit/TextureExitHover").Show();
			GetNode<LineEdit>("StartMenuOverlay/Exit/LineEditExitHover").Show();
		}

		public void _on_button_exit_mouse_exited()
		{
			GetNode<Sprite2D>("StartMenuOverlay/Exit/TextureExitHover").Hide();
			GetNode<LineEdit>("StartMenuOverlay/Exit/LineEditExitHover").Hide();
		}
		//endregion
		//region MultiplayerMenuOverlay
		public void _on_button_create_lobby_mouse_entered()
		{
			GetNode<Sprite2D>("MultiplayerMenuOverlay/Create/TextureCreateLobbyHover").Show();
			GetNode<LineEdit>("MultiplayerMenuOverlay/Create/LineEditCreateLobbyHover").Show();
		}

		public void _on_button_create_lobby_mouse_exited()
		{
			GetNode<Sprite2D>("MultiplayerMenuOverlay/Create/TextureCreateLobbyHover").Hide();
			GetNode<LineEdit>("MultiplayerMenuOverlay/Create/LineEditCreateLobbyHover").Hide();
		}
		
		public void _on_button_start_game_mouse_entered()
		{
			GetNode<Sprite2D>("MultiplayerMenuOverlay/StartGame/TextureStartGameHover").Show();
			GetNode<LineEdit>("MultiplayerMenuOverlay/StartGame/LineEditStartGameHover").Show();
		}

		public void _on_button_start_game_mouse_exited()
		{
			GetNode<Sprite2D>("MultiplayerMenuOverlay/StartGame/TextureStartGameHover").Hide();
			GetNode<LineEdit>("MultiplayerMenuOverlay/StartGame/LineEditStartGameHover").Hide();
		}
		//endregion
		
		// Back Button always goes to StartMenuOverlay
		public void _on_button_back_mouse_entered()
		{
			GetNode<Sprite2D>("Back/TextureBackHover").Show();
			GetNode<LineEdit>("Back/LineEditBackHover").Show();
		}

		public void _on_button_back_mouse_exited()
		{
			GetNode<Sprite2D>("Back/TextureBackHover").Hide();
			GetNode<LineEdit>("Back/LineEditBackHover").Hide();
		}
	//endregion

}
