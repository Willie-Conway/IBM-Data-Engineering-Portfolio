import matplotlib.pyplot as plt
import numpy as np

# Given dataset
years_experience = np.array([1, 2, 3, 4, 5])
salaries = np.array([45, 50, 55, 60, 65])  # in thousands

# Manually calculated slope (m) and intercept (b)
m = 5  # $5k per year
b = 40  # starting salary ($40k)

# Regression line: y = mx + b
regression_line = m * years_experience + b

# Plotting
plt.figure(figsize=(8, 5))
plt.scatter(years_experience, salaries, color='blue', label='Actual Data')
plt.plot(years_experience, regression_line, color='red', label='Regression Line (y = 5x + 40)')
plt.title("Salary vs Years of Experience")
plt.xlabel("Years of Experience")
plt.ylabel("Salary (in $1000s)")
plt.grid(True)
plt.legend()
plt.tight_layout()
plt.show()
