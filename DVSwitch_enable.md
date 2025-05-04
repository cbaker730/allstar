# Steps to edit the ASLv3 node configuration to enable the use of DVSwitch Android app

Note: The case for iax-<callsign> must match between the two files eg iax-wa1usa or iax-WA1USA


Step 1: Edit /etc/asterisk/iax.conf

    ;[iaxclient]                      ; Connect from iax client (Zoiper...)
    ;type = friend                    ; Notice type here is friend <--------------
    ;context = iax-client             ; Context to jump to in extensions.conf
    ;auth = md5
    ;secret = Your_Secret_Password_Here
    ;host = dynamic
    ;disallow = all
    ;allow = ulaw
    ;allow = adpcm
    ;allow = gsm
    ;transfer = no
    
    [<callsign>]                          ; Connect from iax client (Zoiper...)
    type = friend                         ; Notice type here is friend <--------------
    context = iax-<callsign>              ; Context to jump to in extensions.conf - CASE MUST MATCH
    auth = md5
    secret = <password>
    host = dynamic
    disallow = all
    allow = ulaw
    allow = adpcm
    allow = gsm
    transfer = no


Step 2: Edit /etc/asterisk/extensions.conf

    ;[iax-client]                            ; for IAX VoIP clients.
    ;exten => ${NODE},1,Ringing()
    ;       same => n,Wait(10)
    ;       same => n,Answer()
    ;       same => n,Set(CALLSIGN=${CALLERID(name)})
    ;       same => n,NoOp(Caller ID name is ${CALLSIGN})
    ;       same => n,NoOp(Caller ID number is ${CALLERID(number)})
    ;       same => n,GotoIf(${ISNULL(${CALLSIGN})}?hangit)
    ;       same => n,Playback(rpt/connected-to&rpt/node)
    ;       same => n,SayDigits(${NODE})
    ;       same => n,rpt(${NODE}|P|${CALLSIGN}-P)
    ;       same => n(hangit),NoOp(No Caller ID Name)
    ;       same => n,Playback(connection-failed)
    ;       same => n,Wait(1)
    ;       same => n,Hangup
    
    [iax-<callsign>]
    exten => _XXXXX!,1,Ringing()
            same => n,Wait(1)
            same => n,Answer()
            same => n,Set(CALLSIGN=${CALLERID(name)})
            same => n,NoOp(Caller ID name is ${CALLSIGN})
            same => n,NoOp(Caller ID number is ${CALLERID(number)})
            same => n,GotoIf(${ISNULL(${CALLSIGN})}?hangit)
            same => n,Playback(rpt/connected-to&rpt/node)
            same => n,SayDigits(${NODE})
            same => n,rpt(${NODE}|P|${CALLSIGN}-P)
            same => n(hangit),NoOp(No Caller ID Name)
            same => n,Playback(connection-failed)
            same => n,Wait(1)
            same => n,Hangup
