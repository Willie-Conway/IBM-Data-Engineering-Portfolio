import unittest
from mymodule import square, double, add

class TestSquare(unittest.TestCase): 
    def test_square_values(self): 
        self.assertEqual(square(2), 4)
        self.assertEqual(square(3.0), 9.0)
        self.assertNotEqual(square(-3), -9)

class TestDouble(unittest.TestCase): 
    def test_double_values(self): 
        self.assertEqual(double(2), 4)
        self.assertEqual(double(-3.1), -6.2)
        self.assertEqual(double(0), 0)

class TestAddFunction(unittest.TestCase):
    def test_add_integers(self):
        self.assertEqual(add(2, 4), 6)

    def test_add_zeros(self):
        self.assertEqual(add(0, 0), 0)

    def test_add_floats(self):
        self.assertEqual(add(2.3, 3.6), 5.9)

    def test_add_strings(self):
        self.assertEqual(add('hello', 'world'), 'helloworld')

    def test_add_more_floats(self):
        self.assertEqual(add(2.3000, 4.300), 6.6)

    def test_negative_integers(self):
        self.assertNotEqual(add(-2, -2), 0)

if __name__ == '__main__':
    unittest.main()
