---
layout: post
title: Overview of software for Bayesian inference with R
categories: [R]
---

This is motivated by [this paper in Statistical Science](https://doi.org/10.1214/23-STS907), [this blog on writing Gibbs sampler in various languages](https://darrenjw.wordpress.com/2011/07/16/gibbs-sampler-in-various-languages-revisited/), and coming across [template model builder (TMB)](https://cran.r-project.org/package=TMB) and [monty](https://mrc-ide.github.io/monty/) at various points.

My main question is: **How many ways can I write code for Bayesian inference for a statistical model (assumed to be a common one), using R as the interface?** By ways I usually mean a different suite of package, syntax & underlying sampler, but the distinction is more blurred than I expected. I would divide them into four main groups:

1. BUGS based: JAGS, NIMBLE
2. Stan based: Stan, brms, rstanarm
3. TMB based: TMB, glmmTMB, RTMB, tmbstan
4. Monty
5. INLA

There are several considerations here:

- Some are not a different lanugage as they use the same engine e.g. brms & rstanarm are front-ends of Stan, and similar with glmmTMB and RTMB being front-ends of TMB;
- Most are sampling based or have a path to sampling methods, with the notable exception of INLA;
- Stan & TMB (& variants) can also go down the optimisation path, with or without Laplace approximation;
- By combining TMB & Stan, I think tmbstan, being the odd one out, is very powerful as one can write the model (negative log-likelihood) in TMB, then carry sampling (or even non-sampling) in Stan;
- Still, some quick tests reveal that a custom C++ sampler usually beats everything. But then it really depends on the model.

Overall, I don't think there is a need for another unifying package / language / front-end, as I always remind myself of this [xkcd comic](https://xkcd.com/927/). But a checker tool that helps a user decide what software to use, depending on the model & prior experience, might be useful.

The slides are [here](/slides/reading_group_20261113.pdf).