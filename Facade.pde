
class Facade {

    int boundX = 40;
    int boundY = 22;

    color[][] pixels;
    
    ArrayList<Hole> holes;

    int frameCount = 0;

    Facade() {
        pixels = new color[boundX][boundY];
        holes = new ArrayList<Hole>();
    }

    void fill() {

        for (int i = 0; i < boundX; i++) {
            for (int j = 0; j < boundY; j++) {
                this.pixels[i][j] = color(255,255,255);
            }
        }

    }

    void addRandomHole() {
        Hole _hole = new Hole();
        holes.add(_hole);
    }

    void addHole(int x, int y) {
        Hole _hole = new Hole();
        _hole.pos = new PVector(x,y);
    }

    void addHole(Hole hole) {
        holes.add(hole);
    }

    void draw() {

        for (int i = 0; i < boundX; i++) {
            for (int j = 0; j < boundY; j++) {
                pixel(i,j,pixels[i][j]);
            }
        }

        for (Hole hole : this.holes) {
            hole.draw();
        }


    }

    void animate() {

        if (frameCount==0) {
            Hole hole = new Hole();
            hole.size = new PVector(5,5);
            hole.fadeIn();
            this.addHole(hole);  
        }

        // if (frameCount==toFrames(5000)) {
        //     Hole hole = holes.get(holes.size()-1);
        //     PVector velocity = new PVector(-5,0);
        //     hole.move(addVector(hole.size,velocity));
        // }


        frameCount++;
    }


}


class Hole {
    PVector pos;
    PVector size;

    Boolean closed;
    Boolean active;

    Boolean fadeIn = false;
    Boolean fadeOut = false;

    int frameCount = 0;
    int fadeTimeMS = 1000;
    int fadeTimeFrames;


    Hole() {
        this.pos = new PVector(random(40), random(22));
        this.size = new PVector(1,1);

        this.fadeTimeFrames = toFrames(fadeTimeMS);
    }

    void close() {
        this.size = new PVector(0,0);
        this.closed = true;
    }

    void draw() {

        color c = color(0,0,0);
        if (fadeIn) {
            float fadeAmount = map(frameCount, 0, fadeTimeFrames, 255, 0);
            c = color(fadeAmount);
        }
        else if (fadeOut) {
            float fadeAmount = map(frameCount, 0, fadeTimeFrames, 0, 255);
            c = color(fadeAmount); 
        }
        for (int i = 0; i < int(size.x); i++) {
            for (int j = 0; j < int(size.y); j++) {
                facade.pixels[i+int(pos.x)][j+int(pos.y)] = c;
            }
        }



        frameCount++;
        if (frameCount>=fadeTimeFrames) {
            println("done");
            fadeOut = false;
            fadeIn = false;
            frameCount = 0;
        }
    }

    void fadeIn() {
        this.fadeIn = true;
    }

    void fadeOut() {
        this.fadeOut = true;
    }

    void move(PVector _newSize) {
        this.size = _newSize;
    }

    // void expand(pos ) {

    // }

}