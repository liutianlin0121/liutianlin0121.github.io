---
toc: false
layout: post
title: A detailed derivation of the diffusion map
summary: "A step-by-step derivation of diffusion maps for non-linear dimensionality reduction."
---

The diffusion map {% citep coifman2006 %} is an extensively used dimensionality reduction technique. It represents high-dimensional data points using an underlying graph, which non-linearly encodes the geometrical similarities between data points. Despite its popularity, few tutorials introduce the diffusion map in precision that I find satisfying. This blog delves deep into the derivation.


To formalize, we let $\mathcal{X} \coloneqq \{ \boldsymbol{x}_1, \ldots, \boldsymbol{x}_m\} \subset \mathbb{R}^N$ be a given set of high-dimensional data. In this note, we will construct the diffusion maps

$$
\begin{equation*}
\begin{split} 
  \Phi^n:  \mathcal{X} & \to \mathbb{R}^{n} \\
  \boldsymbol{x} & \mapsto \Phi(\boldsymbol{x}),
\end{split}
\end{equation*}
$$

where $n \leq \min(m - 1, N)$. Specifically, to construct the diffusion maps $\Phi^n$, we take three steps:
1. View the high-dimensional points in $\mathcal{X}$ as vertices in an underlying graph (Section [1](#graph-representation) ).
2. Define a Markov Chain (MC) on the graph, so that local connectivity between vertices of the graph has a probability interpretation (Section [2](#mc) ).
3. Assign each data point in $\mathcal{X}$ a low-dimensional vector, with respect to which the graph-based local connectivity is approximately preserved (Section [3](#dim-reduction)).


## <a name="graph-representation"></a> 1. Graph representation of data points

To start the diffusion maps machinery, we first describe each high-dimensional data point $\boldsymbol{x}_i \in \mathbb{R}^{N}$ by its relationship with other data points in the given dataset $\mathcal{X} \coloneqq \{\boldsymbol{x}_1, \ldots, \boldsymbol{x}_m\}$. To this end, we assume that each data point $\boldsymbol{x}_i$ is emitted from a vertex $v_i$ of an underlying directed weighted graph $G = (V, E, \boldsymbol{W})$.  Here, $V \coloneqq \{v_1, \ldots, v_m\}$ is the set of vertices, $E \subset V \times V$ is a set of ordered pairs of vertices representing edges, and $\boldsymbol{W}$ is the adjacency matrix such that $\boldsymbol{W}_{ij} > 0$ if $(i,j) \in E$ and $\boldsymbol{W}_{ij} = 0$ otherwise. 


One advantage of having an underlying graph representation of data is that the similarities of high-dimensional points $\boldsymbol{x}_i$ and $\boldsymbol{x}_j$ can be encapsulated by $\boldsymbol{W}_{ij}$, that is, the connection strength or the weight between two vertices $v_i$ and $v_j$. But how to specify these weights? In diffusion maps, we let each connection strength be specified through a kernel function $K$:


$$
\begin{aligned}
K: \mathbb{R}^N \times \mathbb{R}^N & \to \mathbb{R}_{+} \cr
(\boldsymbol{x}_i, \boldsymbol{x}_j) & \mapsto K(\boldsymbol{x}_i, \boldsymbol{x}_j).
\end{aligned}
$$

Note that here we assume that the kernel $K$ only takes positive values. This is a convenient choice as it guarantees the Markov chain to be defined later in to have a unique stationary state. One common choice of the kernel is the radial basis kernel 
$$K(\boldsymbol{x}_i, \boldsymbol{x}_j)=\exp \left(-\frac{\|\boldsymbol{x}_i-\boldsymbol{x}_j\|^{2}}{\epsilon}\right) \text{~with~} \epsilon > 0.$$
In this way, we construct an adjacency matrix with components $\boldsymbol{W}_{ij} \coloneqq K(\boldsymbol{x}_i, \boldsymbol{x}_j)$. The whole adjacency matrix $\boldsymbol{W} \in \mathbb{R}^{m \times m}$ has the form

$$\boldsymbol{W} = \begin{bmatrix} 
    K(\boldsymbol{x}_1, \boldsymbol{x}_1) & \dots & K(\boldsymbol{x}_1, \boldsymbol{x}_m) \\
    \vdots & \ddots &       \vdots \\
    K(\boldsymbol{x}_m, \boldsymbol{x}_1) &  \dots      & K(\boldsymbol{x}_m, \boldsymbol{x}_m)
\end{bmatrix} \in \mathbb{R}^{m \times m}.$$

Another important concept for a graph is the degree matrix. Recall that the degree of a vertex is defined as the sum of the weights of its outgoing edges. The degree matrix is simply a diagonal matrix that collects the degree of each vertex:

$$
\boldsymbol{D} \coloneqq \begin{bmatrix} 
    \sum_{k = 1}^m K( \boldsymbol{x}_1, \boldsymbol{x}_k) & \dots & 0 \\
    \vdots & \ddots &       \vdots \\
    0 &  \dots      & \sum_{k = 1}^m K( \boldsymbol{x}_m, \boldsymbol{x}_k)
\end{bmatrix} \in \mathbb{R}^{m \times m}.
$$


## <a name="mc"></a> 2. Markov chain on the graph

Now, with the weighted graph $G = (V, E, \boldsymbol{W})$ in the previous section, we construct a stochastic process $(X_t)_{t \in \mathbb{N}}$ taking values in the vertices $V$. Specifically, we let the stochastic process to be a time-homogenous Markov Chain, where the transition probability between two vertices is specified via the normalized edge weights attached to these two vertices:

$$
\begin{aligned} 
\forall t \in \mathbb{N}: \quad \mathbb{P}\left(X_{t+1}= v_j \mid X_{t}= v_i \right) = \frac{ K ( \boldsymbol{x}_i, \boldsymbol{x}_j)}{ \sum_{k = 1}^m K( \boldsymbol{x}_i, \boldsymbol{x}_k) } \eqqcolon p(v_i, v_j).
\end{aligned}
$$

We arrange these transition probabilities $p(v_i, v_j)$ into a $N \times N$ sized transition matrix 

$$
\boldsymbol{M} \coloneqq \begin{bmatrix} 
    p(v_1, v_1) & \dots & p(v_1, v_m) \\
    \vdots & \ddots &       \vdots \\
    p(v_m, v_1) &  \dots      & p(v_m, v_m)
\end{bmatrix} \in \mathbb{R}^{m \times m}.
$$

It is easy to verify that $\boldsymbol{M} = \boldsymbol{D}^{-1} \boldsymbol{W}$ and that

$$
\begin{aligned}
\forall t \in \mathbb{N}: \quad \mathbb{P}\left(X_{t}= v_j \mid X_{0} = v_i \right ) = \left( \boldsymbol{M}^{t}\right)_{i j}.
\end{aligned}
$$

Characterizing transition probability with the matrix $\boldsymbol{M}$ is helpful as it allows us to study the MC using tools of linear algebra. For instance, the stationary distribution of the MC $(X_t)_{t \in \mathbb{N}}$ is encoded in a probability vector $\boldsymbol{\pi}$ such that 

$$
\begin{equation} 
\boldsymbol{\pi}^\top \boldsymbol{M} = \boldsymbol{\pi}^\top.    
\end{equation}
$$

The stationary probability vector $\boldsymbol{\pi}$ is thus a left eigenvector of $\boldsymbol{M}$. If we assume $\boldsymbol{l}_1, \ldots, \boldsymbol{l}_m$ are unit norm left eigenvectors of $\boldsymbol{M}$, then $\boldsymbol{\pi} = \boldsymbol{l}_1/ \| \boldsymbol{l}_1\|_1.$ We remark that, by construction, the stationary distribution $\boldsymbol{\pi} = \boldsymbol{l}_1/ \| \boldsymbol{l}_1\|_1$ is unique. This is because we have assumed the kernel $K$ only takes positive values, which is an assumption implying that the markov chain is irreducible. Additionally, via Equation (1), it is straightforward to verify that $\boldsymbol{\pi}$ is explicitly defined through the degree matrix $\boldsymbol{D}$:

$$
\begin{aligned}
\boldsymbol{\pi} = \text{diag}(\boldsymbol{D})/ \text{trace}(\boldsymbol{D}).
\end{aligned}
$$


## <a name="dim-reduction"></a>  3. Dimensionality reduction by preserving diffusion distance 

Based on the MC on the graph, we define a diffusion distance between two vertices:

$$
\begin{equation*} 
d_{t}\left(v_i, v_j\right)^{2} \coloneqq \sum_{k \in [S]}  \Big [ \mathbb{P} (X_{t} = v_k \mid X_0 = v_i) - \mathbb{P} (X_{t} = v_k \mid X_0 = v_j) \Big ]^{2} \Big/ \boldsymbol{\pi}[k].
\end{equation*} 
$$

Intuitively, this diffusion distance $d_{t}$ measures the local connectivity between two vertices at a timescale prescribed by $t$.
Writing the conditional probabilities in terms of the entries of the transition matrix $\boldsymbol{M}$, we discover

$$
\begin{equation*} 
d_{t}\left(v_i, v_j\right)^{2} =\sum_{k \in [S]}\Big [ (\boldsymbol{M}^{t})_{ik}-(\boldsymbol{M}^{t})_{jk}\Big ]^{2} \Big/ \boldsymbol{\pi}[k].
\end{equation*}
$$

The above equation is a linear algebraic way of computing the distance $d_{t}\left(v_i, v_j\right)^{2}$ of transition probabilities. However, evaluating the term $d_{t}\left(v_i, v_j\right)^{2}$ as above is still inconvenient as it involves the power of a matrix. In what follows, we show that the distance in Equation $d_{t}\left(v_i, v_j\right)^{2}$ can be significantly simplified by using the eigendecomposition of $\boldsymbol{M}$. 

We proceed to write out the right and left eivenvectors of $\boldsymbol{M}$ and examine their relationships. To this end, we first consider a "normalized'' version of $\boldsymbol{M}$, which has the form

$$
\begin{equation*}
\overline{\boldsymbol{M}} \coloneqq \boldsymbol{D}^{\frac{1}{2}} \boldsymbol{M} \boldsymbol{D}^{-\frac{1}{2}} . 
\end{equation*}
$$

One nice property of $\overline{\boldsymbol{M}}$ is that it is positive semidefinite (PSD):

$$
\begin{aligned}
     \forall \boldsymbol{q} \in \mathbb{R}^m, \quad \boldsymbol{q}^\top \overline{\boldsymbol{M}} \boldsymbol{q} & = \boldsymbol{q}^\top \boldsymbol{D}^{\frac{1}{2}} \boldsymbol{M} \boldsymbol{D}^{-\frac{1}{2}} \boldsymbol{q} \cr
     & = \boldsymbol{q}^\top \boldsymbol{D}^{\frac{1}{2}} \boldsymbol{D}^{-1} \boldsymbol{W} \boldsymbol{D}^{-\frac{1}{2}} \boldsymbol{q} \cr
     & = \boldsymbol{q}^\top \boldsymbol{D}^{-\frac{1}{2}} \boldsymbol{W} \boldsymbol{D}^{-\frac{1}{2}} \boldsymbol{q} \cr
     & = (\boldsymbol{D}^{-\frac{1}{2}} \boldsymbol{q})^\top \boldsymbol{W} (\boldsymbol{D}^{-\frac{1}{2}} \boldsymbol{q}) \cr
     & \geq 0,
\end{aligned}
$$

where in the last step we used the fact that the kernel matrix $\boldsymbol{W}$ is PSD. Note that the original, unnormalized matrix $\boldsymbol{M}$ is not PSD because it is not symmetric.

Since $\overline{\boldsymbol{M}}$ is PSD, we may write 
$$
\overline{\boldsymbol{M}} \coloneqq \boldsymbol{U} \boldsymbol{S} \boldsymbol{U}^\top,
$$
where $\boldsymbol{U}$ is an orthonormal matrix whose columns $\boldsymbol{u}_1, \ldots, \boldsymbol{u}_m$ are eigenvectors of $\overline{\boldsymbol{M}}$ and $\boldsymbol{S}$ is a diagonal matrix whose entries are non-negative eigenvalues of $\overline{\boldsymbol{M}}$. As a consequence, we have

$$
\begin{aligned}
{\boldsymbol{M}} & =  \boldsymbol{D}^{-\frac{1}{2}} \overline{\boldsymbol{M}} \boldsymbol{D}^{\frac{1}{2}}\cr
& = \underbrace{\boldsymbol{D}^{-\frac{1}{2}} \boldsymbol{U}}_{\coloneqq \boldsymbol{R}} \boldsymbol{S} \boldsymbol{U}^\top \boldsymbol{D}^{\frac{1}{2}} = \boldsymbol{R} \boldsymbol{S} \boldsymbol{R}^{-1}.
\end{aligned}
$$


By the identity $\boldsymbol{M} = \boldsymbol{R} \boldsymbol{S} \boldsymbol{R}^{-1},$ it is clear that columns of $\boldsymbol{R}$ are right eigenvectors of $\boldsymbol{M}$ and rows of $\boldsymbol{R}^{-1}$ are left eigenvectors of $\boldsymbol{M}.$ For convenience, we write

$$
\boldsymbol{R} = \begin{bmatrix}
    \vert && \vert \\
    \boldsymbol{r}_1 & \vdots & \boldsymbol{r}_m   \\
    \vert & & \vert
\end{bmatrix}
\quad {\text{~and~}} \quad
\boldsymbol{R}^{-1} = 
\begin{bmatrix}
    \text{---} & \boldsymbol{l}_1^\top & \text{---} \\
    & \cdots & \\    
    \text{---} & \boldsymbol{l}_m^ \top & \text{---}
\end{bmatrix}
$$

and use $\boldsymbol{r}_i$ and $\boldsymbol{l}_i$ to denote the $i$-th right and left eigenvectors of $\boldsymbol{M}$ associated to eigenvalue $s_i$. Since $\boldsymbol{R} \coloneqq \boldsymbol{D}^{-\frac{1}{2}} \boldsymbol{U}$ and $\boldsymbol{R}^{-1} = \boldsymbol{U}^\top \boldsymbol{D}^{\frac{1}{2}}$, we see that $\boldsymbol{r}_i$ and $\boldsymbol{l}_i$ are linked through $\boldsymbol{u}_i$:

$$
\begin{equation*}
 \forall i \in [m]: \quad  \boldsymbol{r}_i = \boldsymbol{D}^{- \frac{1}{2}} \boldsymbol{u}_i \quad \text{~and~} \quad \boldsymbol{l}_i = \boldsymbol{D}^{\frac{1}{2}} \boldsymbol{u}_i.
\end{equation*}
$$

Additionally, we note that
$$
\boldsymbol{M}^t = (\boldsymbol{R} \boldsymbol{S} \boldsymbol{R}^{-1})^{t} = \boldsymbol{R} \boldsymbol{S}^t \boldsymbol{R}^{-1}  = \sum_{h=1}^{m} s_{h}^t \boldsymbol{r}_h \boldsymbol{l}_h^\top,
$$
which suggests 
$$
 (\boldsymbol{M}^t)_{ij} = \sum_{h=1}^m s_h^t \boldsymbol{r}_{h}[i] \boldsymbol{l}_{h}[j].
$$

Hence


$$
\begin{aligned}
d_{t}\left(v_i, v_j\right)^{2} &=\sum_{k \in [S]} {\Big [ (\boldsymbol{M}^{t})_{ik}-(\boldsymbol{M}^{t})_{jk}\Big ]^{2}} \Big/ \boldsymbol{\pi}[k] \cr
&=\sum_{k \in [S]} \Big [ \sum_{h=1}^m s_h^t \boldsymbol{r}_{h}[i] \boldsymbol{l}_{h}[k] - \sum_{h=1}^m s_h^t \boldsymbol{r}_{h}[j] \boldsymbol{l}_{h}[k] \Big ]^{2} \Big/ \boldsymbol{\pi}[k] \cr 
&=\sum_{k \in [S]} \Big [ \sum_{h=1}^m s_h^t (\boldsymbol{r}_{h}[i] - \boldsymbol{r}_{h}[j]) \boldsymbol{l}_{h}[k]  \Big ]^{2} \Big/ \boldsymbol{\pi}[k] \cr
&=\sum_{k \in [S]}  \sum_{h=1}^m \sum_{h'= 1}^m \Big ( s_h^t (\boldsymbol{r}_{h}[i] - \boldsymbol{r}_{h}[j]) \boldsymbol{l}_{h}[k] \Big ) \Big ( s_{h'}^t (\boldsymbol{r}_{h'}[i] - \boldsymbol{r}_{h'}[j]) \boldsymbol{l}_{h'}[k] \Big )  \Big/ \boldsymbol{\pi}[k] \cr
&=  \sum_{h=1}^m \sum_{h'= 1}^m \left( s_h^t (\boldsymbol{r}_{h}[i] - \boldsymbol{r}_{h}[j]) \right)  \left( s_{h'}^t (\boldsymbol{r}_{h'}[i] - \boldsymbol{r}_{h'}[j]) \right) \sum_{k \in [S]} \frac{\boldsymbol{l}_{h}[k] \boldsymbol{l}_{h'}[k]}{\boldsymbol{\pi}[k]}.
\end{aligned}
$$

As remarked in the second section, there is an explicit expression for the stationary distribution over vertices: $\boldsymbol{\pi}[k] = \frac{\boldsymbol{D}[k,k]}{\text{trace}(\boldsymbol{D})}$. Plug this expression into the above equation, we get

$$
\begin{aligned} 
    \frac{\boldsymbol{l}_{h}[k] \boldsymbol{l}_{h'}[k]}{\boldsymbol{\pi}[k]} & = \frac{ \text{trace}(\boldsymbol{D}) \cdot \boldsymbol{l}_{h}[k] \cdot \boldsymbol{l}_{h'}[k]}{ \boldsymbol{D}[k, k]} \cr
    & = \frac{ \text{trace}(\boldsymbol{D}) \cdot \left (\boldsymbol{D}^{\frac{1}{2}} \boldsymbol{u}_{h} \right )[k] \cdot \boldsymbol{l}_{h'}[k]}{ \boldsymbol{D}[k, k]} \cr
    & =  \text{trace}(\boldsymbol{D}) \cdot \left (\boldsymbol{D}^{- \frac{1}{2}} \boldsymbol{u}_{h} \right )[k] \cdot \boldsymbol{l}_{h'}[k] \cr
    & =  \text{trace}(\boldsymbol{D}) \cdot \boldsymbol{r}_{h}[k] \cdot \boldsymbol{l}_{h'}[k] \cr
    & =   \begin{cases}
   0  & \text{if } h \neq h', \cr
   \text{trace}(\boldsymbol{D})        
   & \text{otherwise}.
  \end{cases}
\end{aligned}
$$

As a result, we have

$$
\begin{aligned}
d_{t}(v_i, v_j)^{2} & = \text{trace}(\boldsymbol{D}) \sum_{h=1}^m  s_h^{2t} (\boldsymbol{r}_{h}[i] - \boldsymbol{r}_{h}[j])^2 \\
& = \text{trace}(\boldsymbol{D}) \sum_{h=2}^m  s_h^{2t} (\boldsymbol{r}_{h}[i] - \boldsymbol{r}_{h}[j])^2 \\
& \propto \sum_{h=2}^m  s_h^{2t} (\boldsymbol{r}_{h}[i] - \boldsymbol{r}_{h}[j])^2
\end{aligned}
$$

where in second last step we used the fact that $\boldsymbol{r}_1$ is a constant eigenvector and therefore the entrywise difference  $(\boldsymbol{r}_{1}[i]$ - $\boldsymbol{r}_{1}[j])^2$ vanishes. 


To summarize, we proved:

$$
\begin{equation}
\boxed{\quad d_{t}(v_i, v_j)^{2}  \propto \sum_{h=2}^m  s_h^{2t} (\boldsymbol{r}_{h}[i] - \boldsymbol{r}_{h}[j])^2. \quad }
\end{equation}
$$

Finally, we define the diffusion map with truncated order $n$ as

$$
\begin{equation}
\boxed{
\begin{split}
  \quad \Phi_t^n:  \mathcal{X} & \to \mathbb{R}^{n} \quad \\
  \boldsymbol{x}_i & \mapsto \begin{pmatrix} s_2^{t} \boldsymbol{r}_2[i] \\ s_3^{t} \boldsymbol{r}_3[i] \\ \vdots \\ s_{n+1}^{t} \boldsymbol{r}_{n+1}[i] \end{pmatrix}. \quad
  \end{split}}
\end{equation}
$$


Then through Equation (2), we see that if we choose $n = m -1$, the euclidean distance of the diffusion maps of two vectors $\boldsymbol{x}_i$ and $\boldsymbol{x}_j$ reconstructs the diffusion distance up to a scalar:

$$
\| \Phi_t^{m-1}(\boldsymbol{x}_i) - \Phi_t^{m-1}(\boldsymbol{x}_j) \|_2^2 \propto  d_{t}(v_i, v_j)^{2}.
$$

In the interest to reduce the dimensionality of the data, we may choose $n \ll \min(m-1, N).$


## References

{% bibliography --cited %}
