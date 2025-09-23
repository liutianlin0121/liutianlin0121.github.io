---
toc: false
layout: post
title: "PhD Reflections"
---

I finished my PhD in November 2024! I’m grateful to everyone who supported me along the way. What follows is not unsolicited advice to anyone, but lessons I learned through my own journey and some patterns I’ve noticed in others. Every PhD path is different, and this is simply mine. 


The single most critical lesson I learned was how to drive my own research. That might sound like the very definition of a PhD. But I was surprised to discover how easy it is to become a passenger in your own project.


Indeed, the alternative pattern is a familiar one. You start the PhD program with broad, youthful interests. Advisors, seasoned and well-meaning, suggest a project. You adopt it, often eagerly, declaring it as your scientific field. There’s a warm sense of security in this; the project is sanctioned, the path laid out. Even if it doesn't quite pan out as hoped, the effort is seen as admirable, and it counts toward graduation. But I think in that comfort lies a quiet risk: one can drift through years of work without ever truly owning your work. Here are a few reflections on why taking the wheel, however unsteadily, feels important to me.

## Independent thinking begets divergence

One of my favorite ways to procrastinate is digging through academic family trees. If you've ever done this too, you'll notice that professors rarely stick to the same research as their own PhD advisors. My advisor, [Ivan](https://dmi.unibas.ch/de/personen/ivan-dokmanic/), works on machine learning for science. His advisor, [Martin](https://people.epfl.ch/martin.vetterli?lang=en), works on signal processing topics like wavelets and information theory. The fields are somewhat related but not the same.

In fact, I’ve come to believe this kind of divergence isn’t the exception but the norm. It’s often how researchers truly make their mark: by drifting away from their origins. PhD students are after all expected to become independent researchers. It stands to reason that we should begin thinking independently during the PhD itself.

For this reason, I found it valuable to regularly ask myself whether my advisor's suggested project truly aligned with my evolving interest—however unsteady it is. Recognizing and then owning that difference is helpful. And if one finds oneself in perfect agreement, it might be worth moments of reflection: Is this a genuine conviction or simply the comfortable deference of a passenger?

## Taste impacts judgment
Even if natural science prizes objectivity, researchers inevitably lean on their past training: topics they’ve seen, studied, and succeeded with. An example that sticks with me is the discussion around ReLU’s success in deep learning. Around 2020, ReLU was the activation function that everybody used, and many sought to explain why. Yoshua Bengio famously suggested that ReLU works because it resembles spiking, biological neurons. Meanwhile, signal processing gurus argued that they could re-derive ReLU based on sparse coding’s seminal ideas; therefore, they claimed, sparsity explains why ReLU works so well.

Interestingly, these arguments focused on opposite sides of the same function—one on the positive axis, the other on the negative. In hindsight, neither explanation fits. Calling an identity function "spiky" is a stretch, and many non-sparse activations (Leaky ReLU, GeLU) work just as well, if not better.
What happened here is that each camp saw what its training prepared it to see. Sometimes that lens becomes so strong it blocks other views. Max Planck made the famously grim observation: *“A new scientific truth does not triumph by convincing its opponents and making them see the light, but rather because its opponents eventually die and a new generation grows up that is familiar with it…”*

The realization for me was that even brilliant researchers filter ideas through their past. They couldn't easily unsee what they had already seen. This realization was actually freeing. It allowed me to empathize with them while also feeling empowered to challenge their perspectives with my own judgment.

## Incentives steer unevenly

Students and professors face different incentives and timelines. To land research-related jobs in either industry or academia, PhD students often need a strong publication record. But for tenured professors, as long as a few papers get published from time to time, their careers generally stay on track. Of course, there’s no grand conspiracy of PhD advisor against PhD students; it’s simply that the incentives of academia are tilted toward those already in secure positions.

This mismatch can introduce two kinds of risk. First, a project might be too ambitious, high-reward, but with a high risk of failure for a fledgling PhD student to recover from. [Shing-Tung Yau](https://en.wikipedia.org/wiki/Shing-Tung_Yau), a Fields Medalist mathematician, tells a striking story in his [autobiography](https://www.goodreads.com/book/show/195820947-the-gravity-of-math). When Yau was a PhD student, his advisor, [Shiing-Shen Chern](https://en.wikipedia.org/wiki/Shiing-Shen_Chern), urged him to prove the Riemann Hypothesis. Yau declined, a decision he was later grateful for.

The second risk is that a project might be defined in a very narrow domain. This might be noble if you are pursuing knowledge for its own sake and you happen to be captivated by this domain. But I wanted my work to be useful to others, and a niche topic meant that few people would care about my work. Similar to an efficient market, the most impactful research is often not in the niche areas, as otherwise, those areas would quickly attract more researchers and cease to be niche. In the preface of his book, Stéphane Mallat compared the scientific community to a school of fish: *“I cannot help but find striking resemblances between scientific communities and schools of fish. [...] Some of us like to be at the center of the school, others prefer to wander around, and a few swim in multiple directions in front. To avoid dying by starvation in a progressively narrower and specialized domain, a scientific community also needs to move on.”* It falls to the student to judge whether their project is leading them toward open water or a stagnant pond.

## My Own Experience

So, how does one take the wheel? As I see it, there are two main ways. The first is to find a project that genuinely excites you and also aligns with your advisor’s expertise, and then frame it to gain their support—a strategy Philip Guo has called ['leading from below'](https://cacm.acm.org/blogcacm/the-ph-d-grind-lead-from-below/). 

Leading from below was not my strong suit. During my PhD, I pitched quite a few project ideas to Ivan on topics like meta-learning deep image priors, graph mixture of experts, bi-stochastic attention for graph neural networks, and spherical neural operators. I was usually met with a politely lukewarm response and a gentle nudge toward working on something else. Later, I observed published work that independently proposed similar ideas, and they result to a mixed feeling. It suggested my ideas were indeed publishable, but it also confirmed they were somewhat incremental—the kind of unsurprising extensions many would arrive at in a short period of time. In the end, all the core work in my thesis stemmed from Ivan’s original suggestions. The work that goes into my PhD thesis, much like many others’, was ultimately more of a top-down prescription than a bottom-up initiative.

The second path, which I eventually took, is a dual-track approach: I worked on my advisor’s suggested projects as the primary focus, while setting aside some time to pursue my own research interests. This strategy offered the best of both worlds. The professor-approved projects provided a safety net for graduation and were a good way to improve research skills. Meanwhile, the side projects gave me the freedom to explore, build a unique profile, and develop work that was outside of my advisor’s immediate interest.
For me, an effective way to find side projects is through open-source contributions. Many machine learning directions have communities around their open-source implementations. For language modeling, an example is Hugging Face’s extremely active [Transformers](https://github.com/huggingface/transformers) repository, which has a wide range of open issues and feature requests waiting to be tackled. Reading the source code of a project that excites you and engaging with discussions with the contributors can be a great launchpad for a new project. Personally, I started a side project just like this. At the time, I wanted to work on language models and admired Costa Huang’s work reproducing OpenAI's research when I came across his [GitHub repository](https://github.com/vwxyzjn/lm-human-preference-details). I reached out with questions, which turned into a collaboration. We fully reproduced OpenAI’s results in PyTorch and JAX, sharing our work in a [blog post](https://openreview.net/forum?id=CPFCkB2OGt) and a [benchmark paper](https://arxiv.org/abs/2402.03046). Through similar efforts, I also made some minor contributions to the main [Transformers](https://github.com/huggingface/transformers) repository and the [TRL](https://github.com/huggingface/trl) repository.

Internships were another outlet. Thanks to Ivan’s support, I interned at Google twice. Proactively seeking out internships during my PhD turned out to be a truly worthwhile decision for me. There were challenges like preparing for technical interviews, getting work visas, and finishing projects within tight time horizons. However, those internships provided invaluable opportunities to make connections and contribute to publications beyond the band of my PhD.


## Final Thought

The great promise of a PhD is intellectual freedom. But I learned its most common pitfall is surrendering your agency. It’s tempting to follow a set path that leads to a degree, but the real reward comes from taking the wheel oneself. 


