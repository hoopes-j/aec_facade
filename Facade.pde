int MOVE = 0;
int SCALE = 1;
int FADE = 2;


class Facade {

    int boundX = 40;
    int boundY = 22;

    color[][] pixels;
    
    ArrayList<Hole> holes;
    Hole mainHole;

    int frameCount = 0;

    int startCount = 0;
    int startTimeMS = 5000;
    int startTimeFrames;

    ArrayList<Integer> movementIntervals;
    ArrayList<Integer> aniCounters;

    boolean startAnimation = false;

    Facade() {
        pixels = new color[boundX][boundY];
        holes = new ArrayList<Hole>();
        movementIntervals = new ArrayList<Integer>();
        aniCounters = new ArrayList<Integer>();

        startTimeFrames = toFrames(startTimeMS);
    }

    void startupFade() {

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
        
        // Draw main window;
        if (mainHole!=null) {
            mainHole.draw();
        }

        for (int i = 0; i < boundX; i++) {
            for (int j = 0; j < boundY; j++) {
                pixel(i,j,pixels[i][j]);
            }
        }
    }

    void animateMultipleWindows() {

        while (holes.size()<4) {
            Hole hole = new Hole();
            hole.size = new PVector(1,1);

            // hole.pos 
            hole.fadeIn();
            this.holes.add(hole);
            this.movementIntervals.add(0);
            this.aniCounters.add(0);
            // movementInterval = random()
        }


        for (int i = 0; i < holes.size(); i++) {
            Hole hole = this.holes.get(i);
            if (!hole.isAnimating()) {
                int choice = 4;
                if (choice == MOVE) {
                    PVector velocity = new PVector(random(10),random(10)-5);
                    PVector newPos = addVector(hole.pos, velocity);
                    movementIntervals.set(i,toFrames(int(1000+random(1000))));
                    hole.moveTimeFrames=movementIntervals.get(i);
                    hole.move(newPos); 
                }
                else if (choice == SCALE) {
                    PVector newSize = new PVector(3+random(7),3+random(7));
                    movementIntervals.set(i,toFrames(int(1000+random(1000))));
                    hole.sizeTimeFrames=movementIntervals.get(i);
                    hole.scale(newSize); 
                }
                else if (choice == FADE) {
                    hole.echo();
                }
                else if (choice == 4) {
                    PVector velocity = new PVector(random(10),random(10)-5);
                    PVector newPos = addVector(hole.pos, velocity);
                    movementIntervals.set(i,toFrames(int(1000+random(1000))));
                    hole.moveTimeFrames=movementIntervals.get(i);
                    hole.move(newPos); 
                    PVector newSize = new PVector(3+random(7),3+random(7));
                    hole.sizeTimeFrames=100;
                    hole.scale(newSize); 
                }
            }
            else {
                int counter = aniCounters.get(i);
                println("animation running", counter, i);
                aniCounters.set(i, counter+1);
                if (aniCounters.get(i)>=movementIntervals.get(i)) {
                    println("animation over");
                    // activeAnimation = false;
                }
            } 
        }

    }

    void animate() {

        animateMultipleWindows();
        

        // if (mainHole==null) {
        //     mainHole = new Hole();
        //     mainHole.size = new PVector(1,1);
        //     mainHole.pos = new PVector(10,5);

        //     // hole.pos 
        //     mainHole.fadeIn();
        //     // movementInterval = random()
        // }




        // if (!activeAnimation) {  
        //     println("starig whaaa"); 
        //     int choice = int(random(3));
        //     if (choice == MOVE) {
        //         PVector velocity = new PVector(random(10),random(10)-5);
        //         PVector newPos = addVector(mainHole.pos, velocity);
        //         movementInterval = toFrames(int(1000+random(1000)));
        //         mainHole.moveTimeFrames=movementInterval;
        //         mainHole.move(newPos); 
        //     }
        //     else if (choice == SCALE) {
        //         PVector newSize = new PVector(3+random(7),3+random(7));
        //         movementInterval = toFrames(int(1000+random(1000)));
        //         mainHole.sizeTimeFrames=movementInterval;
        //         mainHole.scale(newSize); 
        //     }
        //     else if (choice == FADE) {

        //     }

        //     activeAnimation = true;
        //     frameCount=0;
        // }
        // else {
        //     println("animation running", frameCount);
        //     frameCount++;
        //     if (frameCount>=movementInterval) {
        //         println("animation over");
        //         activeAnimation = false;
        //     }
        // }

        // if (frameCount==toFrames(6000)) {
        //     println("start moving");
        //     // get the last added hole

        //     PVector velocity = new PVector(5,0);
        //     PVector newPos = addVector(hole.pos, velocity);
        //     hole.move(newPos);
        // }

        // if (frameCount==toFrames(9000)) {
        //     println("changing size");
        //     // get the last added hole
        //     Hole hole = holes.get(holes.size()-1);
        //     PVector _newSize = new PVector(7,7);
        //     hole.scale(_newSize);
        // }

        // // if (frameCount==toFrames(4000)) {
        // //     println("spitting");
        // //     Hole hole = holes.get(holes.size()-1);
        // //     hole.echo();
        // // }

        // if (frameCount==toFrames(1200)) {
        //     println("changing size");
        //     // get the last added hole
        //     Hole hole = holes.get(holes.size()-1);
        //     PVector _newSize = new PVector(7,7);
        //     hole.scale(_newSize);
        // }

    }

