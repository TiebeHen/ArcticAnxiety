using Godot;
using System;

public partial class MenuNavigation : Node
{	
	public void _on_button_home_mouse_entered()
	{
		GetNode<Sprite2D>("Home/TextureHomeHover").Show();
		GetNode<LineEdit>("Home/LineEditHomeHover").Show();
	}

	public void _on_button_home_mouse_exited()
	{
		GetNode<Sprite2D>("Home/TextureHomeHover").Hide();
		GetNode<LineEdit>("Home/LineEditHomeHover").Hide();
	}

	public void _on_button_home_pressed()
	{
		Node newMenu = ResourceLoader.Load<PackedScene>("res://Scenes/Menus/StartMenu.tscn").Instantiate();
		GetTree().Root.AddChild(newMenu);
		GetTree().Root.RemoveChild(this);
	}

	public void _on_button_victory_exit_mouse_entered()
	{
		GetNode<Sprite2D>("Exit/TextureExitHover").Show();
		GetNode<LineEdit>("Exit/LineEditExitHover").Show();
	}

	public void _on_button_victory_exit_mouse_exited()
	{
		GetNode<Sprite2D>("Exit/TextureExitHover").Hide();
		GetNode<LineEdit>("Exit/LineEditExitHover").Hide();
	}

	public void _on_button_victory_exit_pressed()
	{
		GetTree().Quit();
	}
}
