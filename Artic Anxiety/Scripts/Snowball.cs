using Godot;
using System;

public partial class Snowball : Node3D
{
	public const float speed = 25.0f;
	//private Vector3 direction = new Vector3();
	private	Vector3 _velocity = new Vector3(speed, 0, speed); // Set velocity towards bottom right
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		//GD.Print("Hi");
		//direction = new Vector3(0,1,0);
		//Position = direction;
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		_velocity = _velocity.Normalized() * speed * (float)delta; // Scale velocity by delta time
	
		Translate(_velocity); // Move the snowball
	}
	
	public void SetVelocity(Vector3 velocity)
	{
		_velocity = velocity;
	}
}
