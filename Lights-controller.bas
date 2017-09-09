'--------------------------------------------------------------
'                   Thomas Jensen | uCtrl.io
'--------------------------------------------------------------
'  file: AVR_LIGHTS_CONTROLLER_v1.0
'  date: 12/03/2006
'--------------------------------------------------------------

$regfile = "attiny2313.dat"
$crystal = 8000000
Config Portd = Input
Config Portb = Output
Config Watchdog = 1024

Dim Utgang1 As Integer
Dim Utgang2 As Integer
Dim Utgang3 As Integer
Dim Ut1 As Integer
Dim Ut2 As Integer
Dim Ut3 As Integer
Dim Lifesignal As Integer
Dim A As Byte

Lifesignal = 21
Utgang1 = 0
Utgang2 = 0
Utgang3 = 0
Ut1 = 0
Ut2 = 0
Ut3 = 0

Portb = 0

For A = 1 To 6
    Portb.3 = Not Portb.3
    Portb.4 = Not Portb.4
    Portb.5 = Not Portb.5
    Portb.6 = Not Portb.6
    Waitms 200
Next A

Waitms 1000
Start Watchdog
Portb = 0

Main:
'output1
If Pind.0 = 0 Then
   Utgang1 = Utgang1 + 1
   Portb.3 = Portb.0
   If Utgang1 = 11 And Ut1 = 0 Then
      Portb.0 = Not Portb.0
      Portb.3 = Portb.0
      Utgang1 = 0
      Ut1 = 1
      End If
   End If

'output2
If Pind.1 = 0 Then
   Utgang2 = Utgang2 + 1
   Portb.4 = Portb.1
   If Utgang2 = 11 And Ut2 = 0 Then
      Portb.1 = Not Portb.1
      Portb.4 = Portb.1
      Utgang2 = 0
      Ut2 = 1
      End If
   End If

'output3
If Pind.2 = 0 Then
   Utgang3 = Utgang3 + 1
   Portb.5 = Portb.2
   If Utgang3 = 11 And Ut3 = 0 Then
      Portb.2 = Not Portb.2
      Portb.5 = Portb.2
      Utgang3 = 0
      Ut3 = 1
      End If
   End If

'turn of LEDs and reset variables when push-button not active
If Pind.0 = 1 Then
   Ut1 = 0
   Utgang1 = 0
   Portb.3 = 0
   End If
If Pind.1 = 1 Then
   Ut2 = 0
   Utgang2 = 0
   Portb.4 = 0
   End If
If Pind.2 = 1 Then
   Ut3 = 0
   Utgang3 = 0
   Portb.5 = 0
   End If

'flashing LEDs
If Pind.3 = 0 Then
   Waitms 50
   Portb.3 = 1
   Portb.4 = 1
   Portb.5 = 1
End If

'flashing grønn
If Pind.4 = 0 Then
   Waitms 50
   Portb.3 = 1
End If

'flashing rød
If Pind.5 = 0 Then
   Waitms 50
   Portb.4 = 1
End If

'turn everything off
If Pind.6 = 0 Then
   Portb.0 = 0
   Portb.1 = 0
   Portb.2 = 0
End If

'lifesignal
If Lifesignal > 0 Then Lifesignal = Lifesignal - 1
If Lifesignal = 6 Then Portb.7 = 1
If Lifesignal = 1 Then Portb.7 = 0
If Lifesignal = 0 Then Lifesignal = 21

'loop cycle
Reset Watchdog
Portb.6 = 1
Waitms 25
Portb.6 = 0
Waitms 75
Goto Main
End