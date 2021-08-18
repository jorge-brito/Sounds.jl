using Test
using Sounds

@testset "Sound" begin
    sound = Sound(joinpath("..", "examples", "piano.wav"))
    @show sound

    @test duration(sound)   == 32e6
    @test nchannels(sound)  == 2
    @test samplerate(sound) == 44100
    @test nsamples(sound)   == 2822400
    @test timepos(sound)    == 0
    @test getstatus(sound)  == :stopped

    @test islooping(sound) == false
    loop!(sound, true)
    @test islooping(sound) == true

    @test volume(sound) == 100
    volume!(sound, 50)
    @test volume(sound) == 50

    @test pitch(sound) == 1.0
    pitch!(sound, 2.0)
    @test pitch(sound) == 2
end

@testset "Music" begin
    music = Music(joinpath("..", "examples", "piano.wav"))
    @show music

    @test duration(music)   == 32e6
    @test nchannels(music)  == 2
    @test samplerate(music) == 44100
    @test timepos(music)    == 0
    @test getstatus(music)  == :stopped

    @test islooping(music) == false
    loop!(music, true)
    @test islooping(music) == true

    @test volume(music) == 100
    volume!(music, 50)
    @test volume(music) == 50

    @test pitch(music) == 1.0
    pitch!(music, 2.0)
    @test pitch(music) == 2
end