using Godot;
using System;
using System.IO;
using System.Collections.Generic;

public partial class GameManager : Node3D
{
	public static List<PlayerInfo> Players = new List<PlayerInfo>();
	PackedScene snowBallScene = ResourceLoader.Load<PackedScene>("res://Scenes/Game/Abilities/Snowball.tscn");
	
	
	public void RPG(Node nodi, Vector3 position, Vector3 velocity)
	{
		//rocket launcher rocket
		//Snowball instance = (Snowball)RPGScene.Instantiate();
		//instance.Position = position;
		//instance.SetVelocity(velocity);
		//nodi.AddChild(instance);
		
		//rocket launcher
	}
	
	GDScript OrcaMovementScript =  GD.Load<GDScript>("res://Scripts/OrcaMovement.gd");
	GodotObject OrcaMovementNode;
	GDScript PlayerScript =  GD.Load<GDScript>("res://Scripts/NewAnimationTest.gd");
	GodotObject PlayerNode;
	
	public override void _Ready()
	{
		OrcaMovementNode = (GodotObject)OrcaMovementScript.New(); 
		PlayerNode = (GodotObject)PlayerScript.New(); 
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		OrcaMovementNode.Call("SetPlayerPos", PlayerNode.Call("GetPlayerPos"));
		
	}
	
	public void ThrowSnowball(Node nodi, Vector3 position, Vector3 velocity)
	{		
		Snowball instance = (Snowball)snowBallScene.Instantiate();
		instance.Position = position;
		instance.SetVelocity(velocity);
		nodi.AddChild(instance);
	}
	
	
}
