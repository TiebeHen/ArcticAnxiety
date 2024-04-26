using Godot;
using System;

public partial class JoinMenu : Node2D
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
	
	
	public void _on_cancel_mouse_entered()
	{
		// Replace with function body.
			GetNode<Sprite2D>("ButtonBackPressed").Show();
	}


	public void _on_cancel_mouse_exited()
	{
		// Replace with function body.
			GetNode<Sprite2D>("ButtonBackPressed").Hide();
	}


	public void _on_cancel_pressed()
	{
		// Replace with function body.
			Node backMenu = ResourceLoader.Load<PackedScene>("res://UI/StartMenu.tscn").Instantiate();
			GetTree().Root.AddChild(backMenu);
			GetTree().Root.RemoveChild(this);
	}
}

