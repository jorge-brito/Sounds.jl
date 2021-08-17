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

offset!(music::Music, offset::Integer)  = sfMusic_setPlayingOffset(music, sfTime(offset * 10e2))
volume!(music::Music, volume::Real)     = sfMusic_setVolume(music, volume)
loop!(music::Music, loop::Bool)         = sfMusic_setLoop(music, loop ? sfTrue : sfFalse)
pitch!(music::Music, pitch::Real)       = sfMusic_setPitch(music, pitch)

volume(music::Music) = sfMusic_getVolume(music)
status(music::Music) = Status[ sfMusic_getStatus(music) ]
loop(music::Music)   = sfMusic_getLoop(music) == sfTrue
pitch(music::Music)  = sfMusic_getPitch(music)
offset(music::Music)  = sfMusic_getPlayingOffset(music).microseconds / 10e2

play!(music::Music)  = sfMusic_play(music)
stop!(music::Music)  = sfMusic_stop(music)
pause!(music::Music) = sfMusic_pause(music)

duration(music::Music)     = sfMusic_getDuration(music).microseconds / 10e2
samplerate(music::Music)   = sfMusic_getSampleRate(music)

const MusicProps = (
    :status,
    :volume,
    :loop,
    :pitch,
    :duration,
    :samplerate,
    :offset,
)

Base.show(io::IO, ::Music) = print(io, "Music ♫")

function showprops(music::Music)
    lines = String[""] 
    for prop in MusicProps
        value = music |> getfield(Sounds, prop)
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