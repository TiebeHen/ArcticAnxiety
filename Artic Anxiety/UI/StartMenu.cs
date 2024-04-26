using Godot;
using System;

public partial class StartMenu : Control
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
	
		
	public void _on_join_lobby_mouse_entered()
	{
		// Replace with function body.
		GetNode<Sprite2D>("ButtonJoinLobbyPressed").Show();
	}


	public void _on_join_lobby_mouse_exited()
	{
		GetNode<Sprite2D>("ButtonJoinLobbyPressed").Hide();
		// Replace with function body.
	}


	public void _on_create_lobby_mouse_entered()
	{
		// Replace with function body.
		GetNode<Sprite2D>("ButtonCreateLobbyPressed").Show();
	}


	public void _on_create_lobby_mouse_exited()
	{
		// Replace with function body.
		GetNode<Sprite2D>("ButtonCreateLobbyPressed").Hide();
	}


	public void _on_settings_mouse_entered()
	{
		// Replace with function body.
		GetNode<Sprite2D>("ButtonSettingsPressed").Show();
	}


	public void _on_settings_mouse_exited()
	{
		// Replace with function body.
		GetNode<Sprite2D>("ButtonSettingsPressed").Hide();
	}


	public void _on_exit_mouse_entered()
	{
		// Replace with function body.
		GetNode<Sprite2D>("ButtonExitPressed").Show();
	}


	public void _on_exit_mouse_exited()
	{
		// Replace with function body.
		GetNode<Sprite2D>("ButtonExitPressed").Hide();
	}
	
	public void _on_join_lobby_pressed()
	{
		// Replace with function body.
		Node joinMenu = ResourceLoader.Load<PackedScene>("res://UI/JoinMenu.tscn").Instantiate();
		GetTree().Root.AddChild(joinMenu);
		GetTree().Root.RemoveChild(this);
	}


	public void _on_create_lobby_pressed()
	{
		// Replace with function body.
		Node createMenu = ResourceLoader.Load<PackedScene>("res://UI/CreateMenu.tscn").Instantiate();
		GetTree().Root.AddChild(createMenu);
		GetTree().Root.RemoveChild(this);
	}


	public void _on_settings_pressed()
	{
		// Replace with function body.
		//Node settingsMenu = ResourceLoader.Load<PackedScene>("res://UI/SettingsMenu.tscn").Instantiate();
		//GetTree().Root.AddChild(settingsMenu);
		//GetTree().Root.RemoveChild(this);
	}

	public void _on_exit_pressed()
	{
		// Replace with function body.
		GetTree().Quit();
	}
	
	public void _on_exit_2_pressed()
	{
		// Replace with function body.
		Node testScene = ResourceLoader.Load<PackedScene>("res://Level/GameLevel.tscn").Instantiate();
		GetTree().Root.AddChild(testScene);
		GetTree().Root.RemoveChild(this);
	}
}

