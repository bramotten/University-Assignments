import unittest
import pytest
import shlex, subprocess

from heap import Heap, Node
import heap_sort

class TestHeapMethods(unittest.TestCase):

    def test_commandline(self):
        # python3 on ubuntu systems, might have to be changed to python3
        # If using Windows/Mac
        print("Running test_commandline")
        PROG = "python3 heap_sort.py "
        tests = {
        "3 3 2" : "2 3 3",
        "9 8 7 6 5" : "5 6 7 8 9",
        "6 9 8 4 3 3 1" : "1 3 3 4 6 8 9",
        "3 5 4 1 2 9 10 20" : "1 2 3 4 5 9 10 20",
        "3 3 2 2 1" : "1 2 2 3 3"

        ### You can add your own lines here if you want.

        }

        # Do not touch this function past this point
        passed = 0
        for test in tests:
            args = shlex.split(PROG + test)
            try:
                result = subprocess.run(args, stdout=subprocess.PIPE)
                # Ignore \n
                output = result.stdout.decode('utf-8').replace('\n', '')
                self.assertEqual(output.rstrip(), tests[test])
                passed += 1
            except AssertionError as e:
                print("=" * 70)
                print("FAIL: test_commandline (__main__.TestHeapMethods)")
                print("-" * 70)

                print("Running: " + test)
                print("AssertionError\n", e.args[0])
        print("test_commandline PASSED {0:d}/{1:d}.".format(passed, len(tests)))

    def test_node_comperators_nodes(self):
        print("Running test_node_comperators_nodes")
        n_1 = Node(3, None)
        n_2 = Node(5, None)
        n_3 = Node(5, None)
        n_4 = Node(7, None)
        self.assertEqual(n_2 is n_2, True)
        self.assertEqual(n_2 is n_3, False)
        self.assertEqual(n_1 == n_2, False)
        self.assertEqual(n_1 != n_2, True)
        self.assertEqual(n_1 < n_2, True)
        self.assertEqual(n_4 > n_3, True)
        self.assertEqual(n_3 == n_2, True)
        self.assertEqual(n_4 >= n_3, True)
        self.assertEqual(n_1 <= n_3, True)

    def test_node_comperators_integers(self):
        print("Running test_node_comperators_integers")
        n_1 = Node(3, None)
        self.assertEqual(n_1 == 2, False)
        self.assertEqual(n_1 == 3, True)
        self.assertEqual(n_1 != 6, True)
        self.assertEqual(n_1 < 5, True)
        self.assertEqual(n_1 > 2, True)
        self.assertEqual(n_1 >= 1, True)
        self.assertEqual(n_1 >= 3, True)
        self.assertEqual(n_1 <= 5, True)
        self.assertEqual(n_1 <= 3, True)

    def test_insert_single_node(self):
        print("Running test_insert_single_node")
        h = Heap()
        h.insert(5)
        self.assertEqual(h.find_max().get_value(), 5)
        self.assertEqual(str(h), '5')

    def test_insert_3_nodes_ordered(self):
        print("Running test_insert_3_nodes_ordered")
        h = Heap()
        h.insert(10)
        h.insert(6)
        h.insert(5)
        self.assertEqual(str(h), '10 6 5')

    def test_build_heap(self):
        print("Running test_build_heap")
        h = Heap.build_heap([5, 6, 10])
        self.assertEqual(str(h), '10 5 6')

    def test_insert_7_nodes_ordered(self):
        print("Running test_insert_7_nodes_ordered")
        h = Heap.build_heap([6, 5, 4, 3, 2, 2, 3])
        self.assertEqual(str(h), '6 5 4 3 2 2 3')

    def test_insert_3_nodes_unordered(self):
        print("Running test_insert_3_nodes_unordered")
        h = Heap.build_heap([6, 5, 10])
        self.assertEqual(str(h), '10 5 6')

    def test_insert_7_nodes_unordered(self):
        print("Running test_insert_7_nodes_unordered")
        h = Heap.build_heap([2, 3, 2, 4, 5, 6, 3])
        self.assertEqual(str(h), '6 4 5 2 3 2 3')

    def test_extract_max(self):
        print("Running test_extract_max")
        h = Heap.build_heap([4, 2, 3, 1])
        h.extract_max()
        self.assertEqual(str(h), '3 2 1')

    def test_child_parent_link(self):
        print("Running test_child_parent_link")
        h = Heap.build_heap([21, 17, 11, 15, 6, 5, 8, 1, 9])
        n = h.find_max().get_right_child().get_left_child()
        self.assertEqual(n.get_value(), 5)
        self.assertEqual(n.get_parent().get_value(), 11)

    def test_delete(self):
        print("Running test_delete")
        h = Heap.build_heap([21, 17, 11, 15, 6, 5, 8, 1, 9])
        h.delete(h.find_max().get_left_child())
        self.assertEqual(str(h), '21 15 11 9 6 5 8 1')

    def test_delete2(self):
        print("Running test_delete2")
        h = Heap.build_heap([33, 27, 22, 25, 19, 10, 11, 23, 24])
        h.delete(h.find_max().get_right_child().get_left_child())
        self.assertEqual(str(h), '33 27 24 25 19 22 11 23')

    def test_child_parent_link_after_delete(self):
        print("Running test_child_parent_link_after_delete")
        h = Heap.build_heap([33, 27, 22, 25, 19, 10, 11, 23, 24])
        n = h.find_max().get_right_child().get_left_child()
        self.assertEqual(n.get_value(), 10)
        h.delete(n)
        n = h.find_max().get_right_child().get_left_child()
        self.assertEqual(n.get_value(), 22)

if __name__ == "__main__":
    unittest.main()
