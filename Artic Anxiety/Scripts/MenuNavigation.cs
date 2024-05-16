using Godot;
using System;

public partial class MenuNavigation : Node
{	
	//
	// StartMenu
	//
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
		
		GetParent().AddChild(newMenu);
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
		
		GetParent().AddChild(newMenu);
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
		
		GetParent().AddChild(newMenu);
		QueueFree();
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
		
		GetParent().AddChild(newMenu);
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
		Node newMenu = ResourceLoader.Load<PackedScene>("res://Scenes/Game/GameLevel.tscn").Instantiate();
		//GetTree().Root.AddChild(newMenu);
		//GetTree().Root.RemoveChild(this);
		GetParent().AddChild(newMenu);
		QueueFree();
	}

	//
	// SettingsMenu
	//
	
	
}




