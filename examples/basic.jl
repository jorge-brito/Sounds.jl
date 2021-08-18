using Sounds

lines, cols = displaysize(stdout)

clear() = join(repeat([""], cols), "\n") |> print
ft(t) = string(round(Int, 1e-6t)) * "s"

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
        t = timepos(sound)
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