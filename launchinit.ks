//Single stage to orbit (uncircularized)
CLEARSCREEN.
SET pitch to 90. //Point towards zenith. 
SAS OFF.
stageflag ON. 
mainloop ON.
function stagecheck //Crude staging logic. If thrust drops to 0, stage.
{
    if STAGE:NUMBER > 0
    {
        WHEN MAXTHRUST = 0 THEN
        {   
            {
                PRINT "Staging..".
                STAGE.
                WAIT 1. //Wait for 1 second before trying to stage again.
                PRESERVE.
            }
        }
    }
     else
        {
            PRINT "At stage 0".
            SET stageflag to OFF.   
            IF MAXTHRUST = 0 
            {
                mainloop OFF.
                PRINT "Primary engines out of fuel. Aborting program".        
            }
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
UNTIL mainloop 
{
    UNTIL SHIP:ALTITUDE > 10000
    {
        IF MOD(SHIP:ALTITUDE,1000) = 0
           {
               SET pitch to pitch - 5.
               PRINT "Pitch " + pitch.         //Pitch 45 degrees in 9000m
           }
        if stageflag
        {
            stagecheck().
        }
    }
    UNTIL SHIP:ALTITUDE > 70000 
    {
        IF MOD(SHIP:ALTITUDE,1000) = 0 
            {
                SET pitch to pitch - 5.
                PRINT "Pitch " + pitch.        
            }
        //Pitch 45 degrees in 9000m. This block cannot be put into a function.
        //The overheads of function calls causes the CPU to not register 
        //the correct altitude at the time to evaluate the new pitch angle.
        if stageflag
        {
            stagecheck().
        }
    }
}
SAS ON.
SET SHIP:CONTROL:PILOTMAINTHROTTLE to 1.
PRINT "Stability assist ON. User has control.".

//pitch is global
//stagecheck function conditional
//abort script on running out of engine power in last stage.