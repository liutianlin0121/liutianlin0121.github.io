---
toc: false
layout: post
title: Notes on discrete flow matching
summary: "Expanding on the derivations of discrete flow matching."
---

I recently read the discrete flow matching {% citep gat2024discrete %} paper and found it very interesting. However, it is technically dense and frequently draws comparisons to continuous flow matching, a topic I’m not familiar with. Below are my reading notes of {% citet gat2024discrete %}. I've expanded on the derivations and technical details to make the concept of discrete flow matching self-contained, without requiring prior knowledge of the continuous framework.


## Probability path on discrete spaces

Let $\mathcal{V} \coloneqq \{1, \ldots V\}$ be the vocabulary, and let $\mathcal{S} \coloneqq \mathcal{V}^L$ be the set of all possible sequences of length $L$. Let $\{Y_t : t \in [0, 1]\}$ be a continuous-time stochastic process, where each $Y_t$ takes values in the sequence space $S$. We denote the probability mass function (PMF) of the random variable $Y_t$ by $p_{Y_t}(\boldsymbol{y}) \coloneqq \mathbb{P}(Y_t = \boldsymbol{y})$. While the subscript notation $p_{Y_t}$ is heavier than the typical shorthand $p_t$, explicitly tracking random variables is useful, as we will see in coming sections.

We assume that $(Y_t)_t$ is a continuous-time Markov chain: for all states $\boldsymbol{y}, \boldsymbol{z} \in S$, all times $0 \le u < s < t$, and any past state $\boldsymbol{w}$:

$$
p_{Y_t|Y_s, Y_u}(\boldsymbol{z} \mid \boldsymbol{y}, \boldsymbol{w}) = p_{Y_t|Y_s}(\boldsymbol{z} \mid \boldsymbol{y}).
$$

In generative modeling, we parametrize a **probability path** $p_{Y_t}: S \to [0,1]$ connecting a simple initial noise distribution $p_{Y_0}$ to a data distribution $p_{Y_1}$. We achieve this by modeling $\frac{\mathrm{d}}{\mathrm{d}t} p_{Y_t}$, the time evolution of the PMF.

### Probability velocity

To study $\frac{\mathrm{d}}{\mathrm{d}t} p_{Y_t}$, it is convenient to gain intuition with matrix notation. Let $\boldsymbol{p}\_{Y_t} \coloneqq [p\_{Y_t}(\boldsymbol{y})]_{\boldsymbol{y} \in S} \in \mathbb{R}^{1 \times \lvert S \rvert}$ be the row vector of marginal probabilities. One way to describe how $\boldsymbol{p}\_{Y_t}$ evolves over time is through a time-dependent matrix $\boldsymbol{Q}_t \in \mathbb{R}^{\lvert S \rvert \times \lvert S \rvert}$ such that

$$
\frac{\mathrm{d}}{\mathrm{d}t} \boldsymbol{p}_{Y_t} = \boldsymbol{p}_{Y_t} \boldsymbol{Q}_t.
$$

The equation above motivates the definition of **velocity function**, defined below. The velocity is a function $q_t: \mathcal{S} \times \mathcal{S} \to \mathbb{R}$ as the entry-wise specification of $\boldsymbol{Q}_t = [q_t(\boldsymbol{y}, \boldsymbol{z})]\_{\boldsymbol{y}, \boldsymbol{z}}$.

{% begin_def label:velocity Velocity %}
A time-dependent function $q_t: \mathcal{S} \times \mathcal{S} \to \mathbb{R}$ is a <em>velocity function</em> if for all $t$:
<ol>
  <li>$q_t(\boldsymbol{y}, \boldsymbol{z}) \ge 0$ for all $\boldsymbol{y} \neq \boldsymbol{z}$.</li>
  <li>$\sum_{\boldsymbol{z} \in S} q_t(\boldsymbol{y}, \boldsymbol{z}) = 0$ for all $\boldsymbol{y}$.</li>
</ol>
{% end_def %}

{% ref velocity %} extends the standard definition for time-homogeneous Markov chains {% citep norris1998markov %}, where $q = q_t$ is time-independent. The definition implies that the diagonal entries represent the total outflow from a state:

$$
q_t(\boldsymbol{y}, \boldsymbol{y}) = - \sum_{\boldsymbol{z} \neq \boldsymbol{y}} q_t(\boldsymbol{y}, \boldsymbol{z}).
$$

A velocity function preserves probability mass over time, as shown in the proposition below.

