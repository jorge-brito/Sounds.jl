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

function samplesptr(buffer::SoundBuffer)
    return sfSoundBuffer_getSamples(buffer)
end

function getsamples(buffer::SoundBuffer)::Vector{Int16}
    N = nsamples(buffer)
    data = zeros(Int16, N)
    unsafe_copyto!(pointer(data), samplesptr(buffer), N)
    return data
end

function Base.getindex(buffer::SoundBuffer, idx...)
    N = nsamples(buffer)
    data = unsafe_wrap(Vector{Int16}, samplesptr(buffer), N)
    return getindex(data, idx...)
end

Base.size(buffer::SoundBuffer) = Int(nsamples(buffer))
Base.length(buffer::SoundBuffer) = size(buffer)

Base.firstindex(::SoundBuffer) = 1
Base.lastindex(buffer::SoundBuffer) = length(buffer)

Base.first(buffer::SoundBuffer) = buffer[ firstindex(buffer) ]
Base.last(buffer::SoundBuffer)  = buffer[ lastindex(buffer) ]

FFTW.fft(buffer::SoundBuffer) = fft(buffer[:])
FFTW.ifft(buffer::SoundBuffer) = ifft(buffer[:])