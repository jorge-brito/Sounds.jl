using Sounds
using Sounds: m, s, ms
using Sounds: duration, offset, status

lines, cols = displaysize(stdout)

isplaying(music) = status(music) == :playing
clear() = join(repeat([""], cols), "\n") |> print
ft(t) = string(floor(Int, t / s)) * "s"

file = joinpath(@__DIR__, "piano.wav")
sound = Sound(file)
d = duration(sound)

function progress(p::Int, N = 100)
    str = ""
    for n in 1:N
        str *= n > p ?  "░" : "▓"
    end
    return str
end

interval = 0.5

try
    play!(sound)
    while isplaying(sound)
        t = offset(sound)
        pre = ft(t) * " / " * ft(d)
        n = cols - length(pre) - 2
        p = floor(Int, n * t / d)
        clear()
        print(pre, " ", progress(p, n))
        sleep(interval)
    end
finally
    stop!(sound)
end