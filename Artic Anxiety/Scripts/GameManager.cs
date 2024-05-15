using Godot;
using System;
using System.IO;
using System.Collections.Generic;

public partial class GameManager : Node3D
{
	PackedScene snowBallScene = ResourceLoader.Load<PackedScene>("res://Scenes/Game/Abilities/Snowball.tscn");
	//PackedScene snowBallScene = ResourceLoader.Load<PackedScene>("res://Scenes/Game/Abilities/Snowball.tscn");
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		Node3D instance = (Node3D)snowBallScene.Instantiate();
		instance.Position = new Vector3(0, 2, 0);
		AddChild(instance);
		
		GD.Print( ResourceLoader.Exists("res://Scenes/Game/Abilities/Snowball.tscn")); 
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
	
	public void ThrowSnowball(Vector3 position, Vector3 velocity)
	{
		
	}	
	
	private void AddChildDeferred(Node node)
	{
		CallDeferred("add_child", node);
	}
	
}
