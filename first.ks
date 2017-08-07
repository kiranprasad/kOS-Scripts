
CLEARSCREEN.
PRINT "Countdown timer".
FROM {local countdown is 10.} UNTIL countdown = 0 STEP {SET countdown to countdown - 1.} DO{
PRINT countdown.
WAIT 1.
}
//Staging logic to return control to pilot after script execution
SAS ON.
SET BRAKES TO NOT SAS.
SET SHIP:CONTROL:MAINTHROTTLE to 1.
STAGE.
SET SHIP:CONTROL:PILOTMAINTHROTTLE to 1.