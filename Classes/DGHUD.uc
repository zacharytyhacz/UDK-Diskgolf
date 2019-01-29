class DGHUD extends HUD;

var int Score;
var int Total;

var int CurrentHole;
var int TotalHoles;

var bool bGameOver;

function DrawHUD()
{
    Super.DrawHUD(); 
   
    Canvas.Font = class'Engine'.static.GetLargeFont();
    Canvas.SetPos(60,40,0);
    Canvas.SetDrawColor(255,255,255);
    Canvas.DrawText("Score This Round: " $ Score);
	
	Canvas.Font = class'Engine'.static.GetLargeFont();
    Canvas.SetPos(60,100,0);
    Canvas.SetDrawColor(255,100,100);
    Canvas.DrawText("Total Score: " $ Score+Total);
	if(bGameOver)
	{
		Canvas.Font = class'Engine'.static.GetLargeFont();
		Canvas.SetPos(300,200,0);
		Canvas.SetDrawColor(0,255,0);
		Canvas.DrawText("CONGRATS YOU WIN! YOUR FINAL SCORE IS"@ Total);
	}
	
	Canvas.Font = class'Engine'.static.GetLargeFont();
    Canvas.SetPos(60,150,0);
    Canvas.SetDrawColor(255,255,255);
    Canvas.DrawText("Hole Number: " $ CurrentHole $ " / "$ TotalHoles);
}

defaultproperties
{
	bGameOver = false
}