{% begin_prop label:mass_conservation Velocity preserves probability distributions %}
Let $q_t$ be a velocity function and $p_0$ be a valid PMF. Let $p_t$ evolve according to:
$$
\frac{\mathrm{d}}{\mathrm{d}t} p_t(\boldsymbol{z}) \coloneqq \sum_{\boldsymbol{y} \in S} p_t(\boldsymbol{y}) q_t(\boldsymbol{y}, \boldsymbol{z}).
$$
Then $p_t$ remains a valid PMF for all $t \ge 0$.
{% end_prop %}

{% begin_proof %}
Summing the equation over $\boldsymbol{z}$ yields
$$
\frac{\mathrm{d}}{\mathrm{d}t} \sum_{\boldsymbol{z} \in S} p_t(\boldsymbol{z}) = \sum_{\boldsymbol{y} \in S} p_t(\boldsymbol{y}) \underbrace{\sum_{\boldsymbol{z} \in S} q_t(\boldsymbol{y}, \boldsymbol{z})}_{=0} = 0.
$$
Since $\sum_{\boldsymbol{z}} p_0(\boldsymbol{z}) = 1$, the sum is conserved.
<br><br>

We now show non-negativity. Since $p_t$ satisfies the differential equation, it is differentiable (hence continuous) in $t$. Suppose $p_t$ is not always non-negative for a sequence $\boldsymbol{z} \in S$. Since $p_0(\boldsymbol{z}) \ge 0$ and $p_t(\boldsymbol{z})$ is continuous, by the intermediate value theorem there exists a first time $s$ such that $p_s(\boldsymbol{z}) = 0$ and $\left. \frac{\mathrm{d}}{\mathrm{d}t} p_t(\boldsymbol{z}) \right|_{t=s} < 0$ for some $\boldsymbol{z}$. At this instant,
$$
\left. \frac{\mathrm{d}}{\mathrm{d}t} p_t(\boldsymbol{z}) \right|_{t=s} = \sum_{\boldsymbol{y} \neq \boldsymbol{z}} p_s(\boldsymbol{y}) q_s(\boldsymbol{y}, \boldsymbol{z}).
$$
Since $s$ is the first exit time, $p_s(\boldsymbol{y}) \ge 0$. By definition, $q_s(\boldsymbol{y}, \boldsymbol{z}) \ge 0$ for $\boldsymbol{y} \neq \boldsymbol{z}$. Thus the derivative must be non-negative, a contradiction.
{% end_proof %}

{% ref mass_conservation %} shows that any velocity function preserves probability mass over time. However, for a *given* path $\{p_{Y_t}\}_t$, it is unclear if the PMFs defined through the master equation are compatible with the given $p\_{Y_t}$ at all time $t$. {% ref generation %} defines such consistency.

{% begin_def label:generation Generation %}
A continuous function $q_t: \mathcal{S} \times \mathcal{S} \to \mathbb{R}$ <em>generates</em> the probability path $p_{Y_t}$ if, for all $\boldsymbol{z} \in S$ and $t \in [0, 1]$,
$$
\frac{\mathrm{d}}{\mathrm{d}t} p_{Y_t}(\boldsymbol{z}) = \sum_{\boldsymbol{y} \in S} p_{Y_t}(\boldsymbol{y}) q_t(\boldsymbol{y}, \boldsymbol{z}).
$$
{% end_def %}

Note that multiple velocity functions can generate the same marginal path. Indeed, the linear system is underdetermined for large state spaces ($\lvert S \rvert$ constraints for $\lvert S \rvert^2$ entries). Below, we see one example of the velocity function that generates $p_{Y_t}$ and is explicitly defined through $p_{Y_t}$.

{% begin_prop label:instantaneous_derivative %}
Let $Y_t$ be a continuous-time Markov Chain. The instantaneous conditional derivative function $u_t: \mathcal{S} \times \mathcal{S} \to \mathbb{R}$, defined as
$$u_t(\boldsymbol{y}, \boldsymbol{z}) \coloneqq \left. \frac{\mathrm{d}}{\mathrm{d}s} p_{Y_s|Y_t}(\boldsymbol{z} \mid \boldsymbol{y}) \right\vert_{s=t},$$
is a velocity function and it generates $p_{Y_t}$.
{% end_prop %}

{% begin_proof %}
For $\boldsymbol{y} \neq \boldsymbol{z}$, $u_t(\boldsymbol{y}, \boldsymbol{z}) = \lim_{h \to 0^+} h^{-1} [p_{Y_{t+h} \mid Y_t}(\boldsymbol{z} \mid \boldsymbol{y}) - 0] \ge 0$.
Summing over $\boldsymbol{z}$,
$$
\sum_{\boldsymbol{z} \in S} u_t(\boldsymbol{y}, \boldsymbol{z}) = \left. \frac{\mathrm{d}}{\mathrm{d}s} \sum_{\boldsymbol{z} \in S} p_{Y_s|Y_t}(\boldsymbol{z} \mid \boldsymbol{y}) \right\vert_{s=t} = \left. \frac{\mathrm{d}}{\mathrm{d}s} (1) \right\vert_{s=t} = 0.
$$
Thus $u_t$ is a velocity function. To show generation, we expand the time derivative:

