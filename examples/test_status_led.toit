import status-led as LED

/**
This example application test the StatusLed on an "ESP32-C3 Super Mini" device 
with two LEDs.
*/
//  Port definitions
GPIO-ONBOARD-LED ::= 8  // onboard low-active
GPIO-LED-BLUE ::= 10    // external high active

status-led-onboard := LED.StatusLed --gpio=GPIO-ONBOARD-LED --low-active
status-led := LED.StatusLed --gpio=GPIO-LED-BLUE


/**
Prints an optional message and waits some seconds to watch the LED signals.
*/
wait-seconds-to-watch s/int message/string?=null: 
  if message != null: print "- ($s s) \t: $message"
  sleep --ms=s*1_000


/**
Tests the status-leds.
*/
main:
  print "\n\n\nTest StatusLed:"

  status-led-onboard.error
  status-led.on
  wait-seconds-to-watch 10 "onboard: error signal | external: on"

  status-led-onboard.off
  status-led.off
  wait-seconds-to-watch 5 "onboard: off | external: off"


  status-led-onboard.blink --on-ms=200 --off-ms=800 
  wait-seconds-to-watch 0 "onboard: 1 second blink | manual LED control"
  10.repeat:
    status-led.on; sleep --ms=200
    status-led.off; sleep --ms=800


  status-led-onboard.blink
  status-led.blink
  wait-seconds-to-watch 15 "onboard: blink | external: blink"


  DA-DA-DA-DAAAA ::= [[100,250],[100,250],[100,250],[500,1000]]
  status-led.animate DA-DA-DA-DAAAA --repetitions=15
  wait-seconds-to-watch 30 "onboard: 1 second blink | external: 5th symph"


  status-led-onboard.heartbeat 130  // heartbeat blinker with 130 bpm
  status-led.on
  wait-seconds-to-watch 15 "onboard: 120 bpm heartbeat | external: on"

  
  status-led-onboard.heartbeat 50
  status-led.blink --on-ms=20 --off-ms=1980 --repetitions=LED.StatusLed.ENDLESS
  wait-seconds-to-watch 5 "onboard: 50 bpm heartbeat | external: 2s flash"

  while true: sleep --ms=1000