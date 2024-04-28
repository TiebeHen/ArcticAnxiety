using Godot;
using System;

public partial class ClassTile : Node3D
{
	private Node3D _instance;
	private String _id;
	
	public ClassTile(String id, Node3D instance)
	{
		_instance = instance;
		_id = id;
	} 
	public Node3D GetInstance()
	{
		return _instance;
	}
	public String GetID()
	{
		return _id;
	}
	public String Print()
	{
		if( _instance != null)
		{
		return "ID: " + _id + " Pos: "+ _instance.Position;
		}
		else
		{
			return "ID: " + _id + " Pos: Null" ;
		}
	}
}
