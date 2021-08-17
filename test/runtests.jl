# using Test
using Sounds

sound = Sound(joinpath(@__DIR__, "piano.wav"))
music = Music(joinpath(@__DIR__, "piano.wav"))

@show sound
Sounds.showprops(sound)

@show music
Sounds.showprops(music)