$$
\begin{aligned}
\frac{\mathrm{d}}{\mathrm{d}t} p_{Y_t}(\boldsymbol{z}) &= \lim_{h \to 0^+} \frac{1}{h} \left[ \sum_{\boldsymbol{y} \in S} p_{Y_t}(\boldsymbol{y}) p_{Y_{t+h} \mid Y_t}(\boldsymbol{z} \mid \boldsymbol{y}) - \sum_{\boldsymbol{y} \in S} p_{Y_t}(\boldsymbol{y}) \mathbb{I}(\boldsymbol{y}=\boldsymbol{z}) \right] \\
&= \sum_{\boldsymbol{y} \in S} p_{Y_t}(\boldsymbol{y}) \left[ \lim_{h \to 0^+} \frac{p_{Y_{t+h}|Y_t}(\boldsymbol{z} \mid \boldsymbol{y}) - p_{Y_t|Y_t}(\boldsymbol{z} \mid \boldsymbol{y})}{h} \right] \\
&= \sum_{\boldsymbol{y} \in S} p_{Y_t}(\boldsymbol{y}) u_t(\boldsymbol{y}, \boldsymbol{z}).
\end{aligned}
$$

{% end_proof %}

### Factorized, per-token velocity

As we will see in a later section, at each time $t$, we would like to parametrize the mapping
$\boldsymbol{y} \mapsto [u\_t(\boldsymbol{y}, \boldsymbol{z})]\_{\boldsymbol{z} \in S}$
through a neural network. However, without imposing any constraints on $u_t$, this parametrization is computationally intractable. Indeed, for a given $\boldsymbol{y} \in S$, the matrix $[u_t(\boldsymbol{y}, \boldsymbol{z})]_{\boldsymbol{z} \in S}$ contains $V^L$ entries, scaling exponentially with the sequence length $L$.

To make the modeling of $u_t$ computationally feasible, we assume transitions occur at most one token at a time. We decompose $u_t$ into local velocity functions $u_t^\ell$, where $\ell$ is a token index in a sequence:

$$
u_t(\boldsymbol{y}, \boldsymbol{z}) =
\begin{cases}
u_t^\ell(\boldsymbol{y}, z^\ell) & \text{if } \boldsymbol{y} \text{ and } \boldsymbol{z} \text{ differ only at position } \ell \\
\sum_{\ell=1}^L u_t^\ell(\boldsymbol{y}, y^\ell) & \text{if } \boldsymbol{y} = \boldsymbol{z} \\
0 & \text{if } \boldsymbol{y} \text{ and } \boldsymbol{z} \text{ differ at more than one position}.
\end{cases}
$$

Note that this implies that
$$
u_t^\ell(\boldsymbol{y}, y^\ell) \coloneqq - \sum_{w \neq y^\ell} u_t^\ell(\boldsymbol{y}, w),
$$
which follows from the fact that $0 = \sum_{\boldsymbol{z} \in S} u_t(\boldsymbol{y}, \boldsymbol{z}) = u_t^\ell(\boldsymbol{y}, y^\ell) + \sum_{w \neq y^\ell} u_t^\ell(\boldsymbol{y}, w).$

The advantage of the factoring a global $u_t$ to a local velocity $u\_t^\ell$ is that it reduces the complexity from exponential to linear in $L$. For each $\boldsymbol{y}$, the mapping
$\boldsymbol{y} \mapsto \Big [[u\_t^1(\boldsymbol{y}, z)]\_{z \in \mathcal{V}}, \ldots, [u\_t^L(\boldsymbol{y}, z)]_{z \in \mathcal{V}} \Big],$
has only $V \cdot L$ values.

But what is the interpretation of each local velocity $u_t^\ell(\boldsymbol{y}, z)$? In the following, we show that the local velocity $u_t^\ell$ is the per-token instantaneous change of probability.

{% begin_prop label:local_velocity %}
The local velocity $u_t^\ell(\boldsymbol{y}, z)$ is the instantaneous rate at which the $\ell$-th token of $\boldsymbol{y}$ transitions from its current value to $z$:
$$u_t^\ell(\boldsymbol{y}, z) = \left. \frac{\mathrm{d}}{\mathrm{d}s} \right\vert_{s=t} p_{Y_s^\ell|Y_t}(z \mid \boldsymbol{y}).$$
{% end_prop %}

