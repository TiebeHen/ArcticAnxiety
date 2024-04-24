using Godot;

public partial class Tile : MeshInstance3D
{
	private SpatialMaterial material; // Use SpatialMaterial for 3D textures

	public override void _Ready()
	{
		// File path to the texture (assuming a CubeMapTexture or Texture3D)
		string filePath = "res://Art/Tilemap.tres"; // Update extension if needed

		// Load texture
		var texture = ResourceLoader.Load<Texture>(filePath);

		// Check if texture was loaded successfully
		if (texture == null)
		{
			GD.PrintErr("Error: Failed to load texture.");
			return;
		}

		// Create spatial material
		material = new SpatialMaterial();

		// Cast texture to the appropriate type (check in inspector if unsure)
		if (texture is CubeMapTexture)
		{
			// Use for environment mapping
			material.environment = texture as CubeMapTexture; // Assign CubeMapTexture
		}
		else if (texture is Texture3D)
		{
			// Limited base color approach (consider alternatives based on format)
			material.AlbedoTexture = texture as Texture3D; // Limited support
			// OR explore custom shader for more control
		}
		else
		{
			GD.PrintErr("Error: Unsupported texture type for SpatialMaterial.");
			return;
		}

		MaterialOverride = material;

		// Create collision shape
		var collisionShape = new CollisionShape3D();
		var shape = new BoxShape3D();
		collisionShape.Shape = shape;
		AddChild(collisionShape);
	}
}
