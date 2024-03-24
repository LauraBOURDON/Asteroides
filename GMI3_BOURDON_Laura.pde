

/////////////////////////////////////////////////////
//
// Asteroids
// DM2 "UED 131 - Programmation impérative" 2021-2022
// NOM         : BOURDON
// Prénom      : Laura
// N° étudiant : 20212795
//
// Collaboration avec :
//
/////////////////////////////////////////////////////

//===================================================
// les variables globales
//===================================================

//////////////////////
// Pour le vaisseau //
//////////////////////
float shipX; // abscisse vaisseau
float shipY; // ordonnée vaisseau
float shipAngle; // angle vaisseau
float shipSize = 10; // taille du vaisseau
float speedShipX; // vitesse abscisse vaisseau
float speedShipY; // vitesse ordonnée vaisseau
float fastSpeedShipX; // accélération vaisseau (abscisse)
float fastSpeedShipY; // accélération vaisseau (ordonnée)
boolean motor = false; // moteur allumé ou non?

//////////////////////
// Pour le missile  //
//////////////////////
float shootX = -100; // abscisse missile
float shootY = -100; // ordonnée missile
// déplacement missile
float speedShootX = 0;
float speedShootY = 0;

//////////////////////
// Pour l'astéroïde //
//////////////////////
float asteroidX; // abscisse astéroïde
float asteroidY; // ordonnée asteroïde
float asteroidSize; // taille astéroïde
// déplacement astéroïde
float speedAsteroidX;
float speedAsteroidY;

////////////////////////////
// Pour la gestion du jeu //
////////////////////////////
boolean gameOver = false; // perdu ou non ?
// nombres d'astéroides
int nb0Asteroids;
int nbAsteroids;
int nbMaxAsteroids;
// nombre de tirs
int nbShoot;
int nbMaxShoot;
// temps de jeu
//int s = second();
//int m = minute();
//int h =  hour();

////////////////////////////////////
// Pour la gestion de l'affichage //
////////////////////////////////////
int total = 0; // score du joueur
boolean init = true; // écran d'accueil pour lancement du jeu

//===================================================
// l'initialisation
//===================================================

// ajout de tous les bruitages au programme
import processing.sound.*;
SoundFile explosionShip;
SoundFile bulletShip;
SoundFile explosionAsteroids;
SoundFile flameShip;

void setup() {
  size(800, 800);
  background(0); // noir
  nb0Asteroids = 5; // nombre initial d'asteroides
  nbMaxAsteroids = 100; // nombre maximum d'asteroides
  nbShoot = 0;
  nbMaxShoot = 100; //nombre maximum de tirs
  // if(s < 59){
  //  s++;
  //  } else if (m < 59){
  //  m++;
  // } else if ( h<59){
  //   h ++;
  // }
  initGame(); // initialisation du jeu
  explosionShip = new SoundFile(this, "bangLarge.mp3"); // vaisseau touché
  bulletShip = new SoundFile(this, "fire.mp3"); // tirs
  explosionAsteroids = new SoundFile(this, "bangSmall.mp3"); // astéroides touchés
  flameShip = new SoundFile(this, "thrust.mp3"); // moteur du vaisseau
}

// -------------------- //
// Initialise le jeu    //
// -------------------- //
void initGame() {
  initShip(); // vaisseau
  initAsteroids(); // asteroides
}

