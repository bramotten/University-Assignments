import sys
from heap import Heap, Node


def heap_sort(elements):
    h = Heap.build_heap(elements)
    sorted_list = []
    n = h.size()
    for i in range(n):
        sorted_list.append(int(h.extract_max().value))
    return sorted_list[::-1] # return min ... max


if __name__ == "__main__":
    elements = list(sys.argv)[1:]
    sorted_list = heap_sort(elements)
    for element in sorted_list:
        print(element, "", end="")
    print()