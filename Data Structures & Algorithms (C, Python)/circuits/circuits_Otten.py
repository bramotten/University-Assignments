# Circuits assignment for datastructures and algorithms,
# by Bram Otten, UvA ID 10992456, 24-04-2018.
# Important stuff that's changed since 30-03-2018 is labelled with MOD: ...

from copy import deepcopy
from collections import defaultdict
import random
import sys

import numpy as np


def read_board_csv(filename, delim=';'):
    """
    Input: filename is a csv file (exported by Excel) with netlists.
    Returns: list with connections in netlists like ((x1, y1, z1), (x2, y2, z2))
    """
    gates = []
    netlists = ([], [], [])
    part = -1
    for row in open(filename, 'r'):
        row = row.split(delim)
        if "Netlist" in row[0]:
            part += 1
        elif row[0].isdigit():
            if part == -1:
                gates.append((int(row[1]), int(row[2])))
            else:
                netlists[part].append((gates[int(row[0]) - 1],
                                       gates[int(row[1]) - 1]))
    return netlists, gates  # MOD: nu ook gates returnen


def man_dist(a, b):
    """
    Input: a and b are tuples of coordinates of size 3.
    Returns: distance along straight lines and corners.
    """
    return abs(a[0] - b[0]) + abs(a[1] - b[1]) + abs(a[2] - b[2])


def order(nl):
    """
    Input: nl is a netlist.
    Returns: list with same elements, sorted by Manhattan distance.
    """
    dict_nl = {(a, b): man_dist(a, b) for (a, b) in nl}
    return sorted(dict_nl, key=dict_nl.get)


class Graph:
    def __init__(self):
        self.nodes = set()
        self.edges = defaultdict(list)

    def add_node(self, value):
        self.nodes.add(value)

    def add_edge(self, from_node, to_node):
        self.edges[from_node].append(to_node)
        self.edges[to_node].append(from_node)


