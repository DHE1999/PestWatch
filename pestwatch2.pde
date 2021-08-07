PImage ferret, cat, rat, magpie, kiwi, tuatara, morepork, kea, pest, background;
ArrayList<PImage> pests = new ArrayList<PImage>();
ArrayList<PImage> natives = new ArrayList<PImage>();
ArrayList<distraction> distractions = new ArrayList<distraction>();
ArrayList<scoreboard> scoreboards = new ArrayList<scoreboard>();
int w = 1280;
int h = 800;
int gameState = 0;
float startTime, countdown, showTime, clickTime;
float clickCountdown = 2000;
float randX = random(50, w - 50); 
float randY = random(50, h - 50);
float guessX, guessY, tutScore, distBetweenClick, score, lastScore;
float dist;
boolean guessed, guessedTut;
int round = 20;
PFont docFont;
int[][] difficulty  = { 
  {1000, 0}, {1000, 1}, {1000, 2}, {1000, 3}, 
  {500, 0}, {500, 1}, {500, 2}, {500, 3}, 
  {250, 0}, {250, 1}, {250, 2}, {250, 3}, 
  {125, 0}, {125, 1}, {125, 2}, {125, 3}, 
  {75, 0}, {75, 1}, {75, 2}, {75, 3}, 
  {35, 0}, {35, 1}, {35, 2}, {35, 3}, {35, 4}, 
};

float visableTime = 0 - difficulty[0][0];
scoreboard sb;
PrintWriter output;

class distraction {
  float x;
  float y;
  PImage img;

  distraction() {
    x = random(100, w - 100);
    y = random(100, h - 100);
    img = natives.get((int)random(natives.size()));
  }

  public void drawDist() {
    image(img, x, y);
  }
}


void setup() {
  size(1280, 800);
  docFont = createFont("Times New Roman", 100);
  frameRate(120);

  for (int b = 0; b <= 1; b++) {
    background = (loadImage("forest.jpg"));
  }
  ferret = loadImage("ferret.png");
  kiwi = loadImage("kiwi.png");
  rat = loadImage("rat.png");
  morepork = loadImage("morepork.png");
  kea = loadImage("kea.png");
  cat = loadImage("cat.png");
  tuatara = loadImage("tuatara.png");
  magpie = loadImage("magpie.png");
  kiwi.resize(0, 70);
  rat.resize(0, 40);
  morepork.resize(0, 80);
  cat.resize(0, 120);
  tuatara.resize(0, 40);
  kea.resize(0, 150);
  magpie.resize(0, 70);
  ferret.resize(0, 55);
  pests.add(ferret);
  pests.add(rat);
  pests.add(magpie);
  pests.add(cat);
  natives.add(kiwi);
  natives.add(tuatara);
  natives.add(kea);
  natives.add(morepork);
  pest = pests.get((int)random(pests.size()));
}

void keyReleased() { 
  if (keyCode == ENTER) {
    if (gameState == 0) {
      sb = new scoreboard();
      scoreboards.add(sb);
      gameState = -1;
    } else if (gameState == 3) { // End Game
      gameState = 0;
    } else if (gameState == -3 && !guessed) {
    } else if (gameState < 1) {
      if (gameState == -3 && guessed) {
        guessed = false;
      }
      forwards(gameState);
      startTime = millis();
    }
  } else if (keyCode == BACKSPACE && gameState < 0) {
    guessed = false;
    backwards(gameState);
    startTime = millis();
  }
}

public void forwards(int oldgameState) {
  if (gameState >= -5) {  
    guessed = false;
    gameState = oldgameState - 1;
  } else {
    gameState = 1;
    guessed = false;
    startTime = millis();
  }
}

public void backwards(int oldgameState) {
  gameState = oldgameState + 1;
}

void keyPressed() {
  if (keyCode == ESC && gameState < 0) {
    key = 0;
    gameState = 1;
    startTime = millis();
  } else if (keyCode == ESC) {
    key = 0;
    gameState = 0;
  }
}

void mouseReleased() { 
  if (gameState == 2 && !guessed && countdown < -500) { // Guess phase and has not made a guess yet
    startTime = millis();
    guessed = true;
    guessX = mouseX;
    guessY = mouseY;
  } else if (gameState == -3 || gameState == -5 && !guessed && countdown < -500) {
    clickTime = millis();
    guessX = mouseX;
    guessY = mouseY;
    guessed = true;
    if (gameState == -3) {
      gameState = -4;
    }
  }
}

