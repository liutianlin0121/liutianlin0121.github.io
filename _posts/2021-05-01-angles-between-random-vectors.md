---
toc: false
layout: post
title: The expected angle between two isotropic random vectors
---

In Section 3.2 of the book [High-dimensional Probability](https://www.math.uci.edu/~rvershyn/papers/HDP-book/HDP-book.pdf) by Roman Vershynin, it was mentioned in the caption to Figure 3.4 that

> Independent isotropic random vectors tend to be almost
orthogonal in high dimensions but not in low dimensions. On the plane, the
average angle is $$\pi/4$$, while in high dimensions it is close to $$\pi/2$$.

and later in the text that 

>For example, the angle between two random independent and uniformly distributed
directions on the plane has mean $$\pi/4$$.

Here, the number $$\pi/4$$ is curious as it implies that two independent isotropic random vectors in a two-dimensional plane are not orthogonal to each other on average. 

When I tried to do the computation myself, however, I couldn't get the number $$\pi/4$$. I believe that this is a typo in the book. The correct number should be $$\pi/2$$. As a consequence, two independent isotropic random vectors are orthogonal to each other, in a two-dimensional plane as well as in higher dimensional spaces. 


## Numerical demonstration

In this post, we first numerically verify the claim. The idea is straightforward: We first produce a large amount of i.i.d. two-dimensional Gaussian vectors in pairs. We next compute the angles between each pair. Finally, we do the average across pairs. We plot the average angles as the number of sampled pairs increases. This procedure is implemented with the following python script.


```python
import numpy as np
import math
import matplotlib.pyplot as plt
from matplotlib.ticker import FormatStrFormatter, MultipleLocator

def angle(v1, v2):
    return math.acos(np.dot(v1, v2) / (np.linalg.norm(v1) * np.linalg.norm(v2)))

dim = 2

num_realizations = 100000
np.random.seed(1)

angles = []
for i in range(num_realizations):
    # realizations of two Gaussian random vectors
    v1 = np.random.normal( size= dim)
    v2 = np.random.normal( size= dim)

    # angles between two vectors
    angles.append(angle(v1, v2))
    
angles = np.array(angles)

# the average of angles with different number of realizations.
averages = [angles[:i].mean() for i in range(1, len(angles))]
averages = np.array(averages)

# plot averaged angles vs number of realizations
fig, ax = plt.subplots(1, 1, figsize=(6, 6/1.618), constrained_layout=True)
ax.yaxis.set_major_formatter(FormatStrFormatter('%g $\pi$'))

ax.plot(averages / math.pi, linewidth = 2, label = 'averaged angle', color = '#636363')
ax.axhline(y=1/2, color='r', linestyle=':', linewidth = 3)


ax.set_xlabel('Number of realizations')
ax.set_ylabel('Radian angle')
ax.set_xscale('log')
ax.legend(loc = 4)

ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)

ax.set_title('Dim = 2')
plt.grid()
```
As we see in the resulting figure below, the averaged angle indeed concentrates around $$\pi/2$$ and not $$\pi/4$$.

![]({{site.baseurl }}/assets/image/average_angle_dim2.png){:width="700px"}

Via a slight modification of the above program, we can compute the angles when the Gaussian vectors are high-dimensional; in the figure below, we set the dimension to be 10.

![]({{site.baseurl }}/assets/image/average_angle_dim10.png){:width="700px"}


## Analytical computation

It is not difficult to prove thefact that two independent isotropic random vectors in a two-dimensional plane have expected angle $$\pi/2.$$ To show this, let $$X$$ and $$Y$$ be two such random vectors. We aim to show 

$$
\begin{equation}
\mathbb{E} \big ( \mathrm{angle}(X, Y) \big )  = \pi/2,
\end{equation}
$$ 

where $$\mathrm{angle}(\cdot, \cdot)$$ is the function that measures the angle between two vectors. 

By the law of total expectation, we have

$$
\begin{equation}
\mathbb{E} \big ( \mathrm{angle}(X, Y) \big )  = \mathbb{E}  \left [ \mathbb{E}  \big ( \mathrm{angle}(X, Y) \mid Y \big   ) \right ].
\end{equation}
$$

Note that the random variable $$\mathbb{E}  \big ( \mathrm{angle}(X, Y) \mid Y \big  )$$ is a constant random variable: For any fixed realization of $$Y$$, the conditional expectation of $$\mathrm{angle}(X, Y) $$ is simply $$\pi/2$$ since $$X$$ has uniformly distributed directions.  For this reason, we have $$\mathbb{E} \big ( \mathrm{angle}(X, Y) \big )  = \pi/2,$$ which is what we claimed.














