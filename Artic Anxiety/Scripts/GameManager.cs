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
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
	
	public void ThrowSnowball(Node nodi, Vector3 position, Vector3 velocity)
	{		
		Snowball instance = (Snowball)snowBallScene.Instantiate();
		instance.Position = position;
		instance.SetVelocity(velocity);
		nodi.AddChild(instance);
	}		
	
}