//===================================================
// la boucle de rendu
//===================================================
void draw() {

  if (gameOver == false) { // si le joueur n'a pas encore perdu
    background(0); // noir
    displayShip(); // affiche le vaisseau
    moveAsteroids(); // déplace l'astéroïde
    displayAsteroids(); // affiche l'asteroïde
    moveBullets(); // déplace le missile
    displayBullets(); // affiche les tirs
    displayScore();
    //displayChrono();
    moveShip(); // déplace le vaisseau
    if (collision(asteroidX, asteroidY, asteroidSize, shipX, shipY, shipSize)) { // collision asteroide-vaisseau
      gameOver = true; // le joueur perd
      explosionShip.play(); // musique du vaisseau qui explose
      if (gameOver == true) {
        displayGameOverScreen(); // affiche Game Over : le joueur a perdu, le jeu s'arrête
      }
    }

    // tests collision
    if (collision(shootX, shootY, 0, asteroidX, asteroidY, asteroidSize)) { // collision asteroide-missile
      explosionAsteroids.play(); // musique explosion de l'astéroide touché
      initAsteroids(); // nouvel asteroide créé
      // on efface le missile
      shootX = -100;
      shootY = -100;
      total ++; // le score augmente d'un point
      nbMaxAsteroids -- ;
      nbAsteroids = 100 - nbMaxAsteroids; // permet de calculer le nombre d'astéoides restants
    }
  }

  if (init == true) {
    displayInitScreen(); // affiche l'écran d'accueil
  }
  if (motor == true) { // teste si le moteur est allumé
    flameShip.play(); // musique du moteur du vaisseau
    // accélération du vaisseau
    fastSpeedShipX = 0.25 * cos(shipAngle);
    fastSpeedShipY = 0.25 * sin(shipAngle);
    // permet au vaisseau de ne pas accélérer en continue
  } else if (motor == false) {
    fastSpeedShipX = 0;
    fastSpeedShipY = 0;
  }
}

// ------------------------ //
//  Initialise le vaisseau  //
// ------------------------ //
void initShip() {
  // position du vaisseau au milieu de la fenêtre
  shipX = width/2;
  shipY = height/2;
  shipAngle = 3*PI/2; // orienté vers le haut
}

// --------------------- //
//  Deplace le vaisseau  //
// --------------------- //
void moveShip() {
  // vitesse du vaisseau
  speedShipX = speedShipX + fastSpeedShipX  ;
  speedShipY = speedShipY + fastSpeedShipY ;
  // faire avancer le vaisseau
  shipX = shipX + speedShipX;
  shipY = shipY + speedShipY;

  // effet wraparound vaisseau
  if ((shipX >= width) || (shipY >= height)) { // teste si le vaisseau sort de la fenêtre : valeurs supérieures
    // le vaisseau apparait de l'autre côté de là où il a disparu
    shipX = shipX % width;
    shipY = shipY % height;
  } else if ((shipX <= 0) || (shipY <= 0)) { // teste si le vaisseau sort de la fenêtre : valeurs inférieures
    // le vaisseau apparait de l'autre côté de là où il a disparu
    shipX = shipX + width;
    shipY = shipY + height;
  }
}

// -------------------------- //
//  Crée un nouvel asteroïde  //
// -------------------------- //
//float[][] lotOfAsteroids = new float [10][10];
void initAsteroids() {
  //for (int i = 0; i < lotOfAsteroids.length; i++) {
  // for (int j = 0; j < lotOfAsteroids[0].length; j++) {
  // lotOfAsteroids [i][0] += speedAsteroidX;
  // lotOfAsteroids [0][j] += speedAsteroidY;

  asteroidX = random(800, 0); // abscisse aléatoire de l'astéroïde
  asteroidY = random(800, 0); // ordonnée aléatoire de l'astéroïde
  asteroidSize = 60; // initialise la taille de l'asteroïde à 60
  // déplacement de l'asteroïde
  speedAsteroidX = 3 * cos(random(360));
  speedAsteroidY = 3 * sin(random(360));
  // }
  //}
}

// ------------------------------ //
//  Crée la forme de l'asteroïde  //
// ------------------------------ //
// i : l'indice de l'asteroïde dans le tableau
//
void createAsteroid(int i) {
}

// --------------------- //
//  Deplace l'asteroïde  //
// --------------------- //
void moveAsteroids() {
  // faire avancer l'astéroïde
  asteroidX = asteroidX + speedAsteroidX;
  asteroidY = asteroidY + speedAsteroidY;
  // effet wraparound
  if ((asteroidX >= width) || (asteroidY >= height)) { // teste si l'asteroide sort de la fenêtre (position supérieure)
    // l'astéroide apparait de l'autre côté de là où il a disparu
    asteroidX = asteroidX % width;
    asteroidY = asteroidY % height;
  } else if ((asteroidX <= 0) || (asteroidY <= 0)) { // teste si l'asteroide sort de la fenêtre (position inférieure)
    // l'astéroide apparait de l'autre côté de là où il a disparu
    asteroidX = asteroidX + width;
    asteroidY = asteroidY + height;
  }
}

