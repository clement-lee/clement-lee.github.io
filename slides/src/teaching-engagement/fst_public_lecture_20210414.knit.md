---
title: |
  Visualising & analysing the evolution  
  of social networks
subtitle: "Science Week Public Lecture Series"
author: "Clement Lee"
date: "2021-04-14 (Wed)"
output: beamer_presentation
header-includes:
  \setlength{\leftmargini}{\labelwidth}
  \usetheme[mathstats]{lancasterbeamer}
classoption: "aspectratio=169"
---







## Networks
<!-- Thank you for tuning in today. I'm a lecturer in the Department of Mathematics and Statistics. Apart from teaching, I am doing research in Statistics, with a focus on networks, which consist of nodes and edges. This could be brain networks, where the nodes are neurons and the edges are neural connections, or social networks, where the nodes are users and the edges are followings or friendships, depending on what social networks we are look at. Of course these networks will be much bigger than the one shown on the right, but this network is useful for what I will be introducing. -->

::: columns
:::: column
* Brain
  - Neurons and neural connections
  
* Social networks
  - Users and following / friendships
::::
:::: column

\begin{center}\includegraphics[width=0.7\linewidth]{/data/github_io/slides/fst_public_lecture_20210414_files/figure-beamer/brg_model-1} \end{center}
::::
:::





## How do social networks evolve?
<!-- The question we are asking here is how do social networks evolve over time? Users will join or leave over time, and what we are interested in is, when new users join a network, what other users will they befriend or follow. This could be celebrities or politicians, or pages or accounts related to their hobbies or interests. These are slight tricky to quantify, but there is one phenomenon that is easier to be described mathematically, and that is the more popular users are more likely to be followed, because you are more likely to see their presence on the network, maybe through somebody's sharing of their posts, or through the recommendations by the network. -->

* When new users join e.g. Twitter / Instagram, who do they follow?

* Celebrities? Politicians?

* Accounts related to the interests of the users

* Those with a huge following are more likely to be followed





## Mathematical modelling
<!-- Researchers such as statisticians, mathematicians and physicists like to describe real-life phenomena using mathematical rules, and this is where mathematical models come in. One thing we usually do is, we come up with a model based on some simple rules, and simulate some data from the model, and then compare the simulations with the actual data. If they look similar to each other, it means the model is doing not a bad job. -->

* To describe the phenomenon

* To capture the essence of the data

* Based on rules in mathematics and/or physics

* Simulate data and compare to real-life observations





## Preferential attachment model
<!-- For networks, there is this research by these two guys Barabasi and Albert, who came up with what we call the preferential attachment model with a few simple rules. First, the nodes join the network sequentially. Second, each new node will bring in approximately the same number of new edges. Roughly speaking, if you calculate the average of new edges of the first say 100 nodes, it will be the same as that for the next 100 nodes, and the following 100 nodes, and so on. Finally, and most importantly, how likely an existing node gets connected to a new node depends on how connected they already are. Here I use the term degree, which means the number of edges or connections of a node. -->

