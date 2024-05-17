using Godot;
using System;
using System.IO;
using System.Collections.Generic;

public partial class GameManager : Node3D
{
	PackedScene snowBallScene = ResourceLoader.Load<PackedScene>("res://Scenes/Game/Abilities/Snowball.tscn");
	//PackedScene snowBallScene = ResourceLoader.Load<PackedScene>("res://Scenes/Game/Abilities/Snowball.tscn");
	// Called when the node enters the scene tree for the first time.
	GDScript OrcaMovementScript =  GD.Load<GDScript>("res://Scripts/OrcaMovement.gd");
	GodotObject OrcaMovementNode;
	GDScript PlayerScript =  GD.Load<GDScript>("res://Scripts/NewAnimationTest.gd");
	GodotObject PlayerNode;
	
	public override void _Ready()
	{
		OrcaMovementNode = (GodotObject)OrcaMovementScript.New(); 
		PlayerNode = (GodotObject)PlayerScript.New(); 
		//OrcaMovementNode.SetPlayerPos(new Vector3(0, 0, 0));
		
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
