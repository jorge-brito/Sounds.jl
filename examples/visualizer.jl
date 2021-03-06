using Sounds
using FFTW

# music = Sound( joinpath(homedir(), "Music", "Ogg", "music2.ogg") )
music = Sound(joinpath(@__DIR__, "piano.wav"))
N = length(music)

try
    play!(music)
    let n = 1, fftsize = 128, decorator = "▬"
        while isplaying(music)
            # get the current sample offset
            n = samplepos(music)
            a = max(1, n - fftsize ÷ 2)
            b = min(N, n + fftsize ÷ 2)
            f = abs.(fft(music[a:b]))
            average = sum(f) / length(f)
            println(decorator ^ floor(Int, average / 1000))
        end
    end
finally
    stop!(music)
end