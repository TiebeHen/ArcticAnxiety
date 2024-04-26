using Godot;
using System;

public partial class CreateMenu : Control
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

	public void _on_create_mouse_entered()
	{
		// Replace with function body.
		GetNode<Sprite2D>("ButtonCreateLobbyPressed").Show();
	}


	public void _on_create_mouse_exited()
	{
		// Replace with function body.
		GetNode<Sprite2D>("ButtonCreateLobbyPressed").Hide();
	}


	public void _on_create_pressed()
	{
		// Replace with function body.
		Node lobbyMenu = ResourceLoader.Load<PackedScene>("res://UI/LobbyMenu.tscn").Instantiate();
		GetTree().Root.AddChild(lobbyMenu);
		GetTree().Root.RemoveChild(this);
		
		
	}


	public void _on_cancel_mouse_entered()
	{
		// Replace with function body.
		GetNode<Sprite2D>("ButtonCancelPressed").Show();
	}


	public void _on_cancel_mouse_exited()
	{
		// Replace with function body.
		GetNode<Sprite2D>("ButtonCancelPressed").Hide();
	}


	public void _on_cancel_pressed()
	{
		// Replace with function body.
		Node cancelMenu = ResourceLoader.Load<PackedScene>("res://UI/StartMenu.tscn").Instantiate();
		GetTree().Root.AddChild(cancelMenu);
		GetTree().Root.RemoveChild(this);
	}
}

