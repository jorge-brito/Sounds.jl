const Maybe{T} = Union{Nothing, T}

const Status = Dict(
    sfPlaying => :playing,
    sfPaused => :paused,
    sfStopped => :stopped,
)

const ms = 1
const s = 1000
const m = 60s