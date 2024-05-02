using Godot;
using System;

public partial class Player : CharacterBody3D
{
	[Export]
	float speed = 20f;
	[Export]
	float acceleration = 15f;
	[Export]
	float air_acceleration = 5f;
	[Export]
	float Gravity = 0.98f;
	[Export]
	float max_terminal_velocity = 54f;
	[Export]
	float jump_power = 20f;
	[Export(PropertyHint.Range, "0.1,1.0")]
	float mouse_sensitivity = 0.3f;
	[Export(PropertyHint.Range, "-90,0.1")]
	float min_pitch = -90f;
	[Export(PropertyHint.Range, "0,90,1")]
	float max_pitch = 90f;
	
	
	private Vector3 velocity;
	private float y_velocity;
	//private Spatial Camera_pivot;
	//private Camera Camera;
	
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		camera_pivot = GetNode<Spatial>("CameraPivot")
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
