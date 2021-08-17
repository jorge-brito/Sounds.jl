module Sounds

using CSFML, CSFML.LibCSFML

export AbstractSound
export SoundObject

export Music
export Sound
export SoundBuffer

export stop!
export pause!
export play!

export volume!
export pitch!
export offset!

abstract type SoundObject{T} end
abstract type AbstractSound{T} <: SoundObject{T} end

function Base.unsafe_convert(::Type{Ptr{T}}, x::SoundObject{T}) where {T}
    return getfield(x, :ptr)
end

include("utils.jl")
include("soundbuffer.jl")
include("sound.jl")
include("music.jl")

end # Sound
