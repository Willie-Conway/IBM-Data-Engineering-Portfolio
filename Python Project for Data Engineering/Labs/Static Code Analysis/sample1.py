"""This module demonstrates a simple addition operation."""  # Module docstring


def add(number1, number2):
    """Return the sum of two numbers."""  # Function docstring
    return number1 + number2


NUM1 = 4  # Constants in UPPER_CASE to avoid naming convention warnings
NUM2 = 5

# Call the function and store the result
TOTAL = add(NUM1, NUM2)

# Use an f-string for better formatting (modern best practice)
print(f"The sum of {NUM1} and {NUM2} is {TOTAL}")
