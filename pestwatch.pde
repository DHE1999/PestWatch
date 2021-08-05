PImage background;
PImage possum;
int w = 1280;
int h = 800;
int gameState = 0;
int startTime;
float randX = random(50, w - 50); 
float randY = random(50, h - 50);
float guessX, guessY;
boolean guessed;
float visableTime = -1000;
scoreboard sb = new scoreboard();

void setup() {
  size(1280, 800);
  frameRate(120);
  background = loadImage("backgrounds/forest3.jpg");
  possum = loadImage("possum.png");
  possum.resize(0, 30);
}

void keyPressed() { 
  if (keyCode == ENTER && gameState == 0) { 
    startTime = millis();
    gameState = 1; // Starts the game when enter is pressed and on home screen (gameState 0)
  }
  if (keyCode == ESC){
    key = 0;
    gameState = 0;
    sb.saveScores();
  }
}

void mouseReleased() { 
  if (gameState == 2 || gameState == -2 && !guessed){ // Guess phase and has not made a guess yet
    startTime = millis();
    guessed = true;
    guessX = mouseX;
    guessY = mouseY;
    //if ((mouseX > randX - 10 && mouseX < randX + 10) && (mouseY > randY - 10 && mouseY < randY + 10)){
    float distBetweenClick = sqrt(abs(sq((randX + possum.width/2) - guessX))+abs(sq((randY +  + possum.height/2) - guessY))); // Calculates the euclidean distance between click and pest location
    float score = distBetweenClick; // abs(visableTime);Score will need to include the time visable???
    float lastScore = sb.getScores().get(sb.getScores().size()-1);
    if (lastScore != 0){ // Don't include the first score as it is a place holder
      if (score >= 100){
        visableTime -= 100; // Increase the time that pest is shown for by 100ms
      }
      else if (score < 100){ // Needs to be within 100 pixels to get more difficult
        visableTime += 100;  // Decrease the time that pest is shown for
      }
    }
    println("This score vs previous score " + score + ":" + lastScore);
    sb.addScore(score);
  }
}

  void draw() {
    noCursor();
    
    if (gameState == 0) { // Only draws home screen content when on gameState = 0
      fill(0);
      background(125);
      
      textSize(100);
      text("Pest Watch", w/2 - 150, (h/2) - 100);

      textSize(30);
      text("Instructions: ", w/2 - 150, 0 + (h/2));
      textSize(15);
      text("1. Each round after three seconds, a pest will appear briefly in a random position and then disappear. ", w/2 - 150, 150 + (h/3) + 20);
      text("2. You must remember and try click with the mouse where you think it appeared", w/2 - 150, 150 + (h/3) + 40);
      text("3. After that, You will get a score based on how close you are to actual position of the pest", w/2 - 150, 150 + (h/3) + 60);
      text("4. The difficulty will increase each round as the following obsticals are added:", w/2 - 150, 150 + (h/3) + 80);
      textSize(13);
      text("- the pest is shown for less time", w/2 - 120, 150 + (h/3) + 100);
      text("- new animals are shown to distract you", w/2 - 120, 150 + (h/3) + 120);
      text("- the visual properties of the pest change to make it harder to see", w/2 - 120, 150 + (h/3) + 140);

      textSize(50);
      text("Press 'Enter' to start", w/2 - 150, h - 130);
      sb.displayScore();
    }
    
    else if (gameState == -1) { // Tutorial mode
      background(255);
      float countdown = 3000 - (millis() - startTime);
      
      drawTarget();
      
      if (countdown > 0) {
        textSize(60);
        text(nf(int(countdown/1000)+1, 0, 0), w/2, h/2);
      }
      
       /* WATCH PHASE */
      else if (countdown < visableTime) { // Making the visable time any less than 50 milliseconds means that it won't reach the time
        fill(255, 0, 0);
        rect(randX, randY, 40, 40); // If not enought time passes then they will be shown the pest for minimum time possible for the system to run a loop
        gameState = -2;
      }
      else {
        fill(255, 0, 0);
        rect(randX, randY, 40, 40);
      }
      
    }
    
        /* GUESS PHASE */
    else if (gameState == -2) {
      background(255);                  
      float countdown = 3000 - (millis() - startTime); // Start counting down again so can start next round (3 seconds)

      /* SCORE & RESET PHASE */
      if (guessed && countdown > 0) {
        noFill();
        strokeWeight(3);
        stroke(200, 50, 0);
        ellipse(guessX, guessY, 100, 100);
        
        rect(randX, randY, 40, 40);
        
        // Calculating the euclidean distance and drawing a line
        //strokeWeight(5);
        //stroke(0);
        //line(randX + possum.width/2, randY + possum.height/2, guessX, guessY);
        //text(nf(countdown/1000, 0, 0), w/2, 50);
        
        float dist = sqrt(abs(sq((randX + possum.width/2) - guessX))+abs(sq((randY +  + possum.height/2) - guessY)));

        stroke(0);
        strokeWeight(0);
        fill(255, 200);
        rect(w/2 - 50, h/2 - 40, 130, 60, 9);
        
        textSize(30);
        fill(0);
        text(int(dist), w/2, h/2);
      }
      else {
        drawTarget();
      }
      
      if (countdown < 0 && guessed) {
        gameState = -1; // Go back to wait phase
        startTime = millis(); // Have to reset the time so that the countdown starts again
        guessed = false; // Reset that the player has guessed
        randX = random(50, w - 50); // Resetting the  location of the next possum 
        randY = random(50, h - 50);
      }
      
    }
    

    /* WAIT PHASE */
    else if (gameState == 1) {
      image(background, 0, 0, w, h); // Only draws background when the game has started  
      float countdown = 3000 - (millis() - startTime);

      //PImage cursorZoom;
      //cursorZoom = background.get(mouseX, mouseY, 300, 300);
      //cursorZoom.resize(300, 300);
      //image(cursorZoom, mouseX - 150, mouseY - 150);
      

      drawTarget();

      if (countdown > 0) {
        textSize(60);
        text(nf(int(countdown/1000)+1, 0, 0), w/2, h/2);
      }
      
      

      /* WATCH PHASE */
      else if (countdown < visableTime) { // Making the visable time any less than 50 milliseconds means that it won't reach the time
        println("Actual time visable vs desired time visable: " + countdown + ":" + visableTime);      
        //text(nf(countdown, 0, 0), w/2, h/2);
        image(possum, randX, randY); // If not enought time passes then they will be shown the pest for minimum time possible for the system to run a loop
        gameState = 2;
      }
      else {
        image(possum, randX, randY);
      }
      
    }

    /* GUESS PHASE */
    else if (gameState == 2) {
      image(background, 0, 0, w, h); 
                  
      float countdown = 3000 - (millis() - startTime); // Start counting down again so can start next round (3 seconds)

      /* SCORE & RESET PHASE */
      if (guessed && countdown > 0) {
        noFill();
        strokeWeight(3);
        stroke(200, 50, 0);
        ellipse(guessX, guessY, 100, 100);
        
        image(possum, randX, randY);
        
        // Calculating the euclidean distance and drawing a line
        //strokeWeight(5);
        //stroke(0);
        //line(randX + possum.width/2, randY + possum.height/2, guessX, guessY);
        //text(nf(countdown/1000, 0, 0), w/2, 50);
        
        float dist = sqrt(abs(sq((randX + possum.width/2) - guessX))+abs(sq((randY +  + possum.height/2) - guessY)));

        stroke(0);
        strokeWeight(0);
        fill(255, 200);
        rect(w/2 - 50, h/2 - 40, 130, 60, 9);
        
        textSize(30);
        fill(0);
        text(int(dist), w/2, h/2);
      }
      else {
        drawTarget();
      }
      
      if (countdown < 0 && guessed) {
        gameState = 1; // Go back to wait phase
        startTime = millis(); // Have to reset the time so that the countdown starts again
        guessed = false; // Reset that the player has guessed
        randX = random(50, w - 50); // Resetting the  location of the next possum 
        randY = random(50, h - 50);
      }
      
    }
    
  }
  
  public void drawTarget() {
    fill(255, 100);
    strokeWeight(1);
    ellipse(mouseX, mouseY, 100, 100);
    fill(0);
    line(mouseX, mouseY + 50, mouseX, mouseY - 50);
    line(mouseX + 50, mouseY, mouseX - 50, mouseY);
  }
  
  class scoreboard {
    FloatList scores;
    public scoreboard() {
      scores = new FloatList(); 
      scores.append(0);
    }
    
    public FloatList getScores() {
      return scores; 
    }
    
    public void addScore(float newScore) {
      scores.append(newScore); 
    }
    
    public void saveScores() {
       PrintWriter output;
       output = createWriter("scores.txt");
       if (scores.size() != 1) {
        for(int i = 0; i < scores.size(); i++){
          if (i != 0){
            output.println(i + ") " + scores.get(i));
          }
        }
      }
      output.flush();
      output.close();
    }
    
    public void displayScore() {
      fill(200);
      stroke(0);
      strokeWeight(5);
      rect(10, 10, 300, h-20);
      fill(0);
      textSize(30);
      text("High Scores", 70, 50);
      if (scores.size() != 1) {
        for(int i = 0; i < scores.size(); i++){
          if (i != 0){
            textSize(20);
            text(i + ") " + scores.get(i), 70, 50 + (i * 50));
          }
        }
      }
      else {
        textSize(20);
        text("no scores to show yet", 70, 100);
      }
    }
  }
  
