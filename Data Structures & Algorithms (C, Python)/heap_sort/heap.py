'''
-   I never check 'if self is None'
-   I don't maintain a list of every node,
    but I practically do build one in a few
    functions. I got the impression that was okay.
'''

from copy import deepcopy


class Node:

    def __init__(self, value, parent=None):
        if parent is not None and not isinstance(parent, Node):
            raise ValueError("Tried to init node with invalid parent")
        self.parent = parent
        self.left = None
        self.right = None
        self.value = value

    def get_value(self):
        ''' Returns the value of the node.

            Returns:
                int: Value of the node.
        '''
        return self.value

    def get_parent(self):
        ''' Returns the parent of the node.

            Returns:
                Node: Parent node.
        '''
        return self.parent

    def get_left_child(self):
        ''' Returns the left child of the node.

            Returns:
                Node: Left child node.
        '''
        return self.left

    def get_right_child(self):
        ''' Returns the right child of the node.

            Returns:
                Node: Right child node.
        '''
        return self.right

    def __str__(self):
        ''' Overrides print(Node), makes it print the value.'''
        returnstring = "{}".format(self.value)
        return returnstring

    # Overriding the comparison operators to compare value's:

    def __eq__(self, other):
        if isinstance(other, Node):
            return self.value == other.value
        elif isinstance(other, (int, float, complex)):
            return self.value == other
        elif other is None:
            return False
        else:
            raise ValueError("Can't compare node with {}".format(type(other)))

    def __lt__(self, other):
        if isinstance(other, Node):
            return self.value < other.value
        elif isinstance(other, (int, float, complex)):
            return self.value < other
        else:
            raise ValueError("Can't compare node with {}".format(type(other)))

    def __gt__(self, other):
        if isinstance(other, Node):
            return self.value > other.value
        elif isinstance(other, (int, float, complex)):
            return self.value > other
        else:
            raise ValueError("Can't compare  node with {}".format(type(other)))

    def __le__(self, other):
        if isinstance(other, Node):
            return self.value <= other.value
        elif isinstance(other, (int, float, complex)):
            return self.value <= other
        else:
            raise ValueError("Can't compare node with {}".format(type(other)))

    def __ge__(self, other):
        if isinstance(other, Node):
            return self.value >= other.value
        elif isinstance(other, (int, float, complex)):
            return self.value >= other
        else:
            raise ValueError("Can't compare  Node with {}".format(type(other)))


