mutable struct Sound <: AbstractSound{sfSound}
    ptr::Ptr{sfSound}
    buffer::Maybe{SoundBuffer}
    
    function Sound()
        ptr = sfSound_create()
        ptr == C_NULL && error("Couldn't create Sound object.")
        this = new(ptr, nothing)
        finalizer(this) do obj
            try
                !isnothing(obj.buffer) && destroy!(obj.buffer)
                destroy!(obj)
            finally
                return
            end
        end
        return this
    end
    
    function Sound(file::AbstractString)
        this = Sound()
        setbuffer!(this, SoundBuffer(file))
        return this
    end
end

destroy!(sound::Sound) = sfSound_destroy(sound)
"""
        setbuffer!(sound, buffer::SoundBuffer) -> Nothing

Set the source buffer containing the audio data to play.
"""
function setbuffer!(sound::Sound, buffer::SoundBuffer)
    sound.buffer = buffer
    sfSound_setBuffer(sound, buffer)
end

"""
        loop!(sound, loop::Bool) -> Nothing

Set whether or not the sound should loop after reaching the end.
"""
loop!(sound::Sound, loop::Bool) = sfSound_setLoop(sound, loop ? sfTrue : sfFalse)

"""
        offset!(sound, offset::Integer) -> Nothing

Change the current playing position of the `sound`. 

The playing position can be changed when the sound is either paused or playing.
Changing the playing position when the sound is stopped has no effect, since 
playing the sound will reset its position.
"""
offset!(sound::Sound, offset::Integer) = sfSound_setPlayingOffset(sound, sfTime(offset * s))

"""
        offset(sound::Sound) -> Int64

Get the current playing position of the `sound`. 
"""
offset(sound::Sound) = sfSound_getPlayingOffset(sound).microseconds / s

"""
        volume!(sound, volume::Real) -> Nothing

Set the `volume` of the `sound`.

The volume is a value between ``0`` (mute) and ``100`` (full volume). The default value for the volume is ``100``.
"""
volume!(sound::Sound, volume::Real) = sfSound_setVolume(sound, volume)

"""
        volume(sound) -> Float32[0:100]

Get the volume of the sound. 
"""
volume(sound::Sound) = sfSound_getVolume(sound)

"""
        status(sound::Sound) -> Symbol

Get the current status of the `sound` (stopped, paused, playing) 
"""
status(sound::Sound) = Status[ sfSound_getStatus(sound) ]

"""
        loop(sound::Sound) -> Bool

Tell whether or not the `sound` is in `loop` mode.
"""
loop(sound::Sound) = sfSound_getLoop(sound) == sfTrue

"""
        pitch(sound::Sound) -> Float32

Get the pitch of the `sound`. 
"""
pitch(sound::Sound) = sfSound_getPitch(sound)

"""
        pitch!(sound::Sound) -> Float32

Set the `pitch` of the `sound`. 

The pitch represents the perceived fundamental frequency of a sound; 
thus you can make a sound more acute or grave by changing its pitch. 
A side effect of changing the pitch is to modify the playing speed 
of the sound as well. The default value for the pitch is 1.
"""
pitch!(sound::Sound, pitch::Real) = sfSound_setPitch(sound, pitch)

"""
        play!(sound::Sound) -> Nothing

Start or resume playing the `sound`. 
"""
play!(sound::Sound) = sfSound_play(sound)

"""
        stop!(sound::Sound) -> Nothing

Stop playing the `sound`. 

This function stops the sound if it was playing or paused, 
and does nothing if it was already stopped. It also resets 
the playing position (unlike [`pause`](@ref)).
"""
stop!(sound::Sound) = sfSound_stop(sound)

"""
        pause!(sound::Sound) -> Nothing

Pause the `sound`. 

This function pauses the sound if it was playing, 
otherwise (sound already paused or stopped) it has 
no effect.
"""
pause!(sound::Sound) = sfSound_pause(sound)

channels(this::Sound)     = channels(this.buffer)
duration(this::Sound)     = duration(this.buffer)
samples(this::Sound)      = samples(this.buffer)
sampleCount(this::Sound)  = sampleCount(this.buffer)
samplerate(this::Sound)   = samplerate(this.buffer)

const SoundProps = (
    :status,
    :loop,
    :volume,
    :pitch,
    :channels,
    :duration,
    :samplerate,
    :offset,
)

Base.show(io::IO, ::Sound) = print(io, "Sound ♫")
    
function showprops(sound::Sound)
    lines = String[""] 
    for prop in SoundProps
        value = sound |> getfield(Sounds, prop)
        line = ""
        if prop == :status
            emoji = value == :playing ? "▶️" : value == :stopped ? "⏹" : "⏸"
            line *= "status: $value $emoji"
        else
            line *= "$prop: $value"
        end
        push!(lines, line)
    end
    println(join(lines, "\n"))
end