// C++ assignment 3: game of life. April 2017.
// Bram Otten, bram.otten@student.uva.nl, student ID 10992456.
// Tested with g++ 5.4+ (as c++98) on a few x64 Linux distributions.

#include <ctime>
#include <iostream>
#include <fstream>
#include <cstdlib>
#include <unistd.h>

using namespace std;

// Constants.
const int VIEW_HORI = 80;
const int VIEW_VERT = 40;
const int HORI_STEP = 20;
const int VERT_STEP = 10;
const int N_DEF_STEPS = 100;
const int DEF_DELAY = 90000;
const int LOW = 2;
const int HIGH = 3;
const int RANDOM_ACCURACY = 1000;
const int GRID_SIZE = 200;
const double PROB_OF_LIFE = 0.1;
const char LIFE = '*';
const char DEATH = '.';

// Uses the minimal standard generator by Park and Miller.
class RandomBoolean {
public:
    RandomBoolean(double pOfLife = PROB_OF_LIFE) {
        seed = (int) time(NULL);
        M = 2147483647;
        A = 16807;
        Q = (M / A);
        R = (M % A);
        minimumTrues = (1 - pOfLife) * RANDOM_ACCURACY;
    }

    // Makes result into a random int between 0 and RANDOM_ACCURACY.
    void makeRandomInt() {
        seed = A * (seed % Q) - R * (seed / Q);
        if (seed <= 0)
            seed += M;

        result = seed % RANDOM_ACCURACY;
    }

    bool getResult() {
        makeRandomInt();
        return result > minimumTrues;
    }

private:
    int seed, M, A, Q, R, result;
    double minimumTrues;
};

// The world is a square of chars representing life and death.
// Each time step makes a bunch of things happen.
class World {
public:
    World() {
        life = LIFE, death = DEATH;
        clean(); // optional, lets cells start out dead.
    }

    void setLife(char toBeLife) { life = toBeLife; }

    void setDeath(char toBeDeath) { death = toBeDeath; }

    // Clear entire world.
    void clean() {
        for (int i = 0; i < GRID_SIZE; i++) {
            for (int j = 0; j < GRID_SIZE; j++) {
                world[i][j] = futureWorld[i][j] = death;
            }
        }
    }

    // Populate randomly.
    void populate(double prob) {
        RandomBoolean fate(prob);
        for (int i = 0; i < GRID_SIZE; i++) {
            for (int j = 0; j < GRID_SIZE; j++) {
                world[i][j] = fate.getResult() ? life : death;
                futureWorld[i][j] = death;
            }
        }
    }

    // Or with a file.
    void populate(string patternFile) {
        ifstream inStream;
        inStream.open(patternFile.c_str());
        if (inStream.fail()) {
            cout << "Error reading file." << endl;
            exit(1);
        }

        // Everything not covered by the file is dead.
        clean();

        string next;
        int y = 0;

        while (getline(inStream, next)) {

            // Check if remaining within bounds.
            if (y >= GRID_SIZE || next.length() >= GRID_SIZE) {
                cout << "Grid size > " << GRID_SIZE << "?\n";
                exit(1);
            }

            // This unsigned int comparison here is a little
            // inconsistent, but it shuts g++ up.
            for (unsigned int x = 0; x < next.length(); x++) {

                // A little bit of a waste to do every time.
                if (next[x] != '.' || next[x] == ' ')
                    life = next[x];

                world[y][x] = next[x];
            }

            y++;
        }
    }

    // The interesting simulation bit, finally.
    void simulateWhole(int timeSteps = 1) {

        // Go through the columns per row per step.
        for (int step = 0; step < timeSteps; step++) {
            simulateStep();
        }
    }

    void simulateStep() {
        for (int y = 0; y < GRID_SIZE; y++) {
            for (int x = 0; x < GRID_SIZE; x++) {
                simulateCell(y, x);
            }
        }

        // Very pretty array replacement. (futureWorld is the new one.)
        for (int y = 0; y < GRID_SIZE; y++) {
            for (int x = 0; x < GRID_SIZE; x++) {
                world[y][x] = futureWorld[y][x];
            }
        }
    }

    // Basically just count up how many cells around this one are alive.
    // Depending on that number, make it something in the future world.
    void simulateCell(int y, int x) {
        int count = 0;
        for (int i = -1; i <= 1; i++) {
            for (int j = -1; j <= 1; j++) {

                // Skip the cell itself.
                if (i == 0 && j == 0)
                    continue;

                int yCheck = y - i;
                int xCheck = x - j;

                // Skip out of bounds.
                if (yCheck < 0 || yCheck >= GRID_SIZE ||
                    xCheck < 0 || xCheck >= GRID_SIZE)
                    continue;

                if (world[yCheck][xCheck] == life)
                    count++;

            }
        }

        // If alive, only 2 (LOW) or 3 (HIGH) neighbours keep the cell alive.
        if (world[y][x] == life)
            futureWorld[y][x] = count < LOW || count > HIGH ? death : life;

            // If dead, HIGH neighbours make alive.
        else
            futureWorld[y][x] = count == HIGH ? life : death;
    }

    // Returns state of the one character at those coordinates.
    char getFromWorld(int y, int x) {
        return world[y][x];
    }

private:
    char life, death;
    char world[GRID_SIZE][GRID_SIZE], futureWorld[GRID_SIZE][GRID_SIZE];
};

// Visualize the world in 80x40 chars.
// And a user input menu around that.
class UserInterface {
public:
    UserInterface() {
        prob = PROB_OF_LIFE;
        horiStep = HORI_STEP;
        vertStep = VERT_STEP;
        nSteps = N_DEF_STEPS;
        delay = DEF_DELAY;
        lowX = 0;
        lowY = 0;
        // mars.populate(prob); // uncomment to start with populated world
        done = false;
    }