// ------------------------ //
//  Détecte les collisions  //
// ------------------------ //
// o1X, o1Y : les coordonnées (x,y) de l'objet1
// o1D      : le diamètre de l'objet1
// o2X, o2Y : les coordonnées (x,y) de l'objet2
// o2D      : le diamètre de l'objet2
//
boolean collision(float o1X, float o1Y, float o1D, float o2X, float o2Y, float o2D) {

  if (dist(o1X, o1Y, o2X, o2Y) <= (o1D + o2D)/2) { // teste si la distance entre les rayons des deux objets est inférieure à leur diamètre
    return true; // les deux objets sont en contact = collision
  } else {
    return false; // les deux objets ne sont pas en contact :il n'y a pas collision
  }
}



// ----------------- //
//  Tire un missile  //
// ----------------- //
void shoot() {
  bulletShip.play();
  // position missile = position vaisseau
  shootX = shipX;
  shootY = shipY;
  // initialisation de la vitesse du missile
  speedShootX = 5 * cos(shipAngle);
  speedShootY = 5 * sin(shipAngle);
}

// ------------------------------------------- //
//  Calcule la trajectoire du ou des missiles  //
// ------------------------------------------- //
void moveBullets() {
  // déplacement du missile
  shootX = shootX + speedShootX;
  shootY = shootY + speedShootY;
}

// --------------------- //
//  Supprime un missile  //
// --------------------- //
// idx : l'indice du missile à supprimer
//
void deleteBullet(int idx) {
}

// --------------------- //
//  touche un astéroïde  //
// --------------------- //
// idx    : l'indice de l'atéroïde touché
// vx, vy : le vecteur vitesse du missile
//
void shootAsteroid(int idx, float vx, float vy) {
}

// ----------------------- //
//  supprime un astéroïde  //
// ----------------------- //
// idx    : l'indice de l'atéroïde touché
//
void deleteAsteroid(int idx) {
}

//===================================================
// Gère les affichages
//===================================================

// ------------------- //
// Ecran d'accueil     //
// ------------------- //
void displayInitScreen() {
  // affiche le nom du jeu
  PFont z;
  z = createFont("textFont(z)", 100);
  fill(255); // blanc
  textAlign(CENTER);
  textFont(z);
  text("ASTEROIDS", width/2, height/2);
  PFont r;
  // indique au joueur comment lancer la partie
  r = createFont("textFont(r)", 30);
  fill(255); // blanc
  textAlign(CENTER);
  textFont(r);
  text("Press ENTER to start :)", width/2, height/1.8);
  // indique au joueur les consignes
  PFont u;
  u = createFont("textFont(u)", 12);
  fill(255); // blanc
  textAlign(CENTER);
  textFont(u);
  text("Press BACKSPACE to shoot \n Press RIGHT or LEFT to turn right or left \n Press UP to moove \n press ENTER in game to teleport your ship ", width/2, height/1.7);
}

// -------------- //
//  Ecran de fin  //
// -------------- //
void displayGameOverScreen() {
  // le joueur a perdu = son vaisseau est entré en collision avec un asteroide
  PFont y;
  y = createFont("textFont(y)", 100);
  fill(255); // blanc
  textAlign(CENTER);
  textFont(y);
  text("GAME OVER", width/2, height/2);
  // indique au joueur comment relancer une partie
  PFont o;
  o = createFont("textFont(o)", 30);
  fill(255); // blanc
  textAlign(CENTER);
  textFont(o);
  text("YOU LOSE :'( \n Press ENTER to Restart ", width/2, height/1.8);
}