{% begin_proof %}
By the definition of the marginal PMF,
$$ p_{Y_s^\ell|Y_t}(z \mid \boldsymbol{y}) = \sum_{\boldsymbol{w} \in S} \underbrace{p_{Y_s|Y_t}(\boldsymbol{w} \mid \boldsymbol{y})}_{\text{seq. transition}} \cdot \underbrace{\mathbb{I}(z=\boldsymbol{w}^\ell)}_{\text{token check}}.$$
<br>
Using the global velocity function $u_t$,
$$
\left. \frac{\mathrm{d}}{\mathrm{d}s} p_{Y_s^\ell|Y_t}(z \mid \boldsymbol{y}) \right\vert_{s=t} = \sum_{\boldsymbol{w} \in S} u_t(\boldsymbol{y}, \boldsymbol{w}) \mathbb{I}(z=\boldsymbol{w}^\ell).
$$
<br>
Note that on the RHS, the term $u_t(\boldsymbol{y}, \boldsymbol{w})$ vanishes unless $\boldsymbol{w}$ differs from $\boldsymbol{y}$ in at most one position.
<br><br>
If $z \neq y^\ell$, the indicator $\mathbb{I}(z=\boldsymbol{w}^\ell)$ requires $\boldsymbol{w}$ to differ from $\boldsymbol{y}$ at index $\ell$. So $u_t(\boldsymbol{y}, \boldsymbol{w})$ is nonzero only if $\boldsymbol{w}$ matches $\boldsymbol{y}$ at all indices except the $\ell$-th index. The sum thus collapses to the single term $u_t^\ell(\boldsymbol{y}, z)$.
<br><br>
If $z = y^\ell$, the RHS becomes:
$$
\begin{aligned}
\sum_{\boldsymbol{w} \in S} u_t(\boldsymbol{y}, \boldsymbol{w}) \mathbb{I}(y^\ell=w^\ell) &= u_t(\boldsymbol{y}, \boldsymbol{y}) + \sum_{j \neq \ell} \sum_{w \neq y^j} u_t^j(\boldsymbol{y}, w) \\
& = -\sum_{j=1}^L \sum_{w \neq y^j} u_t^j(\boldsymbol{y}, w) + \sum_{j \neq \ell} \sum_{w \neq y^j} u_t^j(\boldsymbol{y}, w) \\
& = - \sum_{w \neq y^\ell} u_t^\ell(\boldsymbol{y}, w),
\end{aligned}
$$
which is $u_t^\ell(\boldsymbol{y}, y^\ell)$ by construction.
{% end_proof %}

## Discrete flow matching

The key intuition behind discrete flow matching <span id="citation-gat2024discrete">{% cite gat2024discrete %}</span> is that, to model $p_{Y_t}$, we use as much information as possible from $p_0$ and $p_1$, which we can draw samples from. Let $\pi(\boldsymbol{y}_0, \boldsymbol{y}_1)$ be a joint distribution over noise sequences and data sequences; we typically assume the noise and the data distribution are independent: $\pi(\boldsymbol{y}\_0, \boldsymbol{y}\_1) = p\_{Y_0}(\boldsymbol{y}\_0) p\_{Y_1}(\boldsymbol{y}\_1)$. We define the marginal probability path $p\_{Y_t}$ by marginalizing over these pairs:

$$
p_{Y_t}(\boldsymbol{z}) = \sum_{\boldsymbol{y}_0, \boldsymbol{y}_1 \in S} p_{Y_t}(\boldsymbol{z} \mid \boldsymbol{y}_0, \boldsymbol{y}_1) \pi(\boldsymbol{y}_0, \boldsymbol{y}_1),
$$
where $p_{Y_t}(\boldsymbol{z} \mid \boldsymbol{y}_0, \boldsymbol{y}_1)$ is a conditional probability path. Furthermore, we impose two assumptions:

* **Boundary constraints:**
    $p\_{Y_0}(\cdot \mid \boldsymbol{y}_0, \boldsymbol{y}_1) = \mathbb{I}(\boldsymbol{y}_0 = \cdot)$ and $p\_{Y_1}(\cdot \mid \boldsymbol{y}_0, \boldsymbol{y}_1) = \mathbb{I}(\boldsymbol{y}_1=\cdot)$.
* **Token independence conditioned on endpoints:**
    $$
    p_{Y_t}(\boldsymbol{z} \mid \boldsymbol{y}_0, \boldsymbol{y}_1) = \prod_{\ell=1}^L p_{Y_t}(z^\ell \mid \boldsymbol{y}_0, \boldsymbol{y}_1).
    $$

