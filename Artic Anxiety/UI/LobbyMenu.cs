using Godot;
using System;

public partial class LobbyMenu : Control
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
		GetNode<Sprite2D>("ButtonExitPressed").Show();
	}


	public void _on_join_lobby_mouse_exited()
	{
		// Replace with function body.
		GetNode<Sprite2D>("ButtonExitPressed").Hide();
	}


	public void _on_join_lobby_pressed()
	{
		// Replace with function body.
		Node exitMenu = ResourceLoader.Load<PackedScene>("res://UI/StartMenu.tscn").Instantiate();
		GetTree().Root.AddChild(exitMenu);
		GetTree().Root.RemoveChild(this);
	}

}