void draw() {
  noCursor();
  textFont(docFont);

  if (gameState == 0) { // Only draws home screen content when on gameState = 0
    strokeWeight(0);
    image(background, 0, 0, w, h); // Only draws background when the game has started  
    fill(255, 255, 255, 150);
    rect(350, 180, 880, 500, 100);  

    textFont(docFont);
    fill(0);
    textSize(100);
    text("Pest Watch!", w/2 - 250, (h/2) - 100);

    textSize(30);
    text("A educational game to test your psychophysical abilities ", w/2 - 250, 0 + (h/2));
    textSize(18);
    text("perosnal performance data will be collected annonymously for performance analysis. ", w/2 - 250, 150 + (h/3) + 20);


    textSize(50);
    text("Press 'Enter' to start", w/2 - 250, h - 200);
    displayScore();
    drawTarget();
  } else if (gameState == -1) { // Tutorial
    drawTut();
    textSize(30);
    text("1. Each round one random pest will appear briefly after 3 seconds, then disappear.", 50, 0 + (h/3));
    text("    There are four types of pest: ", 50, 60 + (h/3));
    textSize(25);    
    noFill();
    strokeWeight(1);
    text("    Ferret:", 50, 400);
    tint(255, 200);
    ellipse(180 + ferret.width/2, 370+ferret.height/2, 100, 100);
    image(ferret, 180, 370);

    text("    Cat:", 50 + 280, 400);
    ellipse(420 + cat.width/2, 330+cat.height/2, 100, 100);
    image(cat, 160 + 260, 330);

    text("    Rat:", 50 + 600, 400);
    ellipse(740 + rat.width/2, 370+rat.height/2, 100, 100);
    image(rat, 160 + 580, 370);

    text("    Magpie:", 50 + 900, 400);
    ellipse(1090 + magpie.width/2, 350+magpie.height/2, 100, 100);
    image(magpie, 160 + 930, 350);

    textSize(30);    
    text("    And there are four native species:", 50, h - (h/3));

    textSize(25);
    text("    Kiwi:", 50, 630);
    image(kiwi, 160, 600);
    text("    Tuatara:", 50 + 280, 630);
    image(tuatara, 160 + 320, 600);
    text("    Kea:", 50 + 600, 630);
    image(kea, 160 + 600, 540);
    text("    Morepork:", 50 + 900, 630);
    image(morepork, 160 + 960, 590);
    noTint();

    drawTarget();
  } else if (gameState == -2) {
    drawTut();
    text("   For Example: ", 50, 0 + (h/3));
    countdown = 3000 - (millis() - startTime);
    if (countdown > 0) {
      drawClock(countdown, w/2, h/2);
    } else if (0 > countdown && countdown > -1000) {
      tint(255, 200);
      image(ferret, 200, 650); // DRAW example possom same place each time
      noTint();
    } else {
      gameState = -3;
    }
    drawTarget();
  } else if (gameState == -3) { // Tutorial
    drawTut();
    textSize(100);
    text("Tutorial", 50, 100);
    textSize(30);
    text("2. Now you must remember and try click with the mouse where you think the pest appeared.", 50, 0 + (h/3));
    text("    - You must guess before continuing! ", 50, 30 + (h/3));
    text("    - You may only make one guess each round! ", 50, 60 + (h/3));

    if (guessed) {   
      drawShot();
    }
    drawTarget();
  } else if (gameState == -4) { // Tutorial
    drawTut();
    textSize(30);
    text("3. Each round you will also get a score based on:", 50, 0 + (h/3));
    textSize(25);
    text("        - how close you are to the centre of the pest position", 50, h/3 + 30);
    text("        - other difficulty factors", 50, h/3 + 60);
    if (guessed) {
      drawAnswer(ferret, 200, 650);
      drawDistance();
      drawShot();
    }
    drawTarget();
  } else if (gameState == -5) { // Tutorial
    drawTut();
    textSize(30);
    text("4. The difficulty will increase each round, for example try this repeatable mock round:", 50, 0 + h/3);
    textSize(25);
    text("        - The pest is visable for less time!", 50, h/3 + 30);
    text("        - Native species are shown to distract you!", 50, h/3 + 60);
    text("        - It doesn't matter how long you take to guess!", 50, h/3 + 90);
    countdown = 3000 - (millis() - startTime);
    if (countdown > 0) {
      drawClock(countdown, w/2, h/2);
    } else if (0 > countdown && countdown > -500) {
      tint(255, 200);
      image(rat, 1000, 400); 
      noTint();
      image(tuatara, 400, 650); 
      image(kiwi, 50, 550); 
      image(morepork, 370, 100);
      image(kea, 1100, 500);
    } else if (guessed && clickCountdown > 0) {
      /* SCORE & RESET PHASE */
      clickCountdown = 2000 - (millis() - clickTime); 
      image(tuatara, 400, 650); 
      image(kiwi, 50, 550); 
      image(morepork, 370, 100);
      image(kea, 1100, 500);

      drawAnswer(rat, 1000, 400);

      drawShot();

      drawDistance();
    } else if (clickCountdown < 0 && guessed) {
      startTime = millis();
      clickCountdown = 2000;
      guessed = false;
    }
    drawTarget();
  } else if (gameState == -6) { // Tutorial
    drawTut();
    textSize(30);
    text(" You will now get 25 rounds to play and calculate your final score", 50, 0 + h/3);
    textSize(25);
    text("        - After this, You cannot pause the game!", 50, h/3 + 30);
    text("        - Remember, your score is only based on accuracy not speed, Good luck!", 50, h/3 + 60);
    drawTarget();
  }

  /* WAIT PHASE */
  else if (gameState == 1) {
    if (round == 25) {
      gameState = 3; 
      round = 20;
      saveScores();
    } else {    
      hud();

      if (countdown > 0) {
        drawClock(countdown, w/2, h/2);
      }

      /* WATCH PHASE */
      else if (countdown < visableTime) { // Making the visable time any less than 50 milliseconds means that it won't reach the time
        println("Actual time visable vs desired time visable: " + countdown + ":" + visableTime);      
        //text(nf(countdown, 0, 0), w/2, h/2);
        drawDistractions();
        tint(255, 200);
        image(pest, randX, randY); // If not enought time passes then they will be shown the pest for minimum time possible for the system to run a loop
        noTint();
        gameState = 2;
      } else {
        drawDistractions();
        tint(255, 200);
        image(pest, randX, randY);
        noTint();
      }
    }
  }

  /* GUESS PHASE */
  else if (gameState == 2) {
    hud();

    countdown = 3000 - (millis() - startTime); // Start counting down again so can start next round (3 seconds)

    /* SCORE & RESET PHASE */
    if (guessed && countdown > 0) {
      drawDistractions();
      drawAnswer(pest, randX, randY);
      drawShot();
      drawDistance();
    } else {
      drawTarget();
    }

    if (countdown < 0 && guessed) {
      sb.addDistance(dist);
      sb.addXpos(randX - pest.width/2);
      sb.addYpos(randY - pest.height/2);
      if (pest == ferret) {
        sb.addPestType("ferret");
      } else if (pest == rat) {
        sb.addPestType("rat");
      } else if (pest == magpie) {
        sb.addPestType("magpie");
      } else {
        sb.addPestType("cat");
      }

      gameState = 1; // Go back to wait phase
      startTime = millis(); // Have to reset the time so that the countdown starts again
      guessed = false; // Reset that the player has guessed
      randX = random(100, w - 100); // Resetting the  location of the next ferret 
      randY = random(100, h - 100);
      pest = pests.get((int)random(pests.size()));
      round += 1;
      if (round < 25) {
        visableTime = 0 - difficulty[round][0];
        initializeDistractions(difficulty[round][1]);
      }
    }
  } else if (gameState == 3) {
    image(background, 0, 0, w, h);
    strokeWeight(0);

    fill(255, 255, 255, 150);
    rect(0, 0, w, h);

    fill(0);  

    textSize(100);
    text("Finish", w/2-130, h/2);   
    textSize(30);
    text("Total Score: " + scoreboards.get(scoreboards.size()-1).totalDistance(), w/2 - 130, h/2+100);


    textSize(30);
    text("Press 'Enter' to continue", w/2 - 150, h - 20);
    drawTarget();
  }
}

