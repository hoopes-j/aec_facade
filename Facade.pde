
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
        this.fill();

        for (Hole hole : this.holes) {
            hole.draw();
        }

        for (int i = 0; i < boundX; i++) {
            for (int j = 0; j < boundY; j++) {
                pixel(i,j,pixels[i][j]);
            }
        }



        frameCount++;
    }

    void animate() {
        

        if (frameCount==0) {
            Hole hole = new Hole();
            hole.size = new PVector(5,5);

            hole.fadeIn();
            this.addHole(hole);  
        }

        if (frameCount==toFrames(4000)) {
            println("start moving");
            // get the last added hole
            Hole hole = holes.get(holes.size()-1);
            PVector velocity = new PVector(20,10);
            PVector newPos = addVector(hole.pos, velocity);
            hole.move(newPos);
        }

        if (frameCount==toFrames(6000)) {
            println("changing size");
            // get the last added hole
            Hole hole = holes.get(holes.size()-1);
            PVector _newSize = new PVector(3,3);
            hole.changeSize(_newSize);
        }



    }

    int wrapX(int _x) {
        return _x%this.boundX;
    }
    int wrapX(float _x) {
        return int(_x%this.boundX);
    }
    int wrapY(int _y) {
        return _y%this.boundY;
    }


}


class Hole {
    PVector pos;
    PVector size;
    PVector nextSize;

    // New animations
    PVector nextPos;

    Boolean closed;
    Boolean active;






    // Fading animations
    Boolean fadeIn = false;
    Boolean fadeOut = false;

    int fadeCount = 0;
    int fadeTimeMS = 1000;
    int fadeTimeFrames;

    // Movement animations
    Boolean moving = false;

    int moveCount = 0;
    int moveTimeMS = 500;
    int moveTimeFrames;

    // Size animations
    Boolean changingSize = false;

    int sizeCount = 0;
    int sizeTimeMS = 1000;
    int sizeTimeFrames;




    Hole() {
        this.pos = new PVector(random(40), random(22));
        this.nextPos = this.pos.copy();
        this.size = new PVector(1,1);

        this.fadeTimeFrames = toFrames(fadeTimeMS);
        this.moveTimeFrames = toFrames(moveTimeMS);
        this.sizeTimeFrames = toFrames(sizeTimeMS);
    }

    void close() {
        this.size = new PVector(0,0);
        this.closed = true;
    }

    void draw() {


        color c = color(0,0,0);

        // Color Animation for fading
        if (fadeIn) {
            float fadeAmount = map(fadeCount, 0, fadeTimeFrames, 255, 0);
            c = color(fadeAmount);
        }
        else if (fadeOut) {
            float fadeAmount = map(fadeCount, 0, fadeTimeFrames, 0, 255);
            c = color(fadeAmount); 
        }

        // Animation Position
        PVector currPos = this.pos.copy();
        if (moving) {
            float movePos = float(moveCount)/float(moveTimeFrames);
            currPos = PVector.lerp(this.pos, this.nextPos, movePos);
        }

        // Size Animation
        PVector currSize = this.size.copy();
        if (changingSize) {
            println("size", this.size);
            println("next", this.nextSize);
            float animationPos = float(sizeCount)/float(sizeTimeFrames);
        } 


        for (int i = 0; i < int(size.x); i++) {
            for (int j = 0; j < int(size.y); j++) {
                int _x = facade.wrapX(i+int(currPos.x));
                int _y = facade.wrapY(j+int(currPos.y));
                facade.pixels[_x][_y] = c;
            }
        }

        if (fadeOut || fadeIn) {
            fadeCount++;
            if (fadeCount>=fadeTimeFrames) {
                println("done");
                fadeOut = false;
                fadeIn = false;
                fadeCount = 0;
            }
        }
        if (moving) {
            moveCount++;
            if (moveCount>=moveTimeFrames) {
                println("done moving");
                this.pos = this.nextPos.copy();
                moving = false;
                moveCount = 0;
            }
        }
        if (this.changingSize) {
            sizeCount++;
            if (sizeCount>=sizeTimeFrames) {
                println("done changing size");
                this.size = this.nextSize.copy();
                changingSize = false;
                sizeCount = 0;
            }
        }
    }

    void fadeIn() {
        this.fadeIn = true;
    }

    void fadeOut() {
        this.fadeOut = true;
    }

    void move(PVector _newPos) {
        this.nextPos = _newPos;
        this.moving = true;
    }

    void changeSize(PVector _newSize) {
        this.nextSize = _newSize;
        this.changingSize = true;
    }
}