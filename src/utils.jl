const Maybe{T} = Union{Nothing, T}

const Status = Dict(
    sfPlaying => :playing,
    sfPaused => :paused,
    sfStopped => :stopped,
)

function showprops(sound::AbstractSound)
    for (name, value) in pairs(getprops(sound))
        println("$name: $value")
    end
end

function timeToSamples(pos, samplerate, channels)
    samples = ((pos * samplerate * channels) + 500000) / 1e6
    return floor(Int, samples)
end