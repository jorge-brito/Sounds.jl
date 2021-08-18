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

function getbuffer(sound::Sound)
    if !isnothing(sound.buffer)
        return sound.buffer
    else
        error("sound object doesn't have a SoundBuffer")
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

loop!(sound::Sound, loop::Bool) = sfSound_setLoop(sound, loop ? sfTrue : sfFalse)
islooping(sound::Sound) = sfSound_getLoop(sound) == sfTrue

timepos!(sound::Sound, offset::Integer) = sfSound_setPlayingOffset(sound, sfTime(offset))
timepos(sound::Sound) = sfSound_getPlayingOffset(sound).microseconds
samplepos(sound::Sound) = timeToSamples(timepos(sound), samplerate(sound), nchannels(sound))

volume!(sound::Sound, volume::Real) = sfSound_setVolume(sound, volume)
volume(sound::Sound) = sfSound_getVolume(sound)

pitch(sound::Sound) = sfSound_getPitch(sound)
pitch!(sound::Sound, pitch::Real) = sfSound_setPitch(sound, pitch)

getstatus(sound::Sound) = Status[ sfSound_getStatus(sound) ]

play!(sound::Sound)  = sfSound_play(sound)
stop!(sound::Sound)  = sfSound_stop(sound)
pause!(sound::Sound) = sfSound_pause(sound)

nchannels(this::Sound)    = nchannels(getbuffer(this))
duration(this::Sound)     = duration(getbuffer(this))
getsamples(this::Sound)   = getsamples(getbuffer(this))
nsamples(this::Sound)     = nsamples(getbuffer(this))
samplerate(this::Sound)   = samplerate( getbuffer(this))

isplaying(sound::Sound) = getstatus(sound) == :playing
ispaused(sound::Sound)  = getstatus(sound) == :paused
isstopped(sound::Sound) = getstatus(sound) == :stopped

getprops(sound::Sound) = (
    loop = islooping(sound),
    status = getstatus(sound),
    timepos = timepos(sound),
    volume = volume(sound),
    pitch = pitch(sound),
    channels = nchannels(sound),
    duration = duration(sound),
    nsamples = nsamples(sound),
    samplerate = samplerate(sound),
)

function Base.show(io::IO, sound::Sound)
    d = round(1e-6 * duration(sound), digits = 2)
    n = nchannels(sound)
    sr = round(1e-3 * samplerate(sound), digits = 1)
    print(io, "Sound ♫ $(d)s ($(sr)kHz, $(n)-channels)")
end

Base.getindex(sound::Sound, idx...) = getindex(getbuffer(sound), idx...)

Base.size(sound::Sound) = size(getbuffer(sound))
Base.length(sound::Sound) = length(getbuffer(sound))

Base.firstindex(::SoundBuffer) = firstindex(getbuffer(sound))
Base.lastindex(sound::Sound) = lastindex(getbuffer(sound))

Base.first(sound::Sound) = first(getbuffer(sound))
Base.last(sound::Sound)  = last(getbuffer(sound))

FFTW.fft(sound::Sound) = fft(getbuffer(sound)[:])
FFTW.ifft(sound::Sound) = ifft(getbuffer(sound)[:])