class DGPawn extends Pawn notplaceable;

var DGPawnBag			MyBag;



function PostBeginPlay()
{
	Super.PostBeginPlay();
}


function Tick(float deltatime)
{
	Super.Tick(deltatime);
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
	Super.PossessedBy(C,bVehicleTransition);
	
	if((DGPlayerController(C) != None) && (MyBag == None))
	{
		SetPawnBag(DGPlayerController(C).MyPawnBagClass);		
	}
}

simulated function SetPawnBag(class<DGPawnBag> PB)
{
	//MyBag = Spawn(PB);
}






/************ STATES ************/
auto state NotPlaying // watching other palyers
{	
	function RemoveController()
	{
	}
Begin:
	RemoveController();

}

state Playing
{
	function LockMovement()
	{
		AccelRate = 0.f; // stop movement, no moving while playing.
	}
	
Begin:
	LockMovement();
}
defaultproperties
{
	Begin Object class=SkeletalMeshComponent Name=Mesh
		SkeletalMesh=SkeletalMesh'CH_IronGuard_Male.Mesh.SK_CH_IronGuard_MaleA'
		CollideActors=false
		BlockActors=false
		BlockRigidBody=false
		bOwnerNoSee=true
	End Object
	Components.Add(Mesh)
}