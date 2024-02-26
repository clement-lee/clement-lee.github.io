---
layout: post
title: From the power law to extreme value mixture distributions
categories: [Extremes, Network Degrees, Power Law]
---

[This](/slides/2024-02-27-extremes-reading-group.pdf) is the presentation I made for our paper on discrete extremes & power law is available on [arXiv](https://arxiv.org/abs/2008.03073).

The idea is straightforward. The discrete power law (aka the Zipf distribution) is useful to describe degree distribution of networks. Suggesting that the data follows the power law usually stems from the seemingly (or partial) linearity of empirical log-log plot. However, the Zipf distribution alone has been shown to be inadequate for the whole of the data, and there have been proposals on how to determine the portion of the data that follows the power law. On the other hand, [Valero et al. (2022)](https://www.sciencedirect.com/science/article/pii/S037843712200454X) proposed the Zipf-polylog (ZP) distribution as a generalisation that accommodates the concavity of the log-log plot seen in some of these data. 

We assert that the ZP distribution is a useful starting point but still inadequate, especially for the right tail. Instead, we truncate the ZP right tail and replace it by the integer generalised Pareto (IGP) distribution, which substantially improves the fit. Simultaneously, we perform model selection to determine whether the part fitted by the (truncated) ZP indeed follows the power law. What we have found is that the partial power law for some data would have been overlooked had we fitted the ZP for the whole of the data.

The slides are available in pdf for now. I need to fix a few things so that they look properly in the HTML version.
