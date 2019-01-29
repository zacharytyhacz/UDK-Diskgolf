class DGGoal extends Actor placeable;

var MeshComponent Mesh;
var CylinderComponent       CylinderComponent;

function PostBeginPlay()
{
	Super.PostBeginPlay();
}

defaultproperties
{
	bCollideActors=true
    bCollideWorld=true
    bBlockActors=true

	Begin Object class=StaticMeshComponent Name=SpawnMeshComponent
		StaticMesh=StaticMesh'DGAssets.Models.DG_GoalMesh'
	End Object
	Mesh=SpawnMeshComponent
	Components.Add(SpawnMeshComponent)
	
	Begin Object class=CylinderComponent Name=CollisionCylinder
      CollisionRadius=40.000000
      CollisionHeight=100.000000
	  BlockNonZeroExtent=true
      BlockZeroExtent=true
      BlockActors=true
      CollideActors=true
   End Object
   CylinderComponent=CollisionCylinder
   CollisionComponent=CollisionCylinder
   Components.Add(CollisionCylinder)
}