public void initializeDistractions(int nd) {
  distractions.clear();
  for (int d = 0; d < nd; d++) {
    distractions.add(new distraction());
  }
}

public void drawDistractions() {
  for (distraction d : distractions) {
    d.drawDist();
  }
}


public void hud() {
  image(background, 0, 0, w, h);
  countdown = 3000 - (millis() - startTime);
  strokeWeight(0);
  fill(255, 100);
  rect(0, 0, 380, 40);
  fill(0);
  textSize(25);
  text("Round: " + (round+1) + "/25", 10, 30);
  text("Total Score: " + int(sb.totalDistance()), 200, 30);

  drawTarget();
}

public void drawAnswer(PImage target, float xPos, float yPos) {
  dist = sqrt(abs(sq((xPos + pest.width/2) - guessX))+abs(sq((yPos + (pest.height/2)) - guessY)));
  if (dist < 50) {
    fill(50, 200, 50, 100);
    strokeWeight(3);
    stroke(50, 200, 0);
  } else {
    fill(200, 50, 50, 100);
    strokeWeight(3);
    stroke(200, 50, 0);
  }
  ellipse(xPos + target.width/2, yPos + target.height/2, 100, 100);
  tint(255, 200);
  image(target, xPos, yPos);
  noTint();
  strokeWeight(4);
  stroke(0);
  line(xPos + target.width/2, yPos + target.height/2, guessX, guessY);
  strokeWeight(0);
}

