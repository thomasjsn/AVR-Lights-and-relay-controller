'--------------------------------------------------------------
'                   Thomas Jensen | stdout.no
'--------------------------------------------------------------
'  file: AVR_LIGHTS_CONTROLLER_v1.2
'  date: 28/03/2007
'--------------------------------------------------------------

$regfile = "attiny2313.dat"
$crystal = 4000000
Config Portd = Input
Config Portb = Output
Config Watchdog = 1024

Dim Utgang1 As Byte , Utgang2 As Byte , Utgang3 As Byte
Dim Ut1 As Bit , Ut2 As Bit , Ut3 As Bit , Led As Byte
Dim Lifesignal As Byte , Ir_timer As Byte
Dim Alt_av As Integer , Lys_timer As Integer
Dim Led_timer As Byte , Led1_timer As Byte
Dim Eeprom_save As Byte , Eeprom_value As Eram Byte

Portb = 0

For Ir_timer = 1 To 15                                      'boot
    Portb.3 = Not Portb.3
    Portb.4 = Not Portb.4
    Portb.5 = Not Portb.5
    Portb.6 = Not Portb.6
    Waitms 200
Next Ir_timer

Ir_timer = 0
Lifesignal = 21

Waitms 1000
Start Watchdog
Portb = Eeprom_value
Portb.3 = 0
Portb.4 = 0
Portb.5 = 0
Portb.6 = 0
Portb.7 = 0

Main:
If Pind.0 = 0 Then                                          'output 1
   Alt_av = 0
   Lys_timer = 0
   Incr Utgang1
   Led = 21
   If Utgang1 = 11 And Ut1 = 0 Then
      Portb.0 = Not Portb.0
      Utgang1 = 0
      Ut1 = 1
      Eeprom_save = 51
      End If
   End If

If Pind.1 = 0 Then                                          'output 2
   Alt_av = 0
   Incr Utgang2
   Led = 21
   If Utgang2 = 11 And Ut2 = 0 Then
      Portb.1 = Not Portb.1
      Utgang2 = 0
      Ut2 = 1
      Eeprom_save = 51
      End If
   End If

If Pind.2 = 0 Then                                          'output 3
   Alt_av = 0
   Incr Utgang3
   Led = 21
   If Utgang3 = 11 And Ut3 = 0 Then
      Portb.2 = Not Portb.2
      Utgang3 = 0
      Ut3 = 1
      Eeprom_save = 51
      End If
   End If


If Pind.0 = 1 Then                                          'turn of leds and reset
   Ut1 = 0                                                  'var if inactive switch
   Utgang1 = 0
   End If
If Pind.1 = 1 Then
   Ut2 = 0
   Utgang2 = 0
   End If
If Pind.2 = 1 Then
   Ut3 = 0
   Utgang3 = 0
   End If

If Led > 0 Then Decr Led                                    'led timer
If Led > 1 Then
   Portb.3 = Portb.0
   Portb.4 = Portb.1
   Portb.5 = Portb.2
   End If
If Led = 1 Then
   Portb.3 = 0
   Portb.4 = 0
   Portb.5 = 0
   End If

If Pind.3 = 0 Then Ir_timer = 31                            'ir sensor timer
If Ir_timer > 0 Then Decr Ir_timer

If Pind.5 = 0 And Portb.0 = 0 Then                          'auto light on
   Portb.0 = 1
   Lys_timer = 1201
   Eeprom_save = 51
End If
If Ir_timer > 0 And Lys_timer > 0 Then Lys_timer = 1201

If Lys_timer > 0 And Led1_timer = 0 Then                    'auto light led
   If Ir_timer = 0 Then Led1_timer = 11
   If Ir_timer > 0 Then Led1_timer = 7
   End If
If Led1_timer > 0 Then Decr Led1_timer
If Led1_timer = 6 Then Portb.3 = 1
If Led1_timer = 1 Then Portb.3 = 0

If Lys_timer > 0 Then Decr Lys_timer                        'auto light
If Lys_timer = 1 Then
   Portb.0 = 0
   Eeprom_save = 51
   End If

If Pind.6 = 0 Then                                          'lights out, everything off
   Portb.0 = 0
   Portb.1 = 0
   Portb.2 = 0
   Alt_av = 0
   Lys_timer = 0
   Eeprom_save = 51
End If

If Pind.4 = 0 Then Alt_av = 451                             'set lights out 45s var

If Alt_av > 0 And Led_timer = 0 Then                        'lights out 45s leds
   If Alt_av > 100 Then Led_timer = 16
   If Alt_av <= 100 Then Led_timer = 6
   End If
If Led_timer > 0 Then Decr Led_timer
If Led_timer = 3 Then
   Portb.3 = 1
   Portb.4 = 1
   Portb.5 = 1
   End If
If Led_timer = 1 Then
   Portb.3 = 0
   Portb.4 = 0
   Portb.5 = 0
   End If

If Alt_av > 0 Then Decr Alt_av                              'lights out 45s timer
If Alt_av = 1 Then
   Lys_timer = 0
   Portb.0 = 0
   Portb.1 = 0
   Portb.2 = 0
   Eeprom_save = 51
   End If

If Eeprom_save > 0 Then Decr Eeprom_save                    'eeprom save
If Eeprom_save = 1 Then Eeprom_value = Portb

If Lifesignal > 0 Then Decr Lifesignal                      'lifesignal
If Lifesignal = 6 Then
   Portb.7 = 1
   Portb.6 = 1
   End If
If Lifesignal = 1 Then
   Portb.7 = 0
   Portb.6 = 0
   End If
If Lifesignal = 0 Then Lifesignal = 21

Reset Watchdog                                              'loop cycle
Waitms 100
Goto Main
End