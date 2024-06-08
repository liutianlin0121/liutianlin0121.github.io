---
toc: false
layout: post
title: Reading "Just for Fun"
---


Earlier this year, I came across an angry email from Linus Torvalds, the creator of Linux, addressed to a kernel contributor. The original email is available on the [Linux mailing list](https://lkml.iu.edu/hypermail/linux/kernel/2401.3/04208.html), although I initially saw a screenshot of it on Twitter. Linus's blunt critique caught my attention:

> And dammit, STOP COPYING VFS LAYER FUNCTIONS.  
> It was a bad idea last time, it's a horribly bad idea this time too.  
> I'm not taking this kind of crap. [...] You copied that function without understanding why it does what it does, and as a result, your code IS GARBAGE.

Not knowing much about the technical details, I found his style amusing and wanted to learn more about him. Although I've been using Ubuntu Linux throughout my PhD, I knew little about its creator or the history of its development. This led me to read ["Just for Fun: The Story of an Accidental Revolutionary"](https://www.amazon.com/Just-Fun-Story-Accidental-Revolutionary/dp/1587990806), Linus's autobiography.

<p align="center">
  <img src="{{site.baseurl }}/assets/image/just-for-fun.jpg" width="200px" class="glightbox">
</p>

The book was a surprisingly engaging read. It details Linus's early life in Helsinki, his fascination with computers, the inception of Linux, and its subsequent success.

What intrigued me most was his deep passion for operating systems, inspired by Andrew S. Tanenbaum's "Operating Systems: Design and Implementation." Purely out of interest, Linus spent a summer engrossed this 719-page textbook:

> So there were two things I did that summer. Nothing. And read the 719 pages of Operating Systems: Design and Implementation. The red soft-cover textbook sort of lived on my bed.

His dedication amazed me. He wasn't driven by external factors but by pure enthusiasm. This kind of intrinsic motivation is something I respect a lot. Like Linus, I've also bought many technical textbooks throughout my education. But unlike Linus, I've never read any from cover to cover, which probably isn't a great idea.

Linus didn’t stop at reading; he also experimented with Minix, the system described in Tanenbaum’s book. Finding it limited, he began creating new programs, which eventually led to the development of Linux. This iterative, hands-on approach is something I relate to in my own research projects (albeit at a smaller scale). Getting to the bottom of a technical piece (a code repository, an algorithm, or a paper) often reveals its limitations, leading to new ideas.

I also admire Linus's willingness to challenge authority. Despite respecting Tanenbaum, he disagreed with his preference for microkernel systems over monolithic ones, seeing unique advantages in the latter:

> Under Linux, which is a monolithic kernel, you have five different processes that each do a system call to the kernel. The kernel has to be very careful that they don't get confused with each other, but it very naturally scales up to any number of processes.

This reminds me of Geoffrey Hinton’s assertion: "The future depends on some graduate student who is deeply suspicious of everything I have said."

Linus's playful tone in recounting his experiences, despite hardships, is also inspiring. His childhood was frugal, yet he maintained a positive outlook. For example, at times, her mother had to pawn their only stock of the Helsinkitele­ phone company (which they owned as part of having a telephone) to make ends meet. Even after moving to the US as a renowned figure, they faced challenges, like having no furniture initially and their daughter sleeping in her carriage.

Linus’s story is a testament to the power of passion, curiosity, and having fun. Highly recommend it!