    void view() {
        int maxX = lowX + VIEW_HORI, maxY = lowY + VIEW_VERT;

        // show coordinates on top
        cout << "(" << lowX << ", " << lowY << ") -> "
             << "(" << maxX << ", " << maxY << ")\n";

        // then VIEW_HORIxVIEW_VERT chars
        for (int y = lowY; y < maxY; y++) {
            for (int x = lowX; x < maxX; x++) {
                cout << mars.getFromWorld(y, x);
            }
            cout << endl;
        }

        // The menu is one line below that.
        cout << "Stop(1) "
             << "Clean(2) "
             << "Random(3) "
             << "Step(4) "
             << nSteps << " steps(5) "
             << "Move view(6) "
             << "Parameters(7) "
             << "\n\n";
    }

    void listen() {
        cout << "Next action: ";
        int key;
        cin >> key;
        cin.clear();
        cin.ignore();

        // And do what the menu says should be done.
        // An enum could be nice.
        switch (key) {
            case 1 :
                stop();
                break;
            case 2 :
                mars.clean();
                break;
            case 3 :
                mars.populate(prob);
                break;
            case 4 :
                mars.simulateWhole();
                break;
            case 5 :
                for (int i = 0; i < nSteps; i++) {
                    mars.simulateWhole();
                    view();
                    usleep(delay);
                }
                break;
            case 6 :
                moveView();
                break;
            case 7 :
                parameters();
                break;
            default:
                cout << "Please try again\n";
                listen();
                break;
        }
    }

    void moveView() {
        cout << "Step sizes are HxV = " << horiStep
             << "x" << vertStep << ", can be changed in parameter menu.\n"
             << "Direction? (r(ight), d(own), l(eft), u(p)\n"
             << "------------------------------------------\n";
        char key;
        cin >> key;
        cin.clear();
        cin.ignore();
        switch (key) {
            case 'r':
                lowX += horiStep;

                // And a sort of check. If near a border, just go to that border.
                if (lowX + VIEW_HORI >= GRID_SIZE)
                    lowX = GRID_SIZE - VIEW_HORI;

                break;

            case 'd' :
                lowY += vertStep;

                if (lowY + VIEW_VERT >= GRID_SIZE)
                    lowY = GRID_SIZE - VIEW_VERT;

                break;

            case 'l' :
                lowX -= horiStep;

                if (lowX <= 0)
                    lowX = 0;

                break;

            case 'u' :
                lowY -= vertStep;

                if (lowY <= 0)
                    lowY = 0;

                break;
            default :
                cout << "Try that again: ";
                moveView();
                break;
        }
    }

    void parameters() {
        cout << "\n\n\n\n"
             << "Parameter settings\n"
             << "------------------\n\n"
             << "Horizontal step size of view (1)\n"
             << "Vertical step size of view (2)\n"
             << "Probability of cell being alive (3)\n"
             << "Representation of live cell (4)\n"
             << "Representation of dead cell (5)\n"
             << "Load a pattern file (6)\n"
             << "Change number of steps to simulate (7)\n"
             << "Set delay between multiple steps (8)\n"
             << "Return to game (0)\n\n"
             << "Action: ";
        int key;
        cin >> key;
        cin.clear();
        cin.ignore();

        switch (key) {
            case 0 :
                break;
            case 1 :
                cout << "Enter new horizontal step size: ";
                unsigned int toBeHori;
                cin >> toBeHori;
                if (!cin.fail())
                    horiStep = toBeHori;
                break;
            case 2 :
                cout << "Enter new vertical step size: ";
                unsigned int toBeVert;
                cin >> toBeVert;
                if (!cin.fail())
                    vertStep = toBeVert;
                break;
            case 3 :
                cout << "Enter new probability: ";
                double toBeProb;
                cin >> toBeProb;
                if (!cin.fail()) {
                    if (toBeProb >= 0 && toBeProb <= 1)
                        prob = toBeProb;
                }
                break;
            case 4 :
                cout << "Enter new 'live' representation: ";
                char toBeLife;
                cin >> toBeLife;
                if (!cin.fail())
                    mars.setLife(toBeLife);
                break;
            case 5 :
                cout << "Enter new 'death' representation: ";
                char toBeDeath;
                cin >> toBeDeath;
                if (!cin.fail())

                    // Optionally, allow only ' ' and '.'

                    mars.setDeath(toBeDeath);
                break;
            case 6 : {
                cout << "Enter filename, then return: ";
                string fileName;
                cin >> fileName;
                if (!cin.fail()) {
                    mars.clean();
                    mars.populate(fileName);
                }
                break;
            }
            case 7 :
                cout << "Enter new number of steps to simulate: ";
                unsigned int toBeSteps;
                cin >> toBeSteps;
                if (!cin.fail())
                    nSteps = toBeSteps;
                break;
            case 8 :
                cout << "Enter new delay between simulate moves, in us: ("
                     << DEF_DELAY << " was the default) ";
                unsigned int toBeDelay;
                cin >> toBeDelay;
                if (!cin.fail())
                    delay = toBeDelay;
                break;
            default:
                cout << "Please try that again: ";
                parameters();
                break;
        }
    }

    void stop() {
        mars.clean();
        cout << endl;
        done = true;
    }

    bool finished() {
        return done;
    }

private:
    World mars;
    int horiStep, vertStep;
    int lowX, lowY;
    int nSteps, delay;
    double prob;
    bool done;
};

int main() {

    UserInterface game;

    while (!game.finished()) {
        game.view();
        game.listen();
    }

    return 0;
}