* [Barabási and Albert (1999, Science)](http://doi.org/10.1126/science.286.5439.509)

* Rule 1: New nodes join the network one by one

* Rule 2: Each new node brings in (approximately) the same number of new edges

* Rule 3: Probability that an existing node gets an edge is proportional to their current degree

* Degree = number of edges





## A simple example
<!-- These rules seem quite abstract so I will give a simple example, using the network of five nodes we saw at the beginning. Let's say node F joins the network and brings in two new edges. Which of the five nodes should it connect to? We first calculate the degree of each node, and divide by the total, which is 10 here. This will then be the probability of getting connected to F. As B and D are more connected than the others, they are more likely to get the new connections. -->

::: columns
:::: column
* Let's say node F brings in two new edges\itemsep=0.5em
  - Who should it connect to?

* Node A has probability of 1/10 of getting connected

* Node B has probability of 3/10 of getting connected, and so on
::::
:::: column

\begin{center}\includegraphics[width=0.7\linewidth]{/data/github_io/slides/fst_public_lecture_20210414_files/figure-beamer/brg_model_add0.0-1} \end{center}
::::
:::





## A simple example
<!-- In order to see what happens next we need to carry out simulations, which are not quite different to tossing coins for a lot of times, except that they are all done in a computer. In this simulation, B gets the first edge. -->

::: columns
:::: column
* Let's say node F brings in two new edges\itemsep=0.5em
  - Who should it connect to?

* Node A has probability of 1/10 of getting connected

* Node B has probability of 3/10 of getting connected, and so on
::::
:::: column

\begin{center}\includegraphics[width=0.7\linewidth]{/data/github_io/slides/fst_public_lecture_20210414_files/figure-beamer/brg_model_add0.5-1} \end{center}
::::
:::





## Adding the edges
<!-- To decide who gets the second edge, we cross out B, and recalculate the probabilities. While the probabilities for all nodes are bumped up, it's still D who has the highest probability of getting connected. -->

::: columns
:::: column
* Let's say the first new edge goes to node B\itemsep=0.5em
  - Who should it connect to next?

*  Node A has probability of 1/7 of getting connected

*  Node C has probability of 2/7 of getting connected, and so on
::::
:::: column

\begin{center}\includegraphics[width=0.7\linewidth]{/data/github_io/slides/fst_public_lecture_20210414_files/figure-beamer/brg_model_add1.0-1} \end{center}
::::
:::





## Adding the edges
<!-- However, in this simulation, it's C who gets the second edge. It's not too improbable as this is an event with a probability of 2/7 in the first place. -->


::: columns
:::: column
* Let's say the first new edge goes to node B\itemsep=0.5em
  - Who should it connect to next?

*  Node A has probability of 1/7 of getting connected

*  Node C has probability of 2/7 of getting connected, and so on
::::
:::: column

\begin{center}\includegraphics[width=0.7\linewidth]{/data/github_io/slides/fst_public_lecture_20210414_files/figure-beamer/brg_model_add1.5-1} \end{center}
::::
:::





## The process can keep going
<!-- You can see that the process can keep going, and new nodes can join the network in the same fashion. The existing nodes, which now include F, will get connected in the same way as I have described, but the probabilities may change as their degrees may be updated. -->

::: columns
:::: column
* The next node join in the same fashion\itemsep=0.5em
  - Bring in new edges

* The existing nodes get connected in the same fashion
  - Probabilities according to their (updated) degree
::::
:::: column

\begin{center}\includegraphics[width=0.7\linewidth]{/data/github_io/slides/fst_public_lecture_20210414_files/figure-beamer/brg_model_add_more-1} \end{center}
::::
:::





## Growing a big(ger) network
<!-- I kept growing the network, and this is the evolution when there are over a hundred nodes involved. The grey lines are the new edges, and the size of a node is proportional to its degree. The nodes in the centre are those we have seen, and you can see that they keep getting bigger and bigger over time. -->




\begin{center}\includegraphics[width=0.4\linewidth]{/data/github_io/slides/fst_public_lecture_20210414_files/figure-beamer/PA_model-1} \end{center}





## Distribution of the degree
<!-- While it's nice to animate the evolution, we are interested in the overall properties of the network after the simulation. Here, I plot the distribution of the degree. The top-left point means that there are 19 nodes with 1 connection only, while the bottom-right point means there is one node with almost 120 connections. Apparently these few points sitting just above the horizontal axis are the big nodes in the centre of the network, and you see the inequality of the connections among the nodes. -->


\begin{center}\includegraphics[width=0.6\linewidth]{/data/github_io/slides/fst_public_lecture_20210414_files/figure-beamer/dist-1} \end{center}





## On logarithmic scale
<!-- Sometimes, there's more revealed if we plot the data on a logarithmic scale. This figure contains the same information, but moving the horizontal axis by a constant amount means multiplying by the same contant, instead of adding it. You can see that there are quite a few points lying close to this red dashed line, which is not apparent in the previous slide. This seems an interesting pattern, but so far we have been looking at one simulation only, and there's quite noise in the data. You might question that if a similar pattern will show up in other simulations. -->


\begin{center}\includegraphics[width=0.6\linewidth]{/data/github_io/slides/fst_public_lecture_20210414_files/figure-beamer/dist_log-1} \end{center}





## Bigger networks, more simulations
<!-- So we ran more simulations with bigger networks, and this is the end result. While there are some small differences, you can see the big picture stays the same, and this red sloped line applies to the body of the points in all simulations. What's so interesting about this straight line? -->




\begin{center}\includegraphics[width=0.24\linewidth]{/data/github_io/slides/fst_public_lecture_20210414_files/figure-beamer/plot_bigger_1-1} \includegraphics[width=0.24\linewidth]{/data/github_io/slides/fst_public_lecture_20210414_files/figure-beamer/plot_bigger_1-2} \includegraphics[width=0.24\linewidth]{/data/github_io/slides/fst_public_lecture_20210414_files/figure-beamer/plot_bigger_1-3} \includegraphics[width=0.24\linewidth]{/data/github_io/slides/fst_public_lecture_20210414_files/figure-beamer/plot_bigger_1-4} \end{center}

\begin{center}\includegraphics[width=0.24\linewidth]{/data/github_io/slides/fst_public_lecture_20210414_files/figure-beamer/plot_bigger_2-1} \includegraphics[width=0.24\linewidth]{/data/github_io/slides/fst_public_lecture_20210414_files/figure-beamer/plot_bigger_2-2} \includegraphics[width=0.24\linewidth]{/data/github_io/slides/fst_public_lecture_20210414_files/figure-beamer/plot_bigger_2-3} \includegraphics[width=0.24\linewidth]{/data/github_io/slides/fst_public_lecture_20210414_files/figure-beamer/plot_bigger_2-4} \end{center}





## The power law
<!-- It turns out that this line illustrates what we call the power law. You might not have heard of it, but it's likely you have heard of the other terms listed here, such as the rich get richer, or the 80-20 rule. In the context of networks, as the rich, which means the big nodes, get richer, the inequality accumulates, and we end up with a small percentage of nodes receiving most of the edges. This is quite consistent with phenomena observed in other fields or other kinds of data. For example, if you are buying things online you may want to read reviews first before purchasing. Those products of good quality will tend to be purchased more and in turn get more good reviews, and are purchased even more and becoming even more popular over time. -->

* The rich get richer (and the poor get poorer)

* The 80-20 rule / Pareto principle

* Cumulative inequality / disadvantage

* The Matthew effect (of accumulated advantage)





## Takeaway
<!-- So what's the takeaway here? We see that the big picture stays the same, and regardless of the initial settings, we will end up observing the power law in the network. However, as the network evolves and changes, there is an element of chance involved, and so which individual nodes will succeed the most may vary, although the earlier nodes usually have an advantage. So don't feel disappointed if you don't have a huge following on Twitter or YouTube, it might just be that you have not been so lucky. -->

* The big picture stays the same

* Which individual nodes will succeed may vary

* Change involves an element of chance





---
<!-- On that note, I would like to thank you for listening! -->


\begin{center}\includegraphics[width=0.77\linewidth]{images/backdrop} \end{center}
