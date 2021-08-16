module Sounds

using CSFML, CSFML.LibCSFML

export AbstractSound
export Music
export Sound
export play
export pause
export stop
export seconds
export miliseconds

seconds(t) = t / 1_000_000
miliseconds(t) = t / 1000

const Status = Dict(
    sfPlaying => :playing,
    sfPaused => :paused,
    sfStopped => :stopped,
)

abstract type AbstractSound end

function Base.show(io::IO, sound::T) where T <: AbstractSound
    print(io, "$T:\n")
    fields = fieldnames(T)
    for field in fields
        value = getproperty(sound, field)
        println(io, "   $field: $value")
    end
end

function setprops!(this::AbstractSound, props)
    for (key, value) in pairs(props)
        setproperty!(this, key, value)
    end
end


mutable struct Music <: AbstractSound
    ptr::Ptr{sfMusic}
end

const MusicProps = (
    :status,
    :volume,
    :offset,
    :attenuation,
    :duration,
    :channels,
    :loop,
    :looppoints,
    :samplerate,
    :pitch,
    :progress,
)
Base.fieldnames(::Type{Music}) = MusicProps
Base.fieldcount(::Type{Music}) = length(MusicProps)

function Base.getproperty(this::Music, p::Symbol)
    ptr = getfield(this, :ptr)
    p == :ptr         && return ptr
    p == :status      && return Status[ sfMusic_getStatus(ptr) ]
    p == :volume      && return sfMusic_getVolume(ptr)
    p == :offset      && return sfMusic_getPlayingOffset(ptr).microseconds
    p == :attenuation && return sfMusic_getAttenuation(ptr)
    p == :duration    && return sfMusic_getDuration(ptr).microseconds
    p == :channels    && return sfMusic_getChannelCount(ptr)
    p == :loop        && return sfMusic_getLoop(ptr) == sfTrue
    p == :looppoints  && return sfMusic_getLoopPoints(ptr)
    p == :samplerate  && return sfMusic_getSampleRate(ptr)
    p == :pitch       && return sfMusic_getPitch(ptr)
    p == :progress    && return this.offset / this.duration
    error("type Music has no field $p")
end

function Base.setproperty!(this::Music, p::Symbol, v)
    ptr = getfield(this, :ptr)
    p == :volume      && return sfMusic_setVolume(ptr, v)
    p == :offset      && return sfMusic_setPlayingOffset(ptr, sfTime(v))
    p == :attenuation && return sfMusic_setAttenuation(ptr, v)
    p == :loop        && return sfMusic_setLoop(ptr, v ? sfTrue : sfFalse)
    p == :looppoints  && return sfMusic_setLoopPoints(ptr, v)
    p == :pitch       && return sfMusic_setPitch(ptr, v)
    error("type Music has no setter for field $p")
end

function Music(path::AbstractString; kwargs...)
    sound = sfMusic_createFromFile(path)
    sound == C_NULL && error("Error loading music from '$path'")
    this = Music(sound)
    setprops!(this, kwargs)
    return this
end

mutable struct Sound <: AbstractSound
    buffer::Ptr{sfSoundBuffer}
    ptr::Ptr{sfSound}
end

const SoundProps = (
    :status,
    :volume,
    :offset,
    :attenuation,
    :duration,
    :channels,
    :loop,
    :samplerate,
    :pitch,
    :progress,
)

Base.fieldnames(::Type{Sound}) = SoundProps
Base.fieldcount(::Type{Sound}) = length(SoundProps)

function Base.getproperty(this::Sound, p::Symbol)
    ptr = getfield(this, :ptr)
    buffer = getfield(this, :buffer)
    p == :ptr         && return ptr
    p == :buffer      && return buffer
    p == :status      && return Status[ sfSound_getStatus(ptr) ]
    p == :volume      && return sfSound_getVolume(ptr)
    p == :offset      && return sfSound_getPlayingOffset(ptr).microseconds
    p == :attenuation && return sfSound_getAttenuation(ptr)
    p == :duration    && return sfSoundBuffer_getDuration(buffer).microseconds
    p == :channels    && return sfSoundBuffer_getChannelCount(buffer)
    p == :loop        && return sfSound_getLoop(ptr) == sfTrue
    p == :samplerate  && return sfSoundBuffer_getSampleRate(buffer)
    p == :pitch       && return sfSound_getPitch(ptr)
    p == :progress    && return this.offset / this.duration
    error("type Sound has no field $p")
end

function Base.setproperty!(this::Sound, p::Symbol, v)
    ptr = getfield(this, :ptr)
    if p == :buffer
        sfSound_setBuffer(ptr, v)
        this.buffer = v
        return nothing
    end
    p == :volume      && return sfSound_setVolume(ptr, v)
    p == :offset      && return sfSound_setPlayingOffset(ptr, sfTime(v))
    p == :attenuation && return sfSound_setAttenuation(ptr, v)
    p == :loop        && return sfSound_setLoop(ptr, v ? sfTrue : sfFalse)
    p == :pitch       && return sfSound_setPitch(ptr, v)
    error("type Sound has no setter for field $p")
end

function Sound(path::AbstractString; kwargs...)
    buffer = sfSoundBuffer_createFromFile(path)
    buffer == C_NULL && error("Error loading sound file '$path'")
    sound = sfSound_create()
    sfSound_setBuffer(sound, buffer)
    this = Sound(buffer, sound)
    setprops!(this, kwargs)
    return this
end

function Sound(samples::AbstractArray{Int16}, size = length(samples), channels = 2, samplerate = 44100; kwargs...)
    buffer = sfSoundBuffer_createFromSamples(samples, size, channels, samplerate)
    buffer == C_NULL && error("Error creating sound buffer")
    sound = sfSound_create()
    sfSound_setBuffer(sound, buffer)
    this = Sound(buffer, sound)
    setprops!(this, kwargs)
    return this
end

play(this::Music) = sfMusic_play(this.ptr)
play(this::Sound) = sfSound_play(this.ptr)
pause(this::Music) = sfMusic_pause(this.ptr)
pause(this::Sound) = sfSound_pause(this.ptr)
stop(this::Music) = sfMusic_stop(this.ptr)
stop(this::Sound) = sfSound_stop(this.ptr)
destroy!(this::Music) = sfMusic_destroy(this.ptr)

function destroy!(this::Sound)
    sfSoundBuffer_destroy(this.buffer)
    sfSound_destroy(this.ptr)
end

end # Sound
