.libPaths("/usr/local/lib/R/library") 
library(ggplot2)
library(gganimate)
library(hrbrthemes)
library(dplyr)
library(transformr)

# Ensure the output directory exists
output_dir <- "./plot"
if (!dir.exists(output_dir)) {
  dir.create(output_dir)
}

frame_dir <- "./plot/frames"
if (!dir.exists(frame_dir)) {
  dir.create(frame_dir, recursive = TRUE)
}


# Animation 2: Evolution of Severity Over Time
CAP <- 432.3326
time <- seq(0.1, 50, length.out = 500)  # Avoid log(0)

df <- data.frame(
  t = time,
  Severity = 1 - (1 / (1 + exp((log(time) - (4.4196 - 0.0065 * CAP)) / exp(-0.8451))))
)

p <- df %>%
  ggplot(aes(x = t, y = Severity)) +
  geom_line(color = "red") +
  geom_point(color = "red") +
  ggtitle("Evolution of Severity Over Time") +
  theme_ipsum() +
  ylab("Probability of Onset") +
  xlab("Time (Years)") +
  xlim(0, 30) +
  transition_reveal(t)

options(gganimate.dev_args = list(path = frame_dir))
anim_save(
  filename = file.path("./plot", "progression.gif"),
  animation = p,
  renderer = gifski_renderer(loop = TRUE)
)

