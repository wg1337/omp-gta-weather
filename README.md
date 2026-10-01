# What is it?

A simple include that provides the weather cycles and weather regions extracted from "gta-reversed". Using this include you can recreate singleplayer-like weather inside open.mp. Note that weather cycle interpolation is done on the client side.

# How to use it

Check weather.pwn

# How it works?

GTA:SA does not randomly select a weather, but rather follows a strict cycle in specific regions and advances the weather when the hour changes. This include uses the same logic, but applies the weather per-player and updates it whenever either the hour changes or the player has entered a different weather region. This include requires a mechanism that can advance the weather, the given example with weather.pwn recreates the singleplayer's clock advancement along with weather cycle advancement.
