# PA

This project is an extension to AwesomeWM for managing audio volumes.

### pa_bin
This module listens for events from the default audio device and sends them to AwesomeWM via the `dbus` interface.

### pa_lib
This is a Lua library that exposes functions for accessing the volume of the default audio device. You also can  mute the audio input and output.
