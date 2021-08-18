mutable struct Music <: AbstractSound{sfMusic}
    ptr::Ptr{sfMusic}
    function Music(file::AbstractString)
        ptr = sfMusic_createFromFile(file)
        ptr == C_NULL && error("Couldn't create Music object from file '$file'.")
        this = new(ptr)
        finalizer(this) do obj
            try
                destroy!(obj)
            finally
                return
            end
        end
        return this
    end
end

destroy!(this::Music) = sfMusic_destroy(this)

timepos!(music::Music, offset::Integer)  = sfMusic_setPlayingOffset(music, sfTime(offset))
volume!(music::Music, volume::Real)      = sfMusic_setVolume(music, volume)
loop!(music::Music, loop::Bool)          = sfMusic_setLoop(music, loop ? sfTrue : sfFalse)
pitch!(music::Music, pitch::Real)        = sfMusic_setPitch(music, pitch)

volume(music::Music)    = sfMusic_getVolume(music)
getstatus(music::Music) = Status[ sfMusic_getStatus(music) ]
pitch(music::Music)     = sfMusic_getPitch(music)
timepos(music::Music)   = sfMusic_getPlayingOffset(music).microseconds
islooping(music::Music) = sfMusic_getLoop(music) == sfTrue

play!(music::Music)  = sfMusic_play(music)
stop!(music::Music)  = sfMusic_stop(music)
pause!(music::Music) = sfMusic_pause(music)

isplaying(music::Music) = getstatus(music) == :playing
ispaused(music::Music)  = getstatus(music) == :paused
isstopped(music::Music) = getstatus(music) == :stopped

nchannels(music::Music)  = Int(sfMusic_getChannelCount(music))
duration(music::Music)   = sfMusic_getDuration(music).microseconds
samplerate(music::Music) = Int(sfMusic_getSampleRate(music))

getprops(music::Music) = (
    loop = islooping(music),
    status = getstatus(music),
    timepos = timepos(music),
    volume = volume(music),
    pitch = pitch(music),
    channels = nchannels(music),
    duration = duration(music),
    samplerate = samplerate(music),
)

function Base.show(io::IO, music::Music)
    d = round(1e-6 * duration(music), digits = 2)
    n = nchannels(music)
    sr = round(1e-3 * samplerate(music), digits = 1)
    print(io, "Music ♫ $(d)s ($(sr)kHz, $(n)-channels)")
end