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

destroy!(this::SoundBuffer) = sfSoundBuffer_destroy(this)
nchannels(buffer::SoundBuffer) = Int(sfSoundBuffer_getChannelCount(buffer))
duration(buffer::SoundBuffer) = sfSoundBuffer_getDuration(buffer).microseconds
nsamples(buffer::SoundBuffer) = sfSoundBuffer_getSampleCount(buffer)
samplerate(buffer::SoundBuffer) = Int(sfSoundBuffer_getSampleRate(buffer))

function getsamples(buffer::SoundBuffer)::Vector{Int16}
    N = nsamples(buffer)
    ptr = sfSoundBuffer_getSamples(buffer)
    data = zeros(Int16, N)
    unsafe_copyto!(pointer(data), ptr, N)
    return data
end