A simple way to satisfy these constraints is to parametrize the path $p_{Y_t}$ based on convex combination of a noise sequence and a sampled sequence:

$$
\forall \ell \in [L]: \quad p_{Y_t}(z^\ell \mid \boldsymbol{y}_0, \boldsymbol{y}_1) = (1 - \sigma_t) \mathbb{I}(y_0^\ell=z^\ell) + \sigma_t \mathbb{I}(y_1^\ell=z^\ell),
$$

In the following, we first find a velocity function that generates the conditional distribution, and then find a velocity function that generates the marginal distribution.

### Generating the conditional probability path

We verify that the velocity function derived in the standard form generates the convex conditional probability path.

{% begin_prop label:conditional_velocity %}
Let $\sigma_t: [0, 1] \to [0, 1]$ be a differentiable, strictly increasing function with $\sigma_0=0, \sigma_1=1$. The conditional probability path defined by
$$
p_{Y_t^\ell \mid Y_0, Y_1}(z^\ell \mid \boldsymbol{y}_0, \boldsymbol{y}_1) = (1 - \sigma_t) \mathbb{I}(z^\ell = y_0^\ell) + \sigma_t \mathbb{I}(z^\ell = y_1^\ell)
$$
is generated by the velocity function:
$$
u_t^\ell(y^\ell, z^\ell \mid \boldsymbol{y}_0, \boldsymbol{y}_1) = \frac{\dot{\sigma}_t}{1 - \sigma_t} \left[ \mathbb{I}(z^\ell = y_1^\ell) - \mathbb{I}(z^\ell = y^\ell) \right].
$$
{% end_prop %}

{% begin_proof %}
Let $\gamma_t \coloneqq \frac{\dot{\sigma}_t}{1 - \sigma_t}$. Since $\dot{\sigma}_t \ge 0$ and $\sigma_t < 1$ for $t < 1$, we have $\gamma_t \ge 0$.
<br><br>
<em>1. Validity.</em> For $z^\ell \neq y^\ell$, $u_t^\ell(y^\ell, z^\ell \mid \boldsymbol{y}_0, \boldsymbol{y}_1) = \gamma_t \mathbb{I}(z^\ell = y_1^\ell) \ge 0$. Summing over $z^\ell$:
$$
\sum_{z^\ell} u_t^\ell(y^\ell, z^\ell \mid \boldsymbol{y}_0, \boldsymbol{y}_1) = \gamma_t \left[ \sum_{z^\ell} \mathbb{I}(z^\ell = y_1^\ell) - \sum_{z^\ell} \mathbb{I}(z^\ell = y^\ell) \right] = \gamma_t(1 - 1) = 0.
$$
<br>
<em>2. Generation.</em> We verify the definition of generation. The LHS is the time derivative:
$$
\frac{\mathrm{d}}{\mathrm{d}t} p_{Y_t^\ell \mid Y_0, Y_1}(z^\ell \mid \boldsymbol{y}_0, \boldsymbol{y}_1) = \dot{\sigma}_t \left[ \mathbb{I}(z^\ell = y_1^\ell) - \mathbb{I}(z^\ell = y_0^\ell) \right].
$$
The RHS is the expected velocity:
$$
\begin{aligned}
&\sum_{y^\ell} p_{Y_t^\ell \mid Y_0, Y_1}(y^\ell \mid \boldsymbol{y}_0, \boldsymbol{y}_1) u_t^\ell(y^\ell, z^\ell \mid \boldsymbol{y}_0, \boldsymbol{y}_1) \\
&= \sum_{y^\ell} p_{Y_t^\ell \mid Y_0, Y_1}(y^\ell \mid \boldsymbol{y}_0, \boldsymbol{y}_1) \gamma_t \left[ \mathbb{I}(z^\ell = y_1^\ell) - \mathbb{I}(z^\ell = y^\ell) \right] \\
&= \gamma_t \mathbb{I}(z^\ell = y_1^\ell) \underbrace{\sum_{y^\ell} p_{Y_t^\ell \mid Y_0, Y_1}(y^\ell \mid \boldsymbol{y}_0, \boldsymbol{y}_1)}_{1} - \gamma_t \underbrace{\sum_{y^\ell} p_{Y_t^\ell \mid Y_0, Y_1}(y^\ell \mid \boldsymbol{y}_0, \boldsymbol{y}_1) \mathbb{I}(z^\ell = y^\ell)}_{p_{Y_t^\ell \mid Y_0, Y_1}(z^\ell \mid \boldsymbol{y}_0, \boldsymbol{y}_1)} \\
&= \gamma_t \left[ \mathbb{I}(z^\ell = y_1^\ell) - p_{Y_t^\ell \mid Y_0, Y_1}(z^\ell \mid \boldsymbol{y}_0, \boldsymbol{y}_1) \right].
\end{aligned}
$$
Substituting the path definition into the bracket:
$$
\begin{aligned}
\text{RHS} &= \gamma_t \left( \mathbb{I}(z^\ell = y_1^\ell) - \left[ (1 - \sigma_t) \mathbb{I}(z^\ell = y_0^\ell) + \sigma_t \mathbb{I}(z^\ell = y_1^\ell) \right] \right) \\
&= \gamma_t (1 - \sigma_t) \left[ \mathbb{I}(z^\ell = y_1^\ell) - \mathbb{I}(z^\ell = y_0^\ell) \right].
\end{aligned}
$$
Since $\gamma_t (1 - \sigma_t) = \dot{\sigma}_t$, the RHS equals the LHS.
{% end_proof %}

