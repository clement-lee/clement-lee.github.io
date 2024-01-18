---
layout: post
title: Tracked changes workaround doesn't work for arXiv
categories: [LaTeX]
---

A new version of our paper on discrete extremes & power law is available on [arXiv](https://arxiv.org/abs/2008.03073) now. Instead of talking about the content (maybe another post), I would like to document the issue when submitting on arXiv.

I have been using the TeX package [`changes`](https://ctan.org/pkg/changes?lang=en) to track changes made to the paper. For anyone who has not used it before, it doesn't automatically track the changes for you. Instead, you have to manually markup your changes, mainly using three commands: `\added{}`, `\deleted{}` and `\replaced{}`. These commands work well if you have maths within the curly brackets, but not when you have referencing (e.g. `\ref{}`) or citations (e.g. `\cite{}`). This means that the file won't be compiled into a pdf if it contains something like `\added{\cite{johndoe2024}}` or `\deleted{see Section \ref{sect.intro}}`.

There's a workaround on [stackexchange](https://tex.stackexchange.com/questions/380033/conflict-with-cite-and-changes), which is to wrap these instances with `mbox{}`. Using the above examples, `\added{\mbox{\cite{johndoe2024}}}` and `\deleted{see Section \mbox{\ref{sect.intro}}}` should work; it did on various local machines. However, for unknown reasons that I didn't bother to find out, it doesn't work on arXiv. Eventually I figured it out after some painstaking experiments, which means deleting sections locally, submitting to arXiv and adding the sections back after successful compilation.

The takeaway is that these tracked changes should be manually cleaned before submission, not only to avoid the above issue, but also to prevent the changes from showing (improperly) in the experimental HTML version. Thinking back, I should have thought about that, as I have been [advocating writing materials displayed properly in both pdf & html using RMarkdown](/bookdown).
