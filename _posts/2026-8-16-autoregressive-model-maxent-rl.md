---
toc: false
layout: post
title: Language models as Maximum-Entropy Policies
summary: "A summary of the connection between autoregressive language models and maximum-entropy reinforcement learning."
---

My collaborators and I published a paper on the connection between autoregressive models and energy-based models {% citep blondel2026autoregressive %}. Among other interesting findings, we formulate autoregressive language models through the Maximum-Entropy Reinforcement Learning (MaxEnt RL) framework, which is quite neat. Below is a succinct summary of this formulation.

**Language models as MDPs.** We treat a language model as a MDP with the state space as the token histories and the action space as the vocabulary. The transition dynamics are deterministic: given a state $s_t$ and action $a_t$, the next state is the concatenation 
$$
s_{t+1} = s_t \oplus a_t.
$$

**Next-token probs as the MaxEnt optimal policy.** Given a model outputting next token probabilities $\pi^\ast(\cdot|s)$ for each state $s$, we interpret $\pi^\ast$ as the optimal policy that maximizes the expected return plus an entropy bonus:
$$
\begin{equation} \label{eq:expected-return}
    \pi^\ast = \operatorname*{argmax}_{\pi} \mathbb{E}_{\tau \sim \pi} \left[ \sum_{t=0}^{L-1} r(s_t, a_t) + H(\pi(\cdot|s_t)) \right].
\end{equation}
$$
As is common in language modeling, we assume a finite horizon $L$ (context length) and no discounting.

**Logits as the optimal action values.** The optimal value function $V^*(s)$ for the objective in $\eqref{eq:expected-return}$ satisfies the soft Bellman optimality equation:
$$
\begin{equation} \label{eq:bellman-max}
    V^*(s_t) \coloneqq \max_{\pi(\cdot|s_t)} \mathbb{E}_{a_t \sim \pi(\cdot|s_t)} \Big[ r(s_t, a_t) + V^*(s_{t+1}) - \log \pi(a_t|s_t) \Big].
\end{equation}
$$

Let $Q^\ast(s_t, a_t) \coloneqq r(s_t, a_t) + V^*(s_{t+1})$ be the optimal action values. Solving the maximization on the RHS of $\eqref{eq:bellman-max}$ gives 
$$
\begin{equation} \label{eq:optimal-policy}
    \pi^*(a|s_t) = \frac{\exp(Q^\ast(s_t, a))}{Z_t} = \operatorname{softmax}(Q^\ast(s_t, \cdot))[a],
\end{equation}
$$
where $Z_t \coloneqq \sum_{a'} \exp(Q^\ast(s_t, a'))$ is the partition function. Therefore, the unnormalized logits of the LM can be identified with the optimal action values $Q^*(s_t, \cdot)$ up to an additive state-dependent constant.

**LSE of the logits as state values.** Plugging the optimal policy $\pi^*$ back into the objective in $\eqref{eq:bellman-max}$, we recover the value of the state $V^*(s_t)$.
Recall that $\log \pi^*(a|s_t) = Q^*(s_t, a) - \log Z_t$. We have
$$
\begin{align}
    V^*(s_t) &= \mathbb{E}_{a_t \sim \pi^\ast(\cdot|s_t)} \Big[ Q^*(s_t, a_t) - \log \pi^*(a_t|s_t) \Big] \\
    &= \mathbb{E}_{a_t \sim \pi^\ast(\cdot|s_t)} \Big[ Q^*(s_t, a_t) - \big( Q^*(s_t, a_t) - \log Z_t \big) \Big] \\
    &= \mathbb{E}_{a_t \sim \pi^\ast(\cdot|s_t)} \Big[ \log Z_t \Big] \\
    &= \log Z_t \\
    &= \operatorname{LSE}_{a' \in \mathcal{A}} Q^*(s_t, a').
\end{align}
$$
Therefore, the LSE of the action values (or logits) corresponds to the optimal state value $V^*(s_t)$ under this natural normalization.

**Implicit reward of LM.** By the definition of $Q^\ast(s_t, a_t) \coloneqq r(s_t, a_t) + V^*(s_{t+1})$, the underlying step-wise reward $r$ must satisfy the following consistency condition for non-terminal steps $t < L-1$:
$$
\begin{align} \label{eq:implicit-reward}
    r(s_t, a_t) &= Q^\ast(s_t, a_t) - V^\ast(s_{t+1}) \\
     &= Q^\ast(s_t, a_t) - \operatorname{LSE}_{a' \in \mathcal{A}} Q^*(s_{t+1}, a').
\end{align}
$$
For the terminal step $t = L-1$, $V^*(s_L)$ represents the terminal reward of the complete sequence.

## References

{% bibliography --cited %}