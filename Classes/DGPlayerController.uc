class DGPlayerController extends PlayerController;

var class<DGPawnBag> MyPawnBagClass; // the class of the bag that this palyer's pawn will have '
var DGPawnBag aMyPawnBag;
var DGDisk CurrentDisk;

var int					iTurn;		// what number does this pawn go
var bool				bIsTurn; // is this player currently palying
var bool 				bThrown;
var bool				bNext;

var DGDisk				MyDisk;

var int 				Score;
var int 				TotalScore;

function Possess(Pawn aPawn, bool bVehicleTransition)
{   
    aPawn.PossessedBy(Self, False);        
    Super.Possess(aPawn, bVehicleTransition); 
    //`log("my pawn is "$ Pawn);
    if(DGPawn(aPawn) != None)
    {             
		SetViewTarget(Pawn);
		aMyPawnBag = Spawn(MyPawnBagClass);
    } 
}

function vector GetDiskLocation()
{
	if(MyDisk != None)
	{
		return MyDisk.Location;
	}
	else `log("no disk for"$self);
}

function int GetTurnNum()
{
	return iTurn;
}

function NextRound()
{
	bNext = true;
	TotalScore += Score;
	Score = 0; 
	DGHUD(myhud).Score = Score;
	DGHUD(myhud).Total = TotalScore;
	CurrentDisk.Destroy();
	bThrown = false;
}

function bool IsTurn()
{
	if(bIsTurn) return true;
	else return false;
}

function SetTurnNum(int i) // only gets called if multple palyers
{
	if(iTurn == 0) // by default this is 0, there are no other players
	{
		iTurn = i;
	}
}

function MoveToStart(DGSpawn SpawnPlace) // @param SpawnPlace - the A or B spawn of a hole
{
	if(!bIsTurn) // shouldnt happen
	{
		`warn("ATTEMPTING TO MOVE A PAWN TO START WHEN IT IS NOT THEIR TURN");
	}
	else 
	{
		Pawn.SetLocation(SpawnPlace.Location); // move to start location
		//`log("setting "$ self $" to "$ SpawnPlace.Location $ Pawn.SetLocation(SpawnPlace.Location));
		Pawn.GoToState('Playing');
	}
}

function SetCurrentTurn(bool isTurn)
{
	if(bIsTurn)
	{
		`warn("SETTING TURN TO A PAWN THAT IS CURRENTLY IN TURN");
	}
	else bIsTurn = true; // start playing etc etc;
}

function MoveToDisk(DGDisk theDisk)
{	
	if(DGPawn(Pawn) != None && bThrown)
	{
		bThrown=false;
		Score++; 						// add to score, this is a throw
		DGHUD(myhud).Score = Score;
		Pawn.SetLocation(theDisk.Location+vect(0,0,48));
		`log("setting pawn to "$ theDisk.Location);
	}
}

exec function ThrowDisk()
{
	local vector v;
	
	if(!bThrown)
	{
		//`log("eee oooo");
		CurrentDisk = Spawn(class'DGDisk',,,Pawn.GetPawnViewLocation(),Pawn.GetViewRotation());
		CurrentDisk.CreateOwner(self);
		
		v = vector(Pawn.GetViewRotation());
		//`log("vvvvvvvvvvVVVVVvvvvvvVVVVVVVVVvvvv"$ v @ CurrentDisk.Location @ Pawn.Location);
		CurrentDisk.Throw(vector(Pawn.GetViewRotation()), 50.0f, 10.0f);
		bThrown = true;
	}
}

function GameOver()
{
	DGHUD(myhud).bGameOver = true;
}

function ToHUD(int holenumber,int total)
{
	DGHUD(myhud).CurrentHole = holenumber;
	DGHUD(myhud).TotalHoles = total;
}

defaultproperties
{
	bNext=false
	bThrown=false
	iTurn=0
	MyPawnBagClass=class'DGPawnBag' // test, tho will be a child
	HUDS
	InputClass=class'DGPlayerInput'
}