### Generating the marginal probability path

We now relate the conditional velocity functions derived above to the marginal velocity function required to generate the marginal path $p_{Y_t}(\boldsymbol{z})$.

{% begin_prop label:marginal_velocity Marginal Velocity Construction %}
Let $u_t^\ell(\boldsymbol{y}, z^\ell \mid \boldsymbol{y}_0, \boldsymbol{y}_1)$ be a conditional local velocity function generating the conditional probability path. The marginal local velocity function $u_t^\ell(\boldsymbol{y}, z^\ell)$, defined by the posterior expectation:
$$
u_t^\ell(\boldsymbol{y}, z^\ell) \coloneqq \sum_{\boldsymbol{y}_0, \boldsymbol{y}_1} u_t^\ell(\boldsymbol{y}, z^\ell \mid \boldsymbol{y}_0, \boldsymbol{y}_1) p_{Y_0, Y_1 \mid Y_t}(\boldsymbol{y}_0, \boldsymbol{y}_1 \mid \boldsymbol{y}),
$$
generates the marginal probability path $p_{Y_t}(\boldsymbol{z})$.
{% end_prop %}

{% begin_proof %}
We compute the time derivative of the marginal path directly. By linearity of the derivative:
$$
\frac{\mathrm{d}}{\mathrm{d}t} p_{Y_t}(\boldsymbol{z}) = \sum_{\boldsymbol{y}_0, \boldsymbol{y}_1} \left[ \frac{\mathrm{d}}{\mathrm{d}t} p_{Y_t \mid Y_0, Y_1}(\boldsymbol{z} \mid \boldsymbol{y}_0, \boldsymbol{y}_1) \right] \pi(\boldsymbol{y}_0, \boldsymbol{y}_1).
$$
Let $u_t(\boldsymbol{y}, \boldsymbol{z} \mid \boldsymbol{y}_0, \boldsymbol{y}_1)$ be the global conditional velocity. Since it generates the conditional path:
$$
\frac{\mathrm{d}}{\mathrm{d}t} p_{Y_t}(\boldsymbol{z}) = \sum_{\boldsymbol{y}_0, \boldsymbol{y}_1} \left[ \sum_{\boldsymbol{y}} p_{Y_t \mid Y_0, Y_1}(\boldsymbol{y} \mid \boldsymbol{y}_0, \boldsymbol{y}_1) u_t(\boldsymbol{y}, \boldsymbol{z} \mid \boldsymbol{y}_0, \boldsymbol{y}_1) \right] \pi(\boldsymbol{y}_0, \boldsymbol{y}_1).
$$
Using Bayes' rule, the term $p_{Y_t \mid Y_0, Y_1}(\boldsymbol{y} \mid \boldsymbol{y}_0, \boldsymbol{y}_1) \pi(\boldsymbol{y}_0, \boldsymbol{y}_1)$ can be factored as $p_{Y_t}(\boldsymbol{y}) p_{Y_0, Y_1 \mid Y_t}(\boldsymbol{y}_0, \boldsymbol{y}_1 \mid \boldsymbol{y})$.
$$
\begin{aligned}
\frac{\mathrm{d}}{\mathrm{d}t} p_{Y_t}(\boldsymbol{z}) &= \sum_{\boldsymbol{y}} p_{Y_t}(\boldsymbol{y}) \left[ \sum_{\boldsymbol{y}_0, \boldsymbol{y}_1} u_t(\boldsymbol{y}, \boldsymbol{z} \mid \boldsymbol{y}_0, \boldsymbol{y}_1) p_{Y_0, Y_1 \mid Y_t}(\boldsymbol{y}_0, \boldsymbol{y}_1 \mid \boldsymbol{y}) \right] \\
&= \sum_{\boldsymbol{y}} p_{Y_t}(\boldsymbol{y}) u_t(\boldsymbol{y}, \boldsymbol{z}).
\end{aligned}
$$
Thus, the marginal global velocity $u_t(\boldsymbol{y}, \boldsymbol{z})$ is the expectation of the conditional global velocity. By linearity, this relationship holds element-wise for the local velocity functions.
{% end_proof %}

