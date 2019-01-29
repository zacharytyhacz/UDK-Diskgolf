class DGPawnBag extends Actor abstract;

var DGPlayerController 			MyOwner;
var array< class<DGDisk> >		aDisks;
var int							MaxDisks; // max amount of disks in bag

function bool AddDisk(class<DGDisk> theDisk) 
{
	local int i;
	
	if(aDisks.Length < MaxDisks)
	{
		for ( i = 0; i < aDisks.Length; i++) // search array for disk if it not ther
		{
			if (aDisks[i] == theDisk) // if the disk is already there...
			{
				return false; // do not add
			}
		}
		aDisks.AddItem(theDisk);
		//theDisk.CreateOwner(MyOwner);
		return true;
	}
	else {
		`log("no room in " $ self $" for " $ theDisk);
		return false;
	}
}

function class<DGDisk> GetDisk()
{
	return aDisks[0];
}

defaultproperties
{
	aDisks(0)=class'DGDisk'
	aDisks(1)=class'DGDisk'
	aDisks(2)=class'DGDisk'
	aDisks(3)=class'DGDisk'
	aDisks(4)=class'DGDisk'
}