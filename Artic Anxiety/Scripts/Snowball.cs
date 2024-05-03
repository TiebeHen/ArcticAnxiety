using Godot;
using System;

public partial class Snowball : Node3D
{
	public const float speed = 500.0f;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		//direction = new Vector3(1,0, 1).Rotated(Rotation);
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		//Vector2 velocity = Velocity;
		
		//velocity = speed * direction;

		//Velocity = velocity;
		//MoveAndSlide();
	}
}
