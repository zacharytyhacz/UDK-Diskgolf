class DGDisk extends KAsset notplaceable;

var float Range, Glide, Turn, Fade; // variables responsible for how the disk goes throug hthe air

var DGPlayerController OwnerController;

var DGPawnBag OwnerBag;

var bool bThrown;
var bool bTouchedGoal;

var SkeletalMeshComponent   SkelMesh;
var CylinderComponent       CylinderComponent;

function CreateOwner(DGPlayerController C)
{
	if(OwnerController == None)
	{
		OwnerController = C;
		
		if(OwnerController.Pawn != None)
		{
			OwnerController.aMyPawnBag = OwnerBag;
		}
	}
	else `warn("Attempting to overwrite a disk with "$ self);
}

simulated function Tick(float deltatime)
{
	`log(Velocity);
	Super.Tick(Deltatime);
	//DrawDebugLine(CurrentPlayer.Pawn.Location, CurrentGoal.Location,255,0,0,false);
	if(!bIsMoving && bThrown)
	{
		if(Vsize(OwnerController.Pawn.Location - Location) > 100.0f)
		{		
			OwnerController.MoveToDisk(self);
			bThrown = false;
			Destroy();
		}
	}
}
	

function MoveOwner()
{
	if(OwnerController != None)
	{
		OwnerController.MoveToDisk(self);
	}
}

function Throw(vector Dir, float Power, float Angle)
{
	Velocity = Dir * 1000; 
	`log("$$$$$$$$$$$$$$$$$$$$$$$$$$$"$ Velocity);
	//Acceleration = Fade * Normal(Velocity);
	//SetRotation(Rotator(Dir));
	
	SkelMesh.SetPhysicsAsset(PhysicsAsset'DGAssets.Models.DG_aDisk_Physics', true);
	SkelMesh.SetHasPhysicsAssetInstance(true);
	
	//`log("SkelMesh "$ SkelMesh $ " and "$ SkelMesh.PhysicsAsset @ SkelMesh.PhysicsAssetInstance);
	SkelMesh.MinDistFactorForKinematicUpdate = 100.0f;
    SkelMesh.SetRBChannel(RBCC_Pawn);
    SkelMesh.SetRBCollidesWithChannel(RBCC_Default, true);
    SkelMesh.SetRBCollidesWithChannel(RBCC_Pawn, true);
    SkelMesh.SetRBCollidesWithChannel(RBCC_Vehicle, true);
    SkelMesh.SetRBCollidesWithChannel(RBCC_Untitled3, true);
    SkelMesh.SetRBCollidesWithChannel(RBCC_BlockingVolume, true);
    SkelMesh.ForceSkelUpdate();
    SkelMesh.SetTickGroup(TG_PostAsyncWork);
	
    CollisionComponent = SkelMesh;
    CylinderComponent.SetActorCollision(false, false);
    SkelMesh.SetActorCollision(true, false);
    SkelMesh.SetTraceBlocking(true, true);
    SetPhysics(PHYS_RigidBody);
    SkelMesh.PhysicsWeight = 1.0;

    if (SkelMesh.bNotUpdatingKinematicDueToDistance)
    {
      SkelMesh.UpdateRBBonesFromSpaceBases(true, true);
    }

    SkelMesh.PhysicsAssetInstance.SetAllBodiesFixed(false);
    SkelMesh.bUpdateKinematicBonesFromAnimation = false;
    SkelMesh.SetRBLinearVelocity(Velocity, false);
    SkelMesh.ScriptRigidBodyCollisionThreshold = 10.0f;
    SkelMesh.SetNotifyRigidBodyCollision(true);
    SkelMesh.WakeRigidBody();
	bThrown = true;
	// if bump a DGGoal and this is current goal, round completed.
}

event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	Super.Touch(Other,OtherComp,HitLocation,HitNormal);
	`log("touched by "$ OtherComp @ Other);
	if(DGGoal(Other) != None && !bTouchedGoal) // if the touched actor is a Goal 
	{
		bTouchedGoal = true;
		OwnerController.NextRound();
	}
}

event Bump( Actor Other, PrimitiveComponent OtherComp, Vector HitNormal )
{
	Super.Bump(Other,OtherComp,HitNormal);
	`log("$#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
	if(DGGoal(Other) != None && !bTouchedGoal) // if the touched actor is a Goal 
	{
		bTouchedGoal = true;
		OwnerController.NextRound();
	}
}


defaultproperties
{	
	//Glide=3.0f
	Fade=2.0f
	bTouchedGoal=false
	
	bStatic=false
	bNoDelete=false
	bCollideWorld=true
	Begin Object class=SkeletalMeshComponent Name=Mesh
		SkeletalMesh=SkeletalMesh'DGAssets.Models.DG_aDisk'		
		PhysicsAsset=PhysicsAsset'DGAssets.Models.DG_aDisk_Physics'
		bHasPhysicsAssetInstance=true
		CollideActors=true
		BlockActors=true		
        BlockRigidBody=TRUE
		bCacheAnimSequenceNodes=FALSE
        AlwaysLoadOnClient=true
        AlwaysLoadOnServer=true
        bOwnerNoSee=false
        CastShadow=true
        bUpdateSkelWhenNotRendered=false
        bIgnoreControllersWhenNotRendered=TRUE
        bUpdateKinematicBonesFromAnimation=true
        bCastDynamicShadow=true
        RBChannel=RBCC_GameplayPhysics
        RBCollideWithChannels=(Default=TRUE,BlockingVolume=TRUE,GameplayPhysics=TRUE,EffectPhysics=TRUE)
        bOverrideAttachmentOwnerVisibility=true
        bAcceptsDynamicDecals=FALSE
        TickGroup=TG_PreAsyncWork
        MinDistFactorForKinematicUpdate=0.2
        bChartDistanceFactor=true
        RBDominanceGroup=20
        bUseOnePassLightingOnTranslucency=TRUE
        bPerBoneMotionBlur=true
	End Object
	SkelMesh=Mesh
	Components.Add(Mesh)
	
	Begin Object class=CylinderComponent Name=CollisionCylinder
      CollisionRadius=6.000000
      CollisionHeight=1.000000
	  BlockNonZeroExtent=true
      BlockZeroExtent=true
      BlockActors=true
      CollideActors=true
   End Object
   CylinderComponent=CollisionCylinder
   CollisionComponent=CollisionCylinder
   Components.Add(CollisionCylinder)
}