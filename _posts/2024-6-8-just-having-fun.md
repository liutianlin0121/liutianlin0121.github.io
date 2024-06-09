---
toc: false
layout: post
title: "Reading 'Just for Fun: The Story of an Accidental Revolutionary' "
---


Earlier this year, I came across a fiery code review from Linus Torvalds, the creator of Linux, addressed to a kernel contributor. The original email is available on the Linux mailing list [here](https://lkml.iu.edu/hypermail/linux/kernel/2401.3/04208.html), although I initially saw a screenshot of it on Twitter. Not knowing much about the technical details, I found his candid style amusing and wanted to learn more about him. Although I've been using Ubuntu Linux throughout my PhD, I realized I knew little about its creator or the history of its development. This led me to read ["Just for Fun: The Story of an Accidental Revolutionary"](https://www.amazon.com/Just-Fun-Story-Accidental-Revolutionary/dp/1587990806), Linus's autobiography.

<p align="center">
  <img src="{{site.baseurl }}/assets/image/just-for-fun.jpg" width="200px" class="glightbox">
</p>

The book was a surprisingly engaging read. It details Linus's early life in Helsinki, his fascination with computers, the inception of Linux, and its subsequent success.

What captivated me most was Linus intrinsic motivation for understanding deep technical details, even when he was still an undergraduate student. During undergraduate study, he got interested in operating systems, inspired by Andrew S. Tanenbaum's "Operating Systems: Design and Implementation." He then spent a summer devouring this 719-page textbook purely out of interest:


> So there were two things I did that summer. Nothing. And read the 719 pages of Operating Systems: Design and Implementation. The red soft-cover textbook sort of lived on my bed.

Linus's jolt of enthusiasm left me in awe. Reflecting on my own experiences, I've purchased numerous math and machine learning textbooks throughout my education, and surely, I like some of them a lot. However, unlike Linus, I've never been compelled to read any of them from cover to cover. This realization gave me a lot to think about.

Linus didn’t stop at reading; he also experimented with Minix, the system described in Tanenbaum’s book. Finding it limited, he began creating new programs, which eventually led to the development of Linux. This iterative, hands-on approach is something I relate to in my own research projects (albeit at a much smaller scale). Getting to the bottom of a technical piece (a code repository, an algorithm, or a paper) often reveals its limitations and lead to new ideas.

I also admire Linus's willingness to challenge authority.  Despite being inspired by Andrew Tanenbaum's book, Linus didn't shy away from disagreeing with him. When Linux first came out, Tanenbaum criticized it for being a monolithic system, describing it as:

>LINUX is a monolithic style system. This is a giant step back into the 1970 ' s .

Linus disagreed with his preference for microkernel systems over monolithic ones, seeing unique advantages in the latter:

> Under Linux, which is a monolithic kernel, you have five different processes that each do a system call to the kernel. The kernel has to be very careful that they don't get confused with each other, but it very naturally scales up to any number of processes.

It's truly remarkable that Linus, who was just a master's student at the time, stood his ground against an established authority like Tanenbaum, an authoritative professor and textbook author on operating systems. It takes courage to trust his vision and push back against the establishment. This reminds me of Geoffrey Hinton’s assertion: "The future depends on some graduate student who is deeply suspicious of everything I have said."

Linus's playful tone in recounting his experiences, despite hardships, is also inspiring. His childhood was frugal, yet he maintained a positive outlook. For example, at times, her mother had to pawn their only stock of the Helsinkitele­ phone company (which they owned as part of having a telephone) to make ends meet. Even after moving to the US as a relatively renowned figure, he started with absolutely no money. When the Linux-related companies in which Linus had equity went public, he eagerly counted down the days until the six-month lock-up period ended, so he could finally sell his stock. He weaved humor into these stories, which make them very engaging to read.

Linus’s story is a testament to the impact of dedication, curiosity, and having fun. Can only recommend it!