class netlist_solver:
    def __init__(self, nl, gates, y_size, weights, mults, debug,
                 initial_order=order, dist=man_dist, graph=Graph):
        """ My main reason for using classes is the possibility
            to share variables among the functions. """
        self.x_size = 18
        self.z_size = 7
        self.y_size = y_size
        self.weights = weights
        self.nl = nl
        self.len = len(self.nl)
        self.ordered_nl = order(self.nl)
        self.mults = mults
        self.mult = self.mults["Init"]
        self.dist = dist
        self.graph = graph
        self.debug = debug
        self.taken_set = set()
        self.path_dict = defaultdict(list)
        self.nodes, self.edges = self.init_grid()
        self.gate_popularity = defaultdict(int)
        for combo in self.nl:
            for gate in combo:
                self.gate_popularity[gate] += 1
        # MOD: gates argument gebruiken ipv inferren uit netlist.
        #      Die heeft namelijk niet altijd alle gates in zich.
        self.gates = set()
        for gate in gates:
            self.gates.add((gate[0], gate[1], 0))

    def init_grid(self):
        """
        Given board sizes, returns every possible node and all the edges
        that go east, north or up. Graph's append adds opposite directions.
        """
        nodes = [(i, j, k) for i in range(self.x_size)
                 for j in range(self.y_size) for k in range(self.z_size)]
        half_of_edges = []

        for i in range(self.x_size):
            for j in range(1, self.y_size):
                for k in range(self.z_size):
                    half_of_edges.append([(i, j-1, k), (i, j, k)])
        for i in range(self.x_size):
            for j in range(self.y_size):
                for k in range(1, self.z_size):
                    half_of_edges.append([(i, j, k-1), (i, j, k)])
        for i in range(1, self.x_size):
            for j in range(self.y_size):
                for k in range(self.z_size):
                    half_of_edges.append([(i-1, j, k), (i, j, k)])
        return nodes, half_of_edges

    def solve(self):
        """
        Tries to find a configuration making all connections.
        Continues until done, retries are with different order and weights.
        Updates self.path_dict and other class variables instead of returning.
        """
        done = self.search()
        i = 0
        while done != True:
            if self.debug:
                pass
                # print("Badness was:", self.badness(),
                #       ". Trying again, that connection first.")
            i = self.resetter(i, done)
            done = self.search()

    def resetter(self, i, done):
        _, nl_fail_i, ordered_fail_i = done
        i += 1
        if i > self.weights["MaxBoosts"]:
            i = 0
            self.weights["Ref"] /= self.weights["Init"]
            if self.debug:
                print("New weights:", self.weights)
        if i % self.weights["Interval"] == 0:
            self.weights["Ref"] *= self.weights["Boost"]
            if self.debug:
                print("New weights:", self.weights)
        if self.mult > self.mults["Max"]:
            self.mult = self.mults["Init"]
        else:
            self.mult += self.mults["Step"]

        del self.ordered_nl[ordered_fail_i]
        new_index = min(0, ordered_fail_i - self.weights["iBumper"])
        self.ordered_nl = self.ordered_nl[:new_index] + \
            [nl[nl_fail_i]] + self.ordered_nl[new_index:]
        self.taken_set.clear()
        self.path_dict.clear()
        return i

    def search(self):
        """ Creates a new graph with remaining possible nodes/edges,
            feeds it to the actual algorithm connection by connection. """
        for our_i, (a, b) in enumerate(self.ordered_nl):
            g = self.graph()
            for node in self.nodes:
                if node == a or node == b or node not in self.gates:
                    if node not in self.taken_set:
                        g.add_node(node)
            for edge in self.edges:
                if (edge[0] == a or edge[0] == b or
                        edge[0] not in self.gates) and \
                        (edge[1] == a or edge[1] == b or
                            edge[1] not in self.gates):
                    if edge[0] not in self.taken_set and \
                            edge[1] not in self.taken_set:
                        g.add_edge(edge[0], edge[1])
            nl_i = nl.index((a, b))
            path = self.probably_best_path(g, a, b, nl_i, our_i)
            if path == False:
                return False, nl_i, our_i
            else:
                # print(self.path_dict)
                self.path_dict[nl_i] = path
                for node in path:
                    self.taken_set.add(node)
        if self.debug:
            print("\nSolved! Final grid:")
        return True

    def probably_best_path(self, g, a, b, nl_i, our_i):
        """
        Returns best path from a to b, where best is defined by
        some heuristics. I didn't go for simulated annealing, but I came up
        with something that's pretty similar.

        Progress means there's less heuristic penalty (through 'mult'),
        travelling from busy nodes is more expensive, and blocking nodes is
        penalized (in a special function). All of this is to make sure paths
        laid early on don't end up blocking the last paths.
        """
        visited = {a: 0}
        path = defaultdict(list)
        gates = list(self.gates)
        nodes = set(g.nodes)

        while nodes:
            min_node = None
            for node in nodes:
                if node in visited:
                    if min_node is None:
                        min_node = node
                    elif visited[node] < visited[min_node]:
                        min_node = node
            if min_node is None:
                break
            nodes.remove(min_node)
            current_weight = visited[min_node]

            mult = self.mult + \
                self.weights["Ref"] / 4 * self.len / (our_i + 1)

            for edge in g.edges[min_node]:
                weight = current_weight + \
                    self.blocking_penalizer(edge, mult, len(g.edges[edge]),
                                            min_node)

                if edge not in visited or weight < visited[edge]:
                    visited[edge] = weight
                    path[edge].append(min_node)

        return self.return_path(path, a, b, nl_i, our_i)

    def return_path(self, path, a, b, nl_i, our_i):
        actual_path = []  # no b because we only have to get close enough
        if len(path[b]) > 0:
            x = path[b][0]
            while x != a:
                actual_path.insert(0, x)
                x = path[x][0]

        if len(actual_path) == 0 and self.dist(a, b) > 1:
            # if self.debug:#
            print("Can't solve connection {}: {} -> {}, {}".format(
                nl_i + 1, a, b, our_i), "of", self.len)
            if our_i >= 61:  # for board 2 netlist 3.
                print("Not a correct solution, still printing!!!")
                self.printer()
                print("Not a correct solution, still printing!!!")
            return False

        return actual_path

    def blocking_penalizer(self, edge, mult, n_edges, min_node):
        """ Returns a weight, taking into account that other nodes should
            be kept free. """
        weight = self.weights["Init"]

        if n_edges == 2:
            mult += self.weights["Ref"] / 2
        elif n_edges == 1:
            mult += self.weights["Ref"]

        weight -= self.weights["Height"] / 6 * (edge[2] - min_node[2]) * mult

        for gate in self.gates:
            if gate is a or gate is b:
                continue
            if edge[:2] == gate[:2]:
                weight += self.weights["Ref"] * mult
            d = self.dist(edge, gate)
            if d == 3:
                weight += self.gate_popularity[gate] ** 2 * \
                    self.weights["Ref"] * mult
            elif d == 2:
                weight += self.gate_popularity[gate] ** 2 * \
                    self.weights["Ref"] * 2 * mult
            elif d == 1:
                weight += self.gate_popularity[gate] ** 2 * \
                    self.weights["Ref"] * 4 * mult
        return weight

    def printer(self):
        """ Prints the grid, filled in with the gates and netlists as
            per the specifications. """
        grid = np.full((self.y_size, self.x_size, self.z_size), '__')
        for gate in self.gates:
            grid[gate[1], gate[0], gate[2]] = 'GA'  # Numpy fun, that indexing
        for i in self.path_dict:
            for wired_node in self.path_dict[i]:
                grid[wired_node[1], wired_node[0],
                     wired_node[2]] = '{:02}'.format(i + 1)
        for i in range(grid.shape[2]):
            print("### Layer {} ###".format(i + 1))
            if self.debug:
                print("x =     ", end="")
                for j in range(grid.shape[1]):
                    print("{:02} ".format(j), end="")
                print("\n------------------", end="")
                print("-------------------------------------------")
            for j, row in enumerate(grid[:, :, i]):
                if self.debug:
                    print("y = {:02} |".format(j), end="")
                print(' '.join(row))
            print()
        if self.debug:
            self.grid = grid  # for checker

    # The following three functions are here just for debug purposes,
    # they're not pretty.

    def checker(self):
        """ Checks whether all connections go from and to the right places. """
        done = 0
        minimum = 0
        for i, (a, b) in enumerate(self.nl):
            m = self.dist(a, b)
            x, j = self.follow(i, a)
            if self.dist(x, b) > 1:
                print("Connection", i + 1, "sucks, got to", x)
                return False
            done += j
            minimum += m
        print(done, "steps taken, the absolute minimum was", minimum)

    def follow(self, i, a):
        """ Checks whether a connection is continuous. """
        i = '{:02}'.format(i + 1)
        j = 0  # number of steps
        x, y, z = a
        prev = ""
        while True:
            j += 1
            # Explicit content!!!
            if self.z_size > z + 1 and self.grid[y, x, z + 1] == i \
                    and prev != "z - 1":  # last condtion for preventing loops
                z += 1
                prev = "z + 1"
            elif self.x_size > x + 1 and self.grid[y, x + 1, z] == i \
                    and prev != "x - 1":
                x += 1
                prev = "x + 1"
            elif self.y_size > y + 1 and self.grid[y + 1, x, z] == i \
                    and prev != "y - 1":
                y += 1
                prev = "y + 1"
            elif z > 0 and self.grid[y, x, z - 1] == i and prev != "z + 1":
                z -= 1
                prev = "z - 1"
            elif x > 0 and self.grid[y, x - 1, z] == i and prev != "x + 1":
                x -= 1
                prev = "x - 1"
            elif y > 0 and self.grid[y - 1, x, z] == i and prev != "y + 1":
                y -= 1
                prev = "y - 1"
            else:
                break
        return (x, y, z), j

    def badness(self):
        """ Returns something like the amount of gates blocked - progress.
            Not used for anything but a debug print at the moment. """
        badness = 0
        for gate in self.gates:
            mult = 1
            for i in self.path_dict:
                for node in self.path_dict[i]:
                    x = self.dist(node, gate)
                    badness += 1 - .1 * node[2]
                    if x == 3:
                        badness += self.weights["Ref"]
                    elif x == 2:
                        badness += self.weights["Ref"] * 3
                    elif x == 1:
                        badness += self.weights["Ref"] * 9
        return badness / len(self.path_dict)


