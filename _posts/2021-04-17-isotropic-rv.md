---
toc: false
layout: post
title: Are coordinates of an isotropic random vector uncorrelated?
---
I was reading Section 3.3 of the nicely written book [High-dimensional Probability](https://www.math.uci.edu/~rvershyn/papers/HDP-book/HDP-book.pdf) by Roman Vershynin. At the beginning of that section, it was mentioned that:

> The coordinates of an isotropic random vector are always uncorrelated (why?), but they are not necessarily independent.

In the above statement, the "not necessarily independent" part is evident from the example of spherically distributed random variables. However, I had a hard time verifying the "always uncorrelated" statement. After some thoughts, I think this statement is actually wrong: The coordinates of an isotropic random vector can be correlated.


To show coordinates of a generic isotropic random vector can be correlated, we need to find an isotropic random variable $$X$$ such that 

$$
\begin{equation}
\mathbb{E}(X_i X_j) \neq  \mathbb{E}(X_i) \mathbb{E}(X_j).
\end{equation}
$$

This can be achieved by considering a *coordinate random variable* $$X$$ uniformly distributed in the set $$\lbrace \sqrt{n} e_i \rbrace_{i=1}^n$$, where $$\lbrace e_i\rbrace_{i=1}^n$$ is the canonical basis of $$\mathbb{R}^n$$:


$$
\begin{equation}
X \sim \mathrm{Unif} \lbrace \sqrt{n} e_i : i = 1, \ldots, n \rbrace. 
\end{equation}
$$

As shown in Section 3.3.4 of the book by Roman Vershynin, this random $$X$$ is isotropic. That is,

$$
\begin{equation}
\mathbb{E} (X_i X_j) =  0,  \quad \forall i \neq j.
\end{equation}
$$


Additionally, each component of $$X$$ can only take non-negative values. This implies that $$\mathbb{E} (X_i) \neq  0$$ for all $$i = 1, \ldots, n$$. As a result, there holds

$$
\begin{equation}
\mathbb{E} (X_i) \mathbb{E} (X_j) \neq  0, \quad \forall i,j = 1, \ldots, n.
\end{equation}
$$


Hence we have $$\mathbb{E}(X_i X_j) \neq  \mathbb{E}(X_i) \mathbb{E}(X_j)$$. That is, the random variable $$X$$ is isotropic yet it has correlated coordinates.

**Acknowledgement:** My Ph.D. advisor [Ivan](https://dmi.unibas.ch/de/personen/ivan-dokmanic/) helped me come up with the above counter-example.





