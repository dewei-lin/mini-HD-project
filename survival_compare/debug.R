# Load reticulate to interface with Python
library(reticulate)

# Define func1 in R
func1 <- function(age, CAG) {
  numerator <- pi * (-21.54 - exp(9.56 - 0.146 * CAG) + age)
  denominator <- sqrt(3) * sqrt(35.55 + exp(17.72 - 0.327 * CAG))
  exp_term <- numerator / denominator
  result <- (1 + exp(exp_term))^(-1)
  return(result)
}

# Generate sequences for Age and CAG
age_seq <- seq(7, 71, length.out = 50)  # Age sequence
CAG_seq <- seq(41, 56, length.out = 50)  # CAG sequence

# Create a grid and compute Z values
grid <- expand.grid(Age = age_seq, CAG = CAG_seq)
grid$func1_value <- mapply(func1, grid$Age, grid$CAG)

# Reshape Z values into a matrix
Z <- matrix(grid$func1_value, nrow = length(age_seq), ncol = length(CAG_seq))

# Define the Python code within R using reticulate
reticulate::py_run_string("
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

# Define age and CAG sequences from R
age_seq = np.array(r.age_seq)
CAG_seq = np.array(r.CAG_seq)

# Z values (func1 output) from R
Z = np.array(r.Z)

# Create meshgrid for plotting
X, Y = np.meshgrid(age_seq, CAG_seq)

# Create a 3D plot
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

# Plot the surface
surf = ax.plot_surface(X, Y, Z.T, cmap='viridis', edgecolor='k', alpha=0.8)

# Add axis labels
ax.set_xlabel('Age')
ax.set_ylabel('CAG')
ax.set_zlabel('Func1 Value')
ax.set_title('Func1 3D Surface Plot')

# Add a color bar
fig.colorbar(surf, ax=ax, shrink=0.5, aspect=5)

# Show the plot
plt.show()
")