public void drawDistance() {
  stroke(0);
  strokeWeight(0);
  fill(255, 200);
  rect(w/2 - 50, h/2 - 40, 130, 60, 9);

  textSize(30);
  fill(0);
  text(int(dist), w/2, h/2);
}

public void drawShot() {
  strokeWeight(3);
  stroke(200, 50, 50);
  line(guessX - 10, guessY - 10, guessX + 10, guessY + 10);
  line(guessX + 10, guessY - 10, guessX - 10, guessY + 10);
  strokeWeight(0);
}


public void drawTut() {
  strokeWeight(0);
  image(background, 0, 0, w, h); 

  fill(255, 255, 255, 150);
  rect(0, 0, w, h);

  fill(0);  

  textSize(100);
  text("Tutorial", 50, 100);

  textSize(30);
  text("Press 'Enter' to continue", w - 350, h - 20);
  text("Press 'Backspace' to go back", 50, h - 20);
  text("Press 'Esc' to skip", 70, 140);
}

public void drawClock(float countdown, float x, float y) {
  noStroke();
  fill(255, 255, 255, 100);
  ellipse(x + 14, y - 17, 100, 100);
  fill(0);
  textSize(60);
  text(nf(int(countdown/1000)+1, 0, 0), x, y);
}

public void drawTarget() {
  stroke(0);
  fill(255, 100);
  strokeWeight(1);
  ellipse(mouseX, mouseY, 100, 100);
  fill(0);
  line(mouseX, mouseY + 50, mouseX, mouseY - 50);
  line(mouseX + 50, mouseY, mouseX - 50, mouseY);
}

class scoreboard {
  FloatList distances;
  FloatList xPoses;
  FloatList yPoses;
  StringList pestTypes;


  public scoreboard() {
    distances = new FloatList();
    xPoses = new FloatList();
    yPoses = new FloatList();
    pestTypes = new StringList();
    distances.append(0);
    xPoses.append(0);
    yPoses.append(0);
    pestTypes.append("");
  }

  public float totalDistance() {
    float total = 0.0;
    for (float s : distances) {
      total = s + total;
    }
    return total;
  }

  public FloatList getScores() {
    return distances;
  }
  public FloatList getYposes() {
    return yPoses;
  }
  public FloatList getXposes() {
    return xPoses;
  }
  public StringList getTypes() {
    return pestTypes;
  }

  public void addXpos(float xpos) {
    xPoses.append(xpos);
  }

  public void addYpos(float ypos) {
    yPoses.append(ypos);
  }

  public void addPestType(String pestType) {
    pestTypes.append(pestType);
  }

  public void addDistance(float dist) {
    distances.append(dist);
  }
}

public void displayScore() {
  fill(255, 255, 255, 150);
  rect(20, 180, 300, 500, 100);
  fill(0);
  textSize(30);
  text("High Scores", 70, 230);
  for (scoreboard sbs : scoreboards) {
    textSize(20);
    int i = 1 + scoreboards.indexOf(sbs);
    text((i) + ") " + int(sbs.totalDistance()), 70, 230 + ((i) * 30));
  }
}

public void saveScores() {
  output = createWriter("scores.txt");  
  output.println("game, round, distFromTarget, distFromCentre, floatX, floatY, typeOfPest");
  for (scoreboard scoreb : scoreboards) {
    FloatList distances = scoreb.getScores();
    FloatList yPoses = scoreb.getYposes();  
    FloatList xPoses = scoreb.getXposes();
    StringList pestTypes = scoreb.getTypes();

    for (int i = 0; i < distances.size(); i++) {
      if (i != 0) {
        float distanceFromCentre = sqrt(abs(sq(xPoses.get(i) - w/2))+abs(sq(yPoses.get(i) - h/2)));
        output.println(scoreboards.indexOf(scoreb) + ", " + i + ", " + distances.get(i) +  ", " + distanceFromCentre + ", " + xPoses.get(i) + ", " + yPoses.get(i) +  ", " + pestTypes.get(i));
      }
    }
    
  }
  output.flush();
  output.close();
}
