using Godot;
using System;
using System.Xml.Schema;
using System.Linq;

public partial class MenuNavigation : Node
{	
	[Export]
	private int port = 8910;

	[Export]
	private string address = "127.0.0.1";

	private ENetMultiplayerPeer peer;
	
	public override void _Ready()
	{
		Multiplayer.PeerConnected += PeerConnected;
		Multiplayer.PeerDisconnected += PeerDisconnected;
		Multiplayer.ConnectedToServer += ConnectedToServer;
		Multiplayer.ConnectionFailed += ConnectionFailed;
		if(OS.GetCmdlineArgs().Contains("--server")){
			hostGame();
		}
	}
	
	/// <summary>
	/// runs when the connection fails and it runs onlyh on the client
	/// </summary>
	/// <exception cref="NotImplementedException"></exception>
	private void ConnectionFailed()
	{
		GD.Print("CONNECTION FAILED");
	}

	/// <summary>
	/// runs when the connection is successful and only runs on the clients
	/// </summary>
	/// <exception cref="NotImplementedException"></exception>
	private void ConnectedToServer()
	{
		GD.Print("Connected To Server");
		RpcId(1, "sendPlayerInformation", "hi", Multiplayer.GetUniqueId());
	}

	/// <summary>
	/// Runs when a player disconnects and runs on all peers
	/// </summary>
	/// <param name="id">id of the player that disconnected</param>
	/// <exception cref="NotImplementedException"></exception>
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
	}

	/// <summary>
	/// Runs when a player connects and runs on all peers
	/// </summary>
	/// <param name="id">id of the player that connected</param>
	/// <exception cref="NotImplementedException"></exception>
	private void PeerConnected(long id)
	{
		GD.Print("Player Connected! " + id.ToString());
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
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

	public void _on_button_join_lobby_mouse_entered()
	{
		GetNode<Sprite2D>("Join/TextureJoinLobbyHover").Show();
		GetNode<LineEdit>("Join/LineEditJoinLobbyHover").Show();
	}

	public void _on_button_join_lobby_mouse_exited()
	{
		GetNode<Sprite2D>("Join/TextureJoinLobbyHover").Hide();
		GetNode<LineEdit>("Join/LineEditJoinLobbyHover").Hide();
	}

	public void _on_button_join_lobby_pressed()
	{
		Node newMenu = ResourceLoader.Load<PackedScene>("res://Scenes/Menus/JoinMenu.tscn").Instantiate();
		
		GetParent().AddChild(newMenu);
		QueueFree();
	}

	public void _on_button_create_lobby_mouse_entered()
	{
		GetNode<Sprite2D>("Create/TextureCreateLobbyHover").Show();
		GetNode<LineEdit>("Create/LineEditCreateLobbyHover").Show();
	}

	public void _on_button_create_lobby_mouse_exited()
	{
		GetNode<Sprite2D>("Create/TextureCreateLobbyHover").Hide();
		GetNode<LineEdit>("Create/LineEditCreateLobbyHover").Hide();
	}

	public void _on_button_create_lobby_pressed()
	{
		Node newMenu = ResourceLoader.Load<PackedScene>("res://Scenes/Menus/CreateMenu.tscn").Instantiate();
		
		GetTree().Root.AddChild(newMenu);
		QueueFree();
	}

	public void _on_button_settings_mouse_entered()
	{
		GetNode<Sprite2D>("Settings/TextureSettingsHover").Show();
		GetNode<LineEdit>("Settings/LineEditSettingsHover").Show();
	}

	public void _on_button_settings_mouse_exited()
	{
		GetNode<Sprite2D>("Settings/TextureSettingsHover").Hide();
		GetNode<LineEdit>("Settings/LineEditSettingsHover").Hide();
	}

	public void _on_button_settings_pressed()
	{
		//Node newMenu = ResourceLoader.Load<PackedScene>("res://Scenes/Menus/SettingsMenu.tscn").Instantiate();
		//GetTree().Root.AddChild(newMenu);
		//GetTree().Root.RemoveChild(this);
	}

	public void _on_button_exit_mouse_entered()
	{
		GetNode<Sprite2D>("Exit/TextureExitHover").Show();
		GetNode<LineEdit>("Exit/LineEditExitHover").Show();
	}

	public void _on_button_exit_mouse_exited()
	{
		GetNode<Sprite2D>("Exit/TextureExitHover").Hide();
		GetNode<LineEdit>("Exit/LineEditExitHover").Hide();
	}

	public void _on_button_exit_pressed()
	{
		GetTree().Quit();
	}	
	
	//
	// JoinMenu
	//
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

	public void _on_button_back_pressed()
	{
		Node newMenu = ResourceLoader.Load<PackedScene>("res://Scenes/Menus/StartMenu.tscn").Instantiate();
		
		GetTree().Root.AddChild(newMenu);
		QueueFree();
	}
	
	//
	// CreateMenu
	//
	private void _on_button_create_mouse_entered()
	{
		GetNode<Sprite2D>("Create/TextureCreateHover").Show();
		GetNode<LineEdit>("Create/LineEditCreateHover").Show();
	}

	private void _on_button_create_mouse_exited()
	{
		GetNode<Sprite2D>("Create/TextureCreateHover").Hide();
		GetNode<LineEdit>("Create/LineEditCreateHover").Hide();
	}

	private void _on_button_create_pressed()
	{
		Node newMenu = ResourceLoader.Load<PackedScene>("res://Scenes/Menus/LobbyMenu.tscn").Instantiate();
		
		GetTree().Root.AddChild(newMenu);
		//QueueFree();
		
		hostGame();
		sendPlayerInformation(GetNode<LineEdit>("LobbyName").Text, 1);
		GD.Print("hostGame is called");
	}
	
	//
	// LobbyMenu
	//
	private void _on_button_leave_mouse_entered()
	{
		GetNode<Sprite2D>("Leave/TextureLeaveHover").Show();
		GetNode<LineEdit>("Leave/LineEditLeaveHover").Show();
	}

	private void _on_button_leave_mouse_exited()
	{
		GetNode<Sprite2D>("Leave/TextureLeaveHover").Hide();
		GetNode<LineEdit>("Leave/LineEditLeaveHover").Hide();
	}

	private void _on_button_leave_pressed()
	{
		Node newMenu = ResourceLoader.Load<PackedScene>("res://Scenes/Menus/StartMenu.tscn").Instantiate();
		GetTree().Root.AddChild(newMenu);
		//GetParent().AddChild(newMenu);
		QueueFree();
	}

	private void _on_button_start_mouse_entered()
	{
		GetNode<Sprite2D>("Start/TextureStartHover").Show();
		GetNode<LineEdit>("Start/LineEditStartHover").Show();
	}

	private void _on_button_start_mouse_exited()
	{
		GetNode<Sprite2D>("Start/TextureStartHover").Hide();
		GetNode<LineEdit>("Start/LineEditStartHover").Hide();
	}

	private void _on_button_start_pressed()
	{
		Rpc("startGame");
	}
	
	[Rpc(MultiplayerApi.RpcMode.AnyPeer, CallLocal = true, TransferMode = MultiplayerPeer.TransferModeEnum.Reliable)]
	private void startGame()
	{
		GD.Print("Starting");
		Node newMenu = ResourceLoader.Load<PackedScene>("res://Scenes/Game/GameLevel.tscn").Instantiate();
		//GetTree().Root.AddChild(newMenu);
		//GetTree().Root.RemoveChild(this);
		GetTree().Root.AddChild(newMenu);
		QueueFree();
	}

	//
	// SmallJoin to enter lobby
	//
	public void _on_button_small_join_pressed()
	{
		// Replace with function body.
		peer = new ENetMultiplayerPeer();
		peer.CreateClient(address, port);

		peer.Host.Compress(ENetConnection.CompressionMode.RangeCoder);
		Multiplayer.MultiplayerPeer = peer;
		GD.Print("Joining Game!");
		
		//GetNode<Sprite2D>("TextureSmallJoin").Hide();
		//GetNode<LineEdit>("LineEditSmallJoin").Hide();
		//GetNode<Button>("ButtonSmallJoin").Hide();
		
	}

	
}




