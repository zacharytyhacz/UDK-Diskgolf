class DGgame extends SimpleGame;

var array<DGGoal> Goals; 		// the baskets
var array<DGSpawn> Spawns;	// the A and B spawns
var array<DGDisk> PlayerDisks;

var int HoleNum;

var bool bStarted;
var bool bEveryoneGone;
var int iPlayers;
var DGGoal CurrentGoal;

var DGSpawn StartSpawn; // the first spawn loc;
var DGPlayerController CurrentPlayer;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	bEveryoneGone = false; // at the start, everyone did not throw
}

function Controller GetCurrentPlayer() // for multpalyer
{
	if((bStarted) && (CurrentPlayer != None))
	{
		return CurrentPlayer;
	}
}

simulated function Tick(float deltatime)
{
	Super.Tick(Deltatime);
	//DrawDebugLine(CurrentPlayer.Pawn.Location, CurrentGoal.Location,255,0,0,false);
	if(CurrentPlayer.bNext)
	{
		NextHole();
	}
}

simulated function DGDisk FindFarthestPlayer() // for multiplayers, basically returns the farthest person which goes next
{
	local DGDisk DK,FarthestDisk;
	local float Dist;
	
	FarthestDisk = None;
	
	foreach WorldInfo.AllActors(class'DGDisk', DK)
	{
		if(DK.bThrown && DK != FarthestDisk)
		{
			if(FarthestDisk == None) // checking first dick 
			{		
				Dist = VSize(DK.Location - CurrentGoal.Location); // start off with first found disk
				FarthestDisk = DK;
			}
			else if(VSize(DK.Location - FarthestDisk.Location) > Dist)
			{				
				FarthestDisk = DK;
				Dist = VSize(DK.Location - FarthestDisk.Location);
			}
		}
		else if(FarthestDisk == DK)
		{
			return FarthestDisk;
		}
	}
}

function NextPlayer()
{
	if(!bEveryoneGone && iPlayers > 0) // this is changing turn of the start, allowing everyone to throw first
	{
		
	}
}

function NextHole()
{
	`log("$#$#$#$#$#$"$Spawns.Length);
	`log(HoleNum@CurrentPlayer@CurrentGoal);
	//`log("hole num is"$ HoleNum @"  and  "$ Spawns[HoleNum] @ Goals.Length);
	if(HoleNum != Goals.Length)
	{
		HoleNum++;
		MoveToNextHole(Spawns[HoleNum]);
		CurrentPlayer.bNext = false;
	}
	else GotoState('GameOver');	
}

function MoveToNextHole(DGSpawn DGS)
{
	if(CurrentGoal != None && CurrentPlayer != None)
	{
		CurrentGoal = DGS.Goal; // next hjole is now current hole
		CurrentPlayer.MoveToStart(DGS); // move to that goal
	}
}


exec function mytest()
{
	NextHole();//rtadg
}
auto state Setup
{
	function InitSpawns()
	{
		local DGSpawn aSpawn;
		
		foreach WorldInfo.AllNavigationPoints(class'DGSpawn', aSpawn) // look for spawns
		{
			if(aSpawn.GetGoalActor() != None) 							// if it has a goal 
			{
				Spawns.InsertItem(aSpawn.GetHoleNum(),aSpawn); 					// it is a real spawn 
				Goals.InsertItem(aSpawn.GetHoleNum(),aSpawn.GetGoalActor()); // insert spawns goal at corresponding slot as its hole number
				if(aSpawn.GetHoleNum() == 0 && aSpawn.SpawnNum == 0) // find first hole start, and A hole for it
				{
					StartSpawn = aSpawn;					// this is start spawn, all pawns will go here
					CurrentGoal = StartSpawn.Goal;
					`log("start spawn is"$ StartSpawn);
				}
				return;
			}
			else 
				`warn(aSpawn $ " DOES NOT HAVE A GOAL, REMOVING SPAWN"); // other wise just break if it doesnt have a goal
		}
		
	}
	
	function InitPlayers()
	{	
		local DGPlayerController aPC;				// the player
		
		foreach WorldInfo.LocalPlayerControllers(class'DGPlayerController',aPC) // look for spawns 
		{
			iPlayers++;
			
			//log("#################" $ aPC @ StartSpawn @ iPlayers @ aPC.GetTurnNum());
			
			if(aPC.GetTurnNum() == 0)
			{
				`log("do i get here");
				CurrentPlayer = aPC;
				
			}	
		}	
		`log("pawns initiated and "$ CurrentPlayer);
	}
	
	function InitFirstPlayer()
	{	
		local DGSpawn aSpawn;
		
		//`log("################" $ CurrentPlayer);
		if(CurrentPlayer != None)
		{
			CurrentPlayer.SetCurrentTurn(true);	
			CurrentPlayer.MoveToStart(StartSpawn);
			CurrentPlayer.ToHud(HoleNum,Spawns.Length);
			CurrentPlayer.SetRotation(rotator(CurrentGoal.Location - CurrentPlayer.Pawn.Location));
			bStarted = true;
			`log("The game has started"$ bStarted $ CurrentPlayer.GetViewTarget() $ CurrentPlayer.Pawn $ CurrentPlayer);
			// at this point the first player is playing now;
		}
		
		foreach WorldInfo.AllActors(class'DGSpawn', aSpawn) // look for spawns
		{
			//`log("######## found this thing "$ aSpawn);
			Spawns.InsertItem(aSpawn.GetHoleNum(),aSpawn);
			Goals.InsertItem(aSpawn.GetHoleNum(),aSpawn.GetGoalActor());
		}
	}
	
Begin:
	InitSpawns();
	InitPlayers();
	InitFirstPlayer();
}


state GameOver
{
	function HUDmessage()
	{
		CurrentPlayer.GameOver();
	}
Begin:
	HUDmessage();
}

defaultproperties
{
	HoleNum=0
	PlayerControllerClass=class'DGPlayerController'
	DefaultPawnClass=class'DGPawn'
	HUDType=class'DGHUD'
}