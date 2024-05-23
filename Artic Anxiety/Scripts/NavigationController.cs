using Godot;
using System;

public partial class NavigationController : Control
{
	private bool _HasLobby = false;
	
	// TEMP BUTTON FOR QUICK DEBUGGING - NO MULTIPLAYER
	public void _on_button_test_play_pressed()
	{
		Node newMenu = ResourceLoader.Load<PackedScene>("res://Scenes/Game/GameLevel.tscn").Instantiate();
		GetTree().Root.AddChild(newMenu);
		QueueFree();
	}

	public override void _Ready()
	{
		
	}

	public override void _Process(double delta)
	{
		
	}

	//region Pressed buttons
		//region StartMenuOverlay
		public void _on_button_multiplayer_pressed()
		{
			GetNode<Node2D>("StartMenuOverlay").Hide();
			GetNode<Node2D>("MultiplayerMenuOverlay").Show();
			
			// Show this Button
			GetNode<Node2D>("Back").Show();
			
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
			_HasLobby = true;
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

