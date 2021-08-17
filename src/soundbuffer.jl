struct SoundBuffer <: SoundObject{sfSoundBuffer}
    ptr::Ptr{sfSoundBuffer}
end

function SoundBuffer(file::AbstractString)
    ptr = sfSoundBuffer_createFromFile(file)
    ptr == C_NULL && error("Couldn't create SoundBuffer from file '$file'")
    return SoundBuffer(ptr)
end

function SoundBuffer(samples::AbstractArray{Int16}, count, channels, samplerate)
    ptr = sfSoundBuffer_createFromSamples(samples, count, channels, samplerate)
    ptr == C_NULL && error("Couldn't create SoundBuffer from samples.")
    return SoundBuffer(ptr)
end

function SoundBuffer(samples::AbstractArray{Int16})
    return SoundBuffer(samples, length(samples), 2, 44100)
end

destroy!(this::SoundBuffer)     = sfSoundBuffer_destroy(this)

"""
        channels(buffer::SoundBuffer) -> Int32

Get the number of channels used by the sound. 
"""
channels(buffer::SoundBuffer)     = sfSoundBuffer_getChannelCount(buffer)

"""
        duration(buffer::SoundBuffer) -> Int64

Get the total `duration` of the sound.
"""
duration(buffer::SoundBuffer)     = sfSoundBuffer_getDuration(buffer).microseconds / s

"""
        sampleCount(buffer::SoundBuffer) -> Int32

Get the number of samples stored in the `buffer`.
"""
sampleCount(buffer::SoundBuffer)  = sfSoundBuffer_getSampleCount(buffer)

"""
        samplerate(buffer::SoundBuffer) -> Int32

Get the `sample rate` of the sound.

The sample rate is the number of samples played per second. The higher, 
the better the quality (for example, 44100 samples/s is CD quality).
"""
samplerate(buffer::SoundBuffer)   = sfSoundBuffer_getSampleRate(buffer)

"""
        samples(buffer::SoundBuffer) -> Vector{Int16}
  
Get the array of audio samples stored in the `buffer`.

The format of the returned samples is 16 bits signed 
integer (Int16). The total number of samples in 
this array is given by the [`sampleCount`](@ref) function.
"""
function samples(buffer::SoundBuffer)::Vector{Int16}
    N = sampleCount(buffer)
    ptr = sfSoundBuffer_getSamples(buffer)
    data = zeros(Int16, N)
    unsafe_copyto!(pointer(data), ptr, N)
    return data
end