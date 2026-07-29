# Set WD
setwd("~/PhD/Code/R/NRG_george_dynamic_plots")

# ===============================================================================
# ----------------------------Using magick package-------------------------------
# ===============================================================================

# This package allows the easy manipulation of images:
# https://cran.r-project.org/web/packages/magick/vignettes/intro.html

# First install and load
# install.packages('magick')
library(magick)

# Reading in images and image vectors
# -----------------------------------

# You can read in an image and enact transformations...

img = image_read('https://images.pexels.com/photos/4388593/pexels-photo-4388593.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500') 
img
# scale image
img = image_scale(img, '200')
img
# Anotate
image_annotate(img, 'Written', size=20, color='white', location = geometry_point(60, 10))

# Vectors of images
# Below is a sequence where the annotation will move
fig1 = c()
for(i in c(0, 30, 60, 90)){
  fig1 = append(fig1, image_annotate(img, 'Written', size=20, 
                                 color='white', location = geometry_point(i, 40)))
}
fig1


# From vectors to animations (GIFs)
# ---------------------------------

# Given an vector of images making a GIF is really easy

gif1 = image_animate(fig1, fps = 5, optimize = TRUE)  # Optimize = TRUE saves space by storing only differences between images (images must be same size)
gif1


# Plot straight to an magick vector
#----------------------------------

# To make a dynamic plot each frame will be a plot. To save having to write plots as images and read
# them in again, magick allows you to have plots go straight into an magick vector.

# Example: Sin wave

# Set up plotting enviroment (like doing png() or pdf())
fig2 = image_graph(width = 400, height = 400, res = 100)

# Now each call of plot() will store an image in fig2, seen as a magick vector
x = seq(0, 2*pi, length.out=100)
for(c in seq(0, 2*pi, length.out = 30)){
  plot(x, sin(x-c), 'l')
}
dev.off()
fig2
# Make into animation
gif2 = image_animate(fig2, fps = 20, optimize = TRUE)  # Optimize = TRUE saves space by storing only differences between images (images must be same size)
gif2


# =================================================================================
# -----------------------------magick + iGraph-------------------------------------
# =================================================================================

# Now we consider using magick and the plotting functionality of iGraph to easily make some 
# dynamic visualizations 

# Note that there are other approaches/packages you could use, e.g. see https://kateto.net/network-visualization, but this approach is simple way to extend the plotting of iGraph.


# Example 1: A Sample from Hollywood Model (Crane and Dempsey 2018)
#------------------------------------------------------------------
# Read in graph
library(igraph)
G = read.graph('HollywoodSample.graphml', format = 'graphml')
G
# G represents a sequence of paths over a set of nodes. Edges have an 'index' attribute
# to indicate (discretely) when they appeared. At a high level, G was sampled via the
# idea of preferential attachment, that is, popular nodes are more likely to be visited

E(G)$index

# Initial plot
l = layout.lgl(G, repulserad=2)  # Force-directed layout algorithm (spaces nodes out nicely)
plot(G, layout=l,vertex.label = NA, edge.arrow.size = 0.4, margin = 0.05, 
     edge.width=0.5)

# Plot first path, done with subgraph.edges()
Curr = subgraph.edges(G, which(E(G)$index==1), delete.vertices = F)
plot(Curr, layout=l,vertex.label = NA, edge.arrow.size = 0.4, margin = 0.05, 
     edge.width=0.5) # Observe that layout for G has been used here
E(G)[E(G)$index==1]  # See the plotted path on edge sequence

# Now we make an anmiation by looping over indexes and storing in magick vector

fig3 = image_graph(width = 400, height = 400, res = 150, pointsize = 20)
for(i in 1:max(E(G)$index)){
  
  Curr = subgraph.edges(G, which(E(G)$index==i), delete.vertices = F)
  
  V(Curr)$frame.color = 'white'
  V(Curr)$color = 'red'
  par(mar = rep(0.5, 4))
  plot(Curr, layout = l, vertex.label = NA, edge.arrow.size = 0.2, margin = 0.5, 
       edge.width=0.5)
  
}
dev.off()
gif3 = image_animate(fig3, fps=10)
gif3

# You can also do some other nice things like have vertices appear in order or
# grow vertex radius over time.

MAX_DEG = max(degree(G)) # For normalising vertex size
fig3 = image_graph(width = 400, height = 400, res = 150, pointsize = 20)
for(i in 1:max(E(G)$index)){
  
  Curr = subgraph.edges(G, which(E(G)$index==i), delete.vertices = F)
  Agg = subgraph.edges(G, which(E(G)$index<=i), delete.vertices = F)
  
  V(Curr)$frame.color = 'white'
  V(Curr)$color = 'red'
  V(Curr)$color[degree(Agg)==0] = NA
  V(Curr)$size = 10*(1 + 2*degree(Agg)/MAX_DEG)
  par(mar = rep(0.5, 4))
  plot(Curr, layout = l, vertex.label = NA, edge.arrow.size = 0.2, margin = 0.5, 
       edge.width=0.5)
  
}
dev.off()
gif3 = image_animate(fig3, fps=10)
gif3

# **SAVING**

# As gif
image_write(gif3, 'Animation1.gif')

# As individual images (for LaTeX)
# Note I have already made the folder in which to put these files
n = length(fig3)
for(i in 1:n){
  filename = paste("Animation1/frm-", i, ".png", sep = '')
  image_write(fig3[i], path=filename)
}

# Example 2: Plotting Enron Email Dataset
# ---------------------------------------

# As a bit of fun I have also considered plotting a open source dataset, ENRON emails, found
# in igraphdata package
library(igraphdata)

data("enron")
# Vertice = employees
# Edges = emails (timestamped)

# First tidy up the data: (i) remove some odd entries with weird dates (ii) convert times to just month and year
E(enron)$Time

d = as.Date(E(enron)$Time)
d0 = as.Date('1980-01-01')

# Now filter out edges before time d0
G = subgraph.edges(enron, E(enron)[d>d0], delete.vertices = T)  #Rename and remove unused vertices
G = delete_vertices(G, V(G)[degree(simplify(G, remove.multiple = T, remove.loops = T))==0]) # Some isolated vertice persist, so also remove these.
E(G)$Time

# Change timestamps to month-year
d = as.Date(E(G)$Time)
d = strftime(d, format = '%m-%y')
E(G)$Time = d
unique(E(G)$Time)

# Now make animation by plotting emails for each month sequentially
l = layout.lgl(simplify(G, remove.multiple = T, remove.loops = T), repulserad=3)
fig4 = image_graph(width = 600, height = 600, res = 100)
for(t in unique(E(G)$Time)){
  Curr = subgraph.edges(G, which(E(G)$Time==t), delete.vertices = F)
  Curr = simplify(Curr, remove.multiple = T)
  plot(Curr, vertex.label=NA, vertex.size=4,
       layout=l, edge.arrow.size=0.1, margin = 0.2, vertex.frame.color='white',
       vertex.color='red')
}
dev.off()
for(i in 1:length(unique(E(G)$Time))){
  fig4[i] = image_annotate(fig4[i], unique(E(G)$Time)[i], size = 10, color = 'Black',location = geometry_point(150, 110))
}
gif4 = image_animate(fig4, fps = 4, optimize = TRUE)
gif4

# **SAVING**

# As gif
image_write(gif4, 'Animation2.gif')

# As individual images (for LaTeX)
# Note I have already made the folder in which to put these files
n = length(fig4)
for(i in 1:n){
  filename = paste("Animation2/frm-", i, ".png", sep = '')
  image_write(fig4[i], path=filename, quality = 100)
}







