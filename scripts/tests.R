library(tidyverse)
library(viridis)
library(patchwork)
# library(hrbrthemes)
library(circlize)

# Load dataset from github
data <- read.table("https://raw.githubusercontent.com/holtzy/data_to_viz/master/Example_dataset/13_AdjacencyDirectedWeighted.csv", header=TRUE)
# Package
library(networkD3)

# I need a long format
data_long <- data %>%
  rownames_to_column %>%
  gather(key = 'key', value = 'value', -rowname) %>%
  filter(value > 0)
colnames(data_long) <- c("source", "target", "value")
data_long$target <- paste(data_long$target, " ", sep="")

# From these flows we need to create a node data frame: it lists every entities involved in the flow
nodes <- data.frame(name=c(as.character(data_long$source), as.character(data_long$target)) %>% unique())

# With networkD3, connection must be provided using id, not using real name like in the links dataframe.. So we need to reformat it.
data_long$IDsource=match(data_long$source, nodes$name)-1 
data_long$IDtarget=match(data_long$target, nodes$name)-1

# prepare colour scale
ColourScal ='d3.scaleOrdinal() .range(["#FDE725FF","#B4DE2CFF","#6DCD59FF","#35B779FF","#1F9E89FF","#26828EFF","#31688EFF","#3E4A89FF","#482878FF","#440154FF"])'

# Make the Network
sankeyNetwork(
  Links = data_long, 
  Nodes = nodes,
  Source = "IDsource",
  Target = "IDtarget",
  Value = "value",
  NodeID = "name", 
  sinksRight=FALSE, 
  #colourScale=ColourScal, 
  nodeWidth=40, 
  fontSize=13, 
  nodePadding=20,
  fontFamily = 'Montserrat')



# EUUU --
#PEGAR db3

levels_source <- data.frame(
  item1 = as.character(unique(db3$item1)),
  IDsource = as.numeric(1:length(unique(db3$item1)))
)

levels_target <- data.frame(
  item2 = as.character(unique(db3$item2)),
  IDtarget = 1:length(unique(db3$item2))+5
)

db_ok <- db3 %>%
  left_join(levels_source, by = c('item1'='item1')) %>%
  left_join(levels_target, by = c('item2'='item2')) %>%
  rename(
    'source' = 'item1',
    'target' = 'item2'
  ) %>%
  select(-order_aux) %>%
  data.frame() %>%
  arrange(source, target)

nodes <- data.frame(name = c(unique(db_ok$source),unique(db_ok$target)))

# Make the Network
sankeyNetwork(
  Links = db_ok, 
  Nodes = nodes,
  Source = "IDsource",
  Target = "IDtarget",
  Value = "correlation",
  NodeID = "name", 
  sinksRight=FALSE, 
  #colourScale=ColourScal, 
  nodeWidth=40, 
  fontSize=13, 
  nodePadding=20,
  fontFamily = 'Montserrat')