    int wrapX(int _x) {
        return _x%this.boundX;
    }
    int wrapX(float _x) {
        return int(_x%this.boundX);
    }
    int wrapY(int _y) {

        if (_y>=0) {
            return int(_y%this.boundY);
        }
        else {
            int _tmp = 0;
            while (_tmp<0) {
                _tmp = boundY+_y;
            }
            return _tmp;
        }

    }


    void drawRect(int x, int y, int w, int h, color c) {
        for (int i = 0; i < w; i++) {
            for (int j = 0; j < h; j++) {
                int _x = facade.wrapX(i+x);
                int _y = facade.wrapY(j+y);
                facade.pixels[_x][_y] = c;
            }
        } 
    }

    void drawRect(PVector _pos, PVector _size, color c) {
        // for (int i = 0; i < int(currSize.x); i++) {
        //     for (int j = 0; j < int(currSize.y); j++) {
        //         int _x = facade.wrapX(i+int(currPos.x));
        //         int _y = facade.wrapY(j+int(currPos.y));
        //         facade.pixels[_x][_y] = c;
        //     }
        // }
        for (int i = 0; i < int(_size.x); i++) {
            for (int j = 0; j < int(_size.y); j++) {
                int _x = facade.wrapX(i+int(_pos.x));
                int _y = facade.wrapY(j+int(_pos.y));
                facade.pixels[_x][_y] = c;
            }
        }
    }

    void rectOutline(PVector _pos, PVector _size, color c) {

        int x =int(_pos.x);
        int y =int(_pos.y);
        int w =int(_size.x);
        int h =int(_size.y);

        for (int i = 0; i < w; i++) {
            for (int j = 0; j < h; j++) {

                int _x = facade.wrapX(i+x);
                int _y = facade.wrapY(j+y);

                if (_x == x || _y == y || _x == x+w-1 || _y == y+h-1) {
                    facade.pixels[_x][_y] = c;
                }
            }
        }
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
    int sizeTimeMS = 500;
    int sizeTimeFrames;

    // int moveCounter==;


    // Echo animations
    ArrayList<PVector> echoes;

    Boolean activeAnimation;


    Hole() {
        this.pos = new PVector(random(40), random(22));
        this.nextPos = this.pos.copy();
        this.size = new PVector(1,1);

        this.fadeTimeFrames = toFrames(fadeTimeMS);
        this.moveTimeFrames = toFrames(moveTimeMS);
        this.sizeTimeFrames = toFrames(sizeTimeMS);

        echoes = new ArrayList<PVector>();
        
        this.closed = false;
        this.activeAnimation = false;
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
        else if (this.closed) {
            c = color(255,255,255);
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
            println(animationPos);
            currSize = PVector.lerp(this.size, this.nextSize, animationPos);
        } 



        facade.drawRect(currPos, currSize, c);
        // facade.rectOutline(currPos, currSize, color(255,0,0));

        if (fadeOut || fadeIn) {
            fadeCount++;
            if (fadeCount>=fadeTimeFrames) {
                println("done");
                if (fadeOut) {
                    closed = true;
                }
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

        if (echoes.size() > 0) {
            for (PVector echo: echoes) {
                PVector sizeDiff = subVector(currSize, echo);
                PVector echoPos = currPos.copy();
                echoPos.x += sizeDiff.x/2;
                echoPos.y += sizeDiff.y/2;

                float area = map(vecArea(echo), 0, vecArea(currSize),0,255);
                color echoColor = color(area);
                facade.rectOutline(echoPos, echo, echoColor);
            }
            updateEchoes();
        }
    }



    void fadeIn() {
        closed = false;
        this.fadeIn = true;
        this.activeAnimation = true;
    }

    void fadeOut() {
        this.fadeOut = true;
        this.activeAnimation = true;
    }

    void move(PVector _newPos) {
        this.nextPos = _newPos;
        this.moving = true;
    }

    void echo() {
        PVector newEcho = this.size.copy();
        echoes.add(newEcho);
    }

    void updateEchoes() {
        for (int i = 0; i < echoes.size(); i++) {
            PVector echo = echoes.get(i);
            echo.x -= 1;
            echo.y -= 1;
            if (echo.x <= 0 || echo.y <= 0) {
                echoes.remove(i);
            }
            else {
                echoes.set(i, echo);
            }
        }
    }

    void scale(PVector _newSize) {
        this.nextSize = _newSize;
        this.changingSize = true;
    }

    boolean isAnimating() {
        return this.fadeOut || this.fadeIn || this.changingSize || this.moving;
    }


    void travel(PVector _newPos) {
        

    }
}