// --------------------- //
//  Affiche le vaisseau  //
// --------------------- //
void displayShip() {
  translate(shipX, shipY); // positionne le vaisseau au milieu de la fenetre
  rotate(shipAngle); // vers le haut

  fill(0); // fond du vaisseau noir

  if (motor == true) {
    // création flammes vaisseau
    stroke(255, 0, 0); // traits rouges
    beginShape();
    vertex(-5, 5); // sommet en haut à droite
    vertex(-5, 0); // sommet milieu à droite
    vertex(-5, -5); // sommet bas à droite
    vertex(-15, 0); // sommet de gauche
    endShape(CLOSE);
  }

  //  création du vaisseau  : forme + couleurs
  stroke(255); // traits blancs
  beginShape();
  vertex(-7, 7); // sommet en haut à gauche
  vertex(-5, 0); // sommet milieu à gauche
  vertex(-7, -7); // sommet bas à gauche
  vertex(10, 0); // sommet de droite
  endShape(CLOSE);

  resetMatrix();
}

// ------------------------ //
//  Affiche les asteroïdes  //
// ------------------------ //
void displayAsteroids() {
  circle(asteroidX, asteroidY, asteroidSize); // forme astéroïde
  // indique au joueur combien il reste d'asteroides à venir
  PFont w;
  w = createFont("textFont(w)", 15);
  fill(255); //
  textAlign(CENTER);
  textFont(w);
  text("Astéroides restants : "+ nbMaxAsteroids, 700, 65);
}

// ---------------------- //
//  Affiche les missiles  //
// ---------------------- //
void displayBullets() {
  line(shootX, shootY, shootX + speedShootX, shootY + speedShootY); // trait missile
}

// ------------------- //
//  Affiche le chrono  //
// ------------------- //
void displayChrono() {
  //s =0;
  //m = 0 ;
  // h=0;
  //PFont p;
  //p = createFont("textFont(p)", 15);
  //fill(255); //
  //textAlign(CENTER);
  //textFont(p);
  //text("Temps écoulé :" + s + " s  " + m + " min ", 700, 90);
}

// ------------------- //
//  Affiche le score   //
// ------------------- //
void displayScore() {
  // afficher le score en haut à droite de la fenêtre, taille 20
  PFont x;
  x = createFont("textFont(x)", 20);
  fill(255); //
  textAlign(CENTER);
  textFont(x);
  text("Score : "+ total, 720, 40);
}

//===================================================
// Gère l'interaction clavier
//===================================================

// ------------------------------- //
//  Quand une touche est enfoncée  //
// ------------------------------- //
// flèche droite  = tourne sur droite
// flèche gauche  = tourne sur la gauche
// flèche haut    = accélère
// barre d'espace = tire
// entrée         = téléportation aléatoire
//
void keyPressed() {
  if (key == CODED) {
    if ( keyCode == RIGHT) { // le vaisseau s'oriente vers la droite
      if (gameOver == false) {
        shipAngle = shipAngle + radians(5);
      } else {
        shipAngle = 0;
      }
    }
    if (keyCode == LEFT) { // le vaisseau s'oriente vers la gauche
      if (gameOver == false) {
        shipAngle = shipAngle - radians(5);
      } else {
        shipAngle = 0;
      }
    }
    if (keyCode == UP) { // le vaisseau accélère
      motor = true;
    }
  }
  if (key == ' ') { // le vaisseau tire un missile
    if (gameOver == false) {
      shoot();
    }
  }
  if ((key == ENTER)||(key == RETURN)) {
    if (gameOver == true) { // le joueur a perdu ?
      asteroidX = random (800, 0); // abscisse aléatoire de l'astéroïde
      asteroidY = random(800, 0); // ordonnée aléatoire de l'astéroïde
      total = 0; // le score est réinitialisé
      gameOver = false; // permet de relancer une partie
    }

    if ((gameOver == false) && (init == false)) { // permet au vaisseau de se téléporter au cours d'une partie
      // coordonnées aléatoires
      shipX = random(width);
      shipY = random(height);
    }
    init = false; // l'écran d'accueil disparait
    motor = false; // le moteur est éteint
  }
}

// ------------------------------- //
//  Quand une touche est relâchée  //
// ------------------------------- //
void keyReleased() {
  if (key == CODED) { // quand on relanche la flèche du haut le vaisseau cesse d'accélérer
    if (keyCode == UP) {
      motor = false;
    }
  }
}
