//Single stage to orbit (uncircularized)
CLEARSCREEN.
local pitch is 90. //Point towards zenith. 
SAS OFF.

function stagecheck //Crude staging logic. If thrust drops to 0, stage.
{
    WHEN MAXTHRUST = 0 THEN
    {
        PRINT "Staging..".
        STAGE.
        WAIT 1. //Wait for 1 second before trying to stage again.
        PRESERVE.
    }
}


FROM {local countdown is 10.} UNTIL countdown = 0 STEP {SET countdown to countdown - 1.} DO{
PRINT countdown.
WHEN countdown = 3 THEN
{
    SET SHIP:CONTROL:MAINTHROTTLE to 1.
    LOCK STEERING to HEADING(90,pitch). 
    PRINT "Ship throttle at maximum".
}
WAIT 1.
}
STAGE.
PRINT "Liftoff".

UNTIL SHIP:ALTITUDE > 10000
{
    stagecheck().
     WHEN MOD(SHIP:ALTITUDE,1000) = 0 THEN
        {
            SET pitch to pitch - 5.
            PRINT "Pitch " + pitch.         //Pitch 45 degrees in 9000m
        }
}
UNTIL SHIP:ALTITUDE > 70000 
{
    stagecheck().
    WHEN MOD(SHIP:ALTITUDE,1000) = 0 THEN
        {
            SET pitch to pitch - 5.
            PRINT "Pitch " + pitch.         //Pitch 45 degrees in 9000m. This block cannot be put into a function.
                                            //The overheads of function calls causes the CPU to not register 
                                            //the correct altitude at the time to evaluate the new pitch angle.
        }
}
SAS ON.
SET SHIP:CONTROL:PILOTMAINTHROTTLE to 1.
PRINT "Stability assist ON. User has control.".