Applying {% ref marginal_velocity %} to the conditional velocity function derived earlier, we obtain the explicit form of the marginal velocity function for the convex path:

$$
\begin{aligned}
u_t^\ell(\boldsymbol{y}, z^\ell) &= \sum_{\boldsymbol{y}_0, \boldsymbol{y}_1} \frac{\dot{\sigma}_t}{1 - \sigma_t} \left[ \mathbb{I}(z^\ell = y_1^\ell) - \mathbb{I}(z^\ell = y^\ell) \right] p_{Y_0, Y_1 \mid Y_t}(\boldsymbol{y}_0, \boldsymbol{y}_1 \mid \boldsymbol{y}) \\
&= \frac{\dot{\sigma}_t}{1 - \sigma_t} \left[ \sum_{\boldsymbol{y}_0, \boldsymbol{y}_1} \mathbb{I}(z^\ell = y_1^\ell) p_{Y_0, Y_1 \mid Y_t}(\boldsymbol{y}_0, \boldsymbol{y}_1 \mid \boldsymbol{y}) - \mathbb{I}(z^\ell = y^\ell) \underbrace{\sum_{\boldsymbol{y}_0, \boldsymbol{y}_1} p_{Y_0, Y_1 \mid Y_t}(\boldsymbol{y}_0, \boldsymbol{y}_1 \mid \boldsymbol{y})}_{1} \right] \\
&= \frac{\dot{\sigma}_t}{1 - \sigma_t} \left[ p_{Y_1^\ell \mid Y_t}(z^\ell \mid \boldsymbol{y}) - \mathbb{I}(z^\ell = y^\ell) \right].
\end{aligned}
$$

Here, the term $p_{Y_1^\ell \mid Y_t}(z^\ell \mid \boldsymbol{y})$ corresponds to the probability denoiser. It is the probability that the true data token at position $\ell$ is $z^\ell$, given the current noisy sequence $\boldsymbol{y}$.

## Machine Learning Takeaway

The final equation above shows that the marginal velocity is entirely determined by the *conditional probability of the clean data* given the noisy state, $p_{Y_1^\ell \mid Y_t}(z^\ell \mid \boldsymbol{y})$. This allows a simple recipe for training generative models through learning a denoising neural network.

### Add noise to sequence

Let $M_t$ be a Bernoulli random variable that indicates noise, with $\mathbb{P}(M_t^l=1)=\sigma_t$ for all $l \in \{0, \ldots, L\}$. We let $Y_t$ be the random variable taking values in partially corrupted sequences:

$$
Y_t^l = (1 - M_t^l) \circ Y_0 + M_t^l \circ Y_1,
$$
for all $l \in \{0, \ldots, L\}$.

### Parametrization

We introduce a transformer $p_\theta$ defined as:

$$
\begin{aligned}
    p_\theta \colon & \mathcal{S} \times [0,1] && \to \mathbb{R}^{V \times L} \\
                    & (\boldsymbol{y}, t)            && \mapsto p_{\theta}(\boldsymbol{y}, t)
\end{aligned}
$$

which takes a noisy sequence $\boldsymbol{y}$ and a time $t$ as input, and outputs a categorical distribution over the vocabulary $\mathcal{V}$ for each position.

The training objective of the denoising network is to minimize the negative log-likelihood of the clean token $Y_1^\ell \in \mathcal{V}$ given the noisy input $\boldsymbol{y}_t \in S$ at the time $t$:

$$
\mathcal{L}(\theta) = \mathbb{E}_{t, Y_0, Y_1, Y_t} \left[ - \sum_{\ell=1}^L \log \Big(p_\theta(Y_t, t)\Big)[\ell, Y_1^\ell] \right].
$$

Once trained, we can compute the estimated velocity field $\hat{u}_t^\ell$ required for generation by simply plugging the network output into the velocity equation:

$$
\hat{u}_t^\ell(\boldsymbol{y}, z) = \frac{\dot{\sigma}_t}{1 - \sigma_t} \left[ p_\theta(\boldsymbol{y}, t)[\ell, {z}] - \mathbb{I}(z = y^\ell) \right].
$$

### Training

The training process utilizes the concept of *simulation-free* training (or flow matching). Instead of simulating a trajectory to find the loss, we sample the probability path directly.

