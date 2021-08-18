module Sounds

using CSFML, CSFML.LibCSFML
using FFTW

export AbstractSound
export SoundObject

export Music
export Sound
export SoundBuffer

export duration
export getsamples
export getstatus
export getbuffer
export islooping
export ispaused
export isplaying
export isstopped
export loop!
export nchannels
export nsamples
export pause!
export pitch
export pitch!
export play!
export samplepos
export samplerate
export stop!
export timepos
export timepos!
export volume
export volume!

export getprops
export showprops

abstract type SoundObject{T} end
abstract type AbstractSound{T} <: SoundObject{T} end

function Base.unsafe_convert(::Type{Ptr{T}}, x::SoundObject{T}) where {T}
    return getfield(x, :ptr)
end

include("utils.jl")
include("methods.jl")
include("soundbuffer.jl")
include("sound.jl")
include("music.jl")

end # Sound
