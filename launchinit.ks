//Single stage to orbit (uncircularized)
CLEARSCREEN.
local pitch is 90.
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
UNTIL SHIP:ALTITUDE < 10000
{
IF SHIP:ALTITUDE>=1000
{
    IF MOD(SHIP:ALTITUDE,200) = 0
    {
        SET pitch to pitch - 1.         //Pitch 45 degrees in 9000m
        SET STEERING to HEADING(90,pitch).
    }
}
}

//TODO: Single burn to circular orbit. Pitch to horizon accounting for atmospheric drag.

LOCK STEERING to HEADING(90,pitch).
SAS ON.
SET SHIP:CONTROL:PILOTMAINTHROTTLE to 1.
PRINT "Stability assist ON. User has control.".
