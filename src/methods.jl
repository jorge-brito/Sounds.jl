"""
        destroy!(sound::SoundObject) -> Nothing

Deletes the `sound` object.
"""
function destroy! end
"""
        nchannels(sound::AbstractSound) -> Int32

Get the number of channels used by the `sound`. 
"""
function nchannels end
"""
        samplerate(sound::SoundObject) -> Int32

Get the `sample rate` of the sound.

The sample rate is the number of samples played per second. The higher, 
the better the quality (for example, 44100 samples/s is CD quality).
"""
function samplerate end
"""
        duration(sound::SoundObject) -> Int64

Get the total `duration` of the sound in microseconds.
"""
function duration end
"""
        nsamples(sound | buffer) -> Int32

Get the number of samples stored in the `buffer`.
"""
function nsamples end
"""
        getsamples(sound | buffer) -> Vector{Int16}
  
Get the array of audio samples stored in the `buffer`.

The format of the returned samples is 16 bits signed 
integer (Int16). The total number of samples in 
this array is given by the [`nsamples`](@ref) function.
"""
function getsamples end

"""
        play!(sound::AbstractSound) -> Nothing

Start or resume playing the `sound`. 
"""
function play! end
"""
        pause!(sound::AbstractSound) -> Nothing

Pause the `sound`. 

This function pauses the sound if it was playing, 
otherwise (sound already paused or stopped) it has 
no effect.
"""
function pause! end
"""
        stop!(sound::AbstractSound) -> Nothing

Stop playing the `sound`. 

This function stops the sound if it was playing or paused, 
and does nothing if it was already stopped. It also resets 
the playing position (unlike [`pause`](@ref)).
"""
function stop! end

"""
        isplaying(sound::AbstractSound) -> Bool

Returns true if the `sound` is playing, `false` otherwise.
"""
function isplaying end
"""
        ispaused(sound::AbstractSound) -> Bool

Returns true if the `sound` is paused, `false` otherwise.
"""
function ispaused end
"""
        isstopped(sound::AbstractSound) -> Bool

Returns true if the `sound` is stopped, `false` otherwise.
"""
function isstopped end

"""
        timepos!(sound::AbstractSound, offset::Integer) -> Nothing

Change the current playing position of the `sound`. 

The playing position can be changed when the sound is either paused or playing.
Changing the playing position when the sound is stopped has no effect, since 
playing the sound will reset its position.
"""
function timepos! end
"""
        timepos(sound::AbstractSound) -> Int64

Get the current playing position of the `sound` in microseconds. 
"""
function timepos end
"""
        volume!(sound::AbstractSound, volume::Real) -> Nothing

Set the `volume` of the `sound`.

The volume is a value between ``0`` (mute) and ``100`` (full volume). The default value for the volume is ``100``.
"""
function volume! end
"""
        volume(sound::AbstractSound) -> Float32[0:100]

Get the volume of the sound. 
"""
function volume end
"""
        pitch!(sound::AbstractSound) -> Float32

Set the `pitch` of the `sound`. 

The pitch represents the perceived fundamental frequency of a sound; 
thus you can make a sound more acute or grave by changing its pitch. 
A side effect of changing the pitch is to modify the playing speed 
of the sound as well. The default value for the pitch is 1.
"""
function pitch! end
"""
        pitch(sound::AbstractSound) -> Float32

Get the pitch of the `sound`. 
"""
function pitch end
"""
        loop!(sound::AbstractSound, loop::Bool) -> Nothing

Set whether or not the sound should loop after reaching the end.
"""
function loop! end
"""
        islooping(sound::AbstractSound) -> Bool

Returns `true` if the `sound` is in `loop` mode, `false` otherwise.
"""
function islooping end
"""
        getstatus(sound::AbstractSound) -> Symbol

Get the current status of the `sound` (stopped, paused, playing) 
"""
function getstatus end