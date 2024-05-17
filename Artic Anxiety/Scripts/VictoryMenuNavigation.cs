using Godot;
using System;

public partial class VictoryMenuNavigation : Node
{
	
	// HOME
		private void _on_button_home_pressed()
	{
		Node newMenu = ResourceLoader.Load<PackedScene>("res://Scenes/Menus/StartMenu.tscn").Instantiate();
		
		GetParent().AddChild(newMenu);
		QueueFree();
	}

	private void _on_button_home_mouse_entered()
	{
		GetNode<Sprite2D>("Home/TextureHomeHover").Show();
		GetNode<LineEdit>("Home/LineEditHomeHover").Show();
	}

	private void _on_button_home_mouse_exited()
	{
		GetNode<Sprite2D>("Home/TextureHomeHover").Hide();
		GetNode<LineEdit>("Home/LineEditHomeHover").Hide();
	}
	
	// EXIT
	
	private void _on_button_exit_pressed()
	{
		GetTree().Quit();
	}
	
	private void _on_button_exit_mouse_entered()
	{
		GetNode<Sprite2D>("Exit/TextureExitHover").Show();
		GetNode<LineEdit>("Exit/LineEditExitHover").Show();
	}

	private void _on_button_exit_mouse_exited()
	{
		GetNode<Sprite2D>("Exit/TextureExitHover").Hide();
		GetNode<LineEdit>("Exit/LineEditExitHover").Hide();
	}

}
