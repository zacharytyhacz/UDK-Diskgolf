class DGSpawn extends NavigationPoint placeable;

var(Spawn) int SpawnNum; // 0 = A, 1 = B, 2 = C, etc etc
var(Spawn) DGGoal Goal; // a referenced goal on the map that corresponds with this spawn start

var(Spawn) int HoleNumber; // fist or last or what ( 0 is first )

var float MaxStartThrowDist; // the max distance from center of spawn to move player to start throw

var MeshComponent Mesh;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	if(Goal == None)
	{
		`warn(Self $ " HAS NO GOAL ACTOR REFERENCED");
	}
	else `log(Self $ "HAS A GOAL SET TO " $ Goal);
}

function int GetHoleNum()
{
	return HoleNumber;
}

function float GetMaxDist()
{
	return MaxStartThrowDist;
}

function DGGoal GetGoalActor()
{
	return Goal;
}

defaultproperties
{
	SpawnNum=0;
	Begin Object class=StaticMeshComponent Name=SpawnMeshComponent
		StaticMesh=StaticMesh'DGAssets.Models.DG_StartMesh'
	End Object
	Mesh=SpawnMeshComponent
	Components.Add(SpawnMeshComponent)
	Components.Remove(Sprite)
}