if (grassStarted()) {

# Setup
library(sf)

# Malagasy Communes:
madCoast4 <- fastData("madCoast4")

# Convert sf to GVector:
coast4 <- fast(madCoast4)

# Centroids:
coast <- centroids(coast4)

# Plot:
plot(coast4)
plot(cents, col = "red", add = TRUE)

}