class Heap:
    def __init__(self, head_node=None):
        ''' Constructor, with the ability to accept a initial head_node.

            Args:
                head_node (Node): Potentially a first node, else None
        '''
        if head_node is not None and not isinstance(head_node, Node):
            raise ValueError("Tried to init heap with invalid root")
        self.root = head_node
        self.tail = self.root
        self.n = self.root is not None  # 0 when initialized with head: None

    # Basic
    def size(self):
        ''' Returns the number of elements on the Heap

            Returns:
                int: The number of elements on the Heap.
        '''
        if not isinstance(self, Heap):
            return 0  # in case inserting went wrong for all elements
        return self.n

    def find_max(self):
        ''' Finds the node with the maximum value of the heap.

            Returns:
                Node: The node with the max value. None if not successful.
        '''
        return self.root

    def insert(self, number):
        ''' Inserts a node into the heap, and sifts it up properly.

            Args:
                number (int): An integer that is to be added to the heap.
        '''
        self.n += 1
        if self.root is None:
            # Initialize heap
            self.root = Node(number)
            self.tail = self.root
        else:
            # Insert in last free spot (make new tail), sift up
            parent = self.__find_first_free_parent()
            node = Node(number, parent)
            self.tail = node
            if parent.left is None:
                parent.left = node
            else:
                parent.right = node
            self.__sift_up(node)

    def extract_max(self):
        ''' Finds the node with the maximum value of the heap,
            and removes it from the heap.

            Returns:
                Node: The node with the max value. None if not successful.
        '''
        return self.delete(self.find_max())

    # Creation
    def build_heap(value_list):
        ''' Generates a heap from a list of integers

            Args:
                value_list (list): A list of integers

            Returns:
                Heap: A max-heap made from the elements of the list.
        '''
        h = Heap()
        for value in value_list:
            try:
                h.insert(int(value))
            except ValueError:
                print("Skipping invalid input argument {}".format(value))
        return h

    # Inspection
    def is_empty(self):
        ''' Checks if the list is empty

            Returns:
                bool: Returns True if empty, False otherwise.
        '''
        return self.n == 0

    # Internal
    def delete(self, node):
        ''' Removes a node from the heap, and returns it.

            Args:
                node (Node): The node that is to be removed.

            Returns:
                Node: Returns the removed node, else None
        '''
        if self.n == 0:
            return None

        if not isinstance(node, Node):
            raise ValueError("Can't delete non-Node")
            return None

        # Emptying the heap is a special case
        self.n -= 1
        if self.n == 0:
            self.root = None
            node.parent = None
            node.left = None
            node.right = None
            return node

        # Replace node with tail, copy to be able to just replace values
        to_return = deepcopy(node)
        node.value = self.tail.value

        # Remove references to previous location of tail
        new_tail = self.__find_second_to_last_tail()
        if self.tail.parent.right is not None:
            self.tail.parent.right = None
        else:
            self.tail.parent.left = None
        self.tail = new_tail

        # Sift changed nodes to proper positions
        self.__sift_up(node)
        self.__sift_down(node)

        return to_return

    def __sift_up(self, node):
        ''' Applies the sift_up operation starting from the node.'''
        while node.parent is not None and node.parent < node:
            # Keep left and right pointers intact, swap values.
            temp = node.parent.value
            node.parent.value = node.value
            node.value = temp
            node = node.parent

    def __sift_down(self, node):
        ''' Applies the sift_down operation starting from the node.'''
        while node.left is not None:
            if node.right is not None and node.right > node.left \
                    and node.right > node:
                temp = node.right.value
                node.right.value = node.value
                node.value = temp
                node = node.right

            elif node.left > node:
                temp = node.left.value
                node.left.value = node.value
                node.value = temp
                node = node.left

            else:
                # Not smaller than children
                break

    # Helpers

    # I never use this function, but it's a way to navigate through the
    # nodes without using lists of any kind.
    def __find(self, n):
        ''' Returns node at index n (with root being 1). '''
        pointer = self.root
        current = n
        while(current > 1):
            if(current % 2):
                if pointer.right is not None:
                    pointer = pointer.right
                else:
                    return None
            else:
                if pointer.left is not None:
                    pointer = pointer.left
                else:
                    return None
            current = int(current / 2)
        return pointer

    def __find_first_free_parent(self):
        ''' Finds the first parent that should have another child
            attached to it.

            Returns:
                Node: Returns the parent that should recieve the
                      next child, else None.
        '''
        if self.root is None:
            return None
        stack = [self.root]
        while stack:
            # LIFO expand branches
            current = stack[0]
            stack = stack[1:]
            if current.left is not None:
                stack.append(current.left)
            if current.right is not None:
                stack.append(current.right)
            else:
                return current
        return None  # can't really reach

    def __find_second_to_last_tail(self):
        ''' Starting from the current tail_node, find the node that
            would be the new tail, when the current tail_node is removed.

            Returns:
                Node: Returns the new tail_node, else None.
        '''
        stack = [self.root]
        last = [None, self.root]
        while stack:
            current = stack[0]
            stack = stack[1:]
            last[0] = last[1]
            last[1] = current  # will eventually be the actual tail
            if current.left is not None:
                stack.append(current.left)
                if current.right is not None:
                    stack.append(current.right)
        return last[0]

    # Overwritten functions
    def __str__(self):
        ''' Should return the heap printed out in breadth-first order,
            delimited by spaces.

            Returns:
                str: Breadth-first string representation of the heap.
        '''
        string = ""
        if self.root is None:
            return string
        stack = [self.root]
        while stack:
            current = stack[0]
            stack = stack[1:]
            string += str(current) + " "
            if current.left is not None:
                stack.append(current.left)
                if current.right is not None:
                    stack.append(current.right)
        return string[:-1]  # remove last space


if __name__ == "__main__":
    h = Heap.build_heap([1, 2])
    h.insert(9)
    h.delete(h.find_max().left)
    h.delete(h.find_max().left)
    h.insert(-1)
    h.delete(h.find_max().left)
    h.delete(h.find_max())
    h.insert(-3)
    h.insert(9)
    print(h)