1.  **Sample Data:** Draw a clean sequence $\boldsymbol{y}\_1 \sim p\_{\text{data}}$ and a noise sequence $\boldsymbol{y}\_0 \sim p\_{\text{noise}}$ (e.g., uniform random tokens).
2.  **Sample Time:** Draw a time step $t \sim \text{Uniform}([0, 1])$.
3.  **Corrupt (Interpolate):** Construct a noisy sample $\boldsymbol{y}_t$ using the convex conditional path. For every position $\ell$, we sample $Y_t^\ell$ independently:

    $$
    y_t^\ell = 
    \begin{cases} 
    y_1^\ell & \text{with probability } \sigma_t \\
    y_0^\ell & \text{with probability } 1 - \sigma_t
    \end{cases}
    $$

    This is equivalent to noise injection where the noise level is determined by $t$.
4.  **Optimize:** Minimize the loss function $\mathcal{L}(\theta)$.

By minimizing this loss, $p_\theta$ approximates the posterior mean $p_{Y_1 \mid Y_t}$. This learned denoiser is then used in the Euler Sampling scheme described in the next section to generate new data from pure noise.

### Sampling

Suppose we trained the denoising model $p_{\theta}$, how do we use it for sampling? Recall

$$
u_t^\ell(\boldsymbol{y}, z) = \left. \frac{\mathrm{d}}{\mathrm{d}s} p_{Y_s^\ell|Y_t}(z \mid \boldsymbol{y}) \right\vert_{s=t} = \lim_{h \to 0^{+}} \frac{p_{Y_{t+h}^\ell|Y_t}(z \mid \boldsymbol{y}) - p_{Y_t^\ell|Y_t}(z \mid \boldsymbol{y})}{h}
$$

In Euler discretizations, we choose $N_{\mathrm{step}}$ such that $h = 1/N_{\mathrm{step}}$ is small:

$$
\begin{aligned}
p_{Y_{t+h}^\ell|Y_t}(z \mid \boldsymbol{y}) & \approx \mathbb{I}(z=y^\ell) + h u_t^\ell(\boldsymbol{y}, z) \\
& = \mathbb{I}(z = y^\ell) + h \frac{\dot{\sigma}_t}{1 - \sigma_t} \left[ p_{Y_1^\ell \mid Y_t}(z \mid \boldsymbol{y}) - \mathbb{I}(z = y^\ell) \right] \\
& = \underbrace{\Big(1 - h \frac{\dot{\sigma}_t}{1 - \sigma_t}\Big)}_{=1-\alpha_t}\mathbb{I}(z = y^\ell) + \underbrace{\Big(h \frac{\dot{\sigma}_t}{1 - \sigma_t}\Big)}_{\coloneqq \alpha_t}p_{Y_1^\ell \mid Y_t}(z \mid \boldsymbol{y}) \\
& \approx (1-\alpha_t)\mathbb{I}(z = y^\ell) + \alpha_t \, p_{\boldsymbol{\theta}}(\boldsymbol{y})[\ell,z]
\end{aligned}
$$

The following is the sampling procedure. Note that $N_{\mathrm{step}}$ is large enough such that the update probability $\alpha_t \in [0, 1]$ for all $t$.

1.  **Initialize:** Sample an initial noise sequence $\boldsymbol{y}\_0 \sim p\_{Y_0}$ (e.g., uniform random tokens). Define a step size $h = 1/N_{\mathrm{step}}$.
2.  **Iterate:** For each step $i = 0, \dots, N_{\mathrm{step}}-1$:
    -  Set time $t = i \cdot h$.
    -  Compute the update probability $\alpha_t \coloneqq h \cdot \frac{\dot{\sigma}_t}{1 - \sigma_t} \in \mathbb{R}$.
    -  Compute denoiser probabilities: $\widehat{\boldsymbol{p}} = p_\theta(\boldsymbol{y}_t, t) \in \mathbb{R}^{V \times L}$.
    -  For each position $\ell = 1, \dots, L$, sample a Bernoulli variable $b^\ell \sim \text{Bern}(\alpha_t)$.
    -  Update token $\ell$ based on $b^\ell$:

        $$
        y_{t+h}^\ell \leftarrow \begin{cases}
        z \sim \textrm{Categorical}\Big(\widehat{\boldsymbol{p}}[:, \ell] \Big) & \text{if } b^\ell = 1 \text{ (update)} \\
        y_t^\ell & \text{if } b^\ell = 0 \text{ (keep)} 
        \end{cases}
        $$
    -  Set $\boldsymbol{y}\_{t+h} \leftarrow (y_{t+h}^1, \dots, y\_{t+h}^L)$.
3.  **Return:** The final sequence $\boldsymbol{y}_1$.

## References

{% bibliography --cited %}