if __name__ == "__main__":
    """ Reads board csv files in same directory, tries to solve the netlists
        specified in them, prints grids. -d argument to the program call
        add some debug prints and allows selecting netlists below.
    """
    board_y_sizes = [13, 17]
    debug = False
    boards_todo = [2]
    netlists_todo = [1, 2, 3]
    if len(sys.argv) > 1 and str(sys.argv[1]) == '-d':
        debug = True
        boards_todo = [2]
        netlists_todo = [3]

    for board_i in boards_todo:
        netlists, gates = read_board_csv("./circuit_board_{}.csv".
                                         format(board_i)) # MOD: gates terug
        for nl_i in netlists_todo:
            nl = []
            weights = {"Init": 1., "Ref": .15, "Boost": 1.05, "Interval": 5,
                       "Height": .09, "MaxBoosts": 15, "iBumper": 10}
            mults = {"Init": .6, "Max": 1.4, "Step": .01}
            for (a, b) in netlists[nl_i - 1]:
                nl.append(((a[0], a[1], 0), (b[0], b[1], 0)))
            if debug:
                print("\n*** Board {}, netlist {} ***".format(board_i, nl_i))
                print("\n### Connections ###")
                for i, x in enumerate(nl):
                    print("{:02} {}".format(i + 1, x))
                print()

            s = netlist_solver(  # MOD: nu ook gates meegeven
                nl, gates, board_y_sizes[board_i - 1], weights, mults, debug)
            s.solve()
            s.printer()
            if debug:
                s.checker()
