using Lynx
using Luxor
using Sounds

music = Sound(joinpath(@__DIR__, "piano.wav"))
colors = ("#9241F1", "#7711EE")
margin = 0.1
time = Lynx.Observable(0)
duration = floor(Int, music.duration / 10e5)

@show music

buttons = (
    play = Button(w -> play(music), "media-playback-start", :Button),
    pause = Button(w -> pause(music), "media-playback-pause", :Button),
    stop = Button(w -> stop(music), "media-playback-stop", :Button),
)

canvas = Canvas(hexpand = true) do dt, canvas
    w, h = size(canvas)
    m = clamp(w * margin, 5, 10)
    p = mapr(music.progress, 0, 1, m, w - m)
    p1, p2 = Point(m, h/2), Point(p, h/2)
    time[] = floor(Int, music.offset / 10e5)
    
    background("#fff")
    sethue(colors[1])
    setline(10)
    setlinecap("round")

    @layer begin
        setopacity(0.5)
        line(p1, Point(w - m, h/2), :stroke)
    end

    line(p1, p2, :stroke)
    sethue(colors[2])
    circle(p2, 10, :fill)
end

onmousedrag(canvas) do event
    pause(music)
    w, h = size(canvas)
    m = clamp(w * margin, 5, 10)
    p1, p2 = Point(m, h/2), Point(w - m, h/2)
    x = floor(Int, event.x)
    p = floor(Int, mapr(x, p1.x, p2.x, 0, music.duration))
    music.offset = clamp(p, 0, music.duration)
end

onmouseup(canvas) do event
    if music.status == :paused
        play(music)
    end
end

app = Window("Play sound", 800, 50,
    Box(:h, spacing = 10, margin = 10,
        buttons.play,
        buttons.pause,
        canvas,
        Label("", label = map(x -> "$(x)s / $(duration)s", time)),
        buttons.stop,
    ) # Grid
) # Window

@on app.destroy() do args...
    Sounds.destroy!(music)
end

@showall app; nothing