### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 29ca8dc6-7fc0-11ee-1453-47e017e908ee
using PlutoTeachingTools, Plots, Random, Distributions, Luxor, PlutoUI

# ╔═╡ 32dfd8e1-5379-4403-b074-17d482fadd0d
PlutoUI.TableOfContents()

# ╔═╡ 89b49e35-a0c9-4654-b2ad-23507be62512
tip(md"""
**Building latex shortcuts** (optional)

- We are going to be using the $\mathbb{P}$ symbol a lot. It's annoying to write: `\mathbb{P}`

- So I am going to make a **shortcut** in $$\LaTeX$$:
>\newcommand{\P}{\mathbb{P}}

(see code box below).

Now I can just write `\P` instead of `\mathbb{P}`. Much easier!

This tip can be useful when you're writing your masters dissertation, hopefully in LaTeX and not microsoft word!

Notice that this is written in $\LaTeX$, which is embedded (with the dollar signs) in markdown. It's not written in Julia!
""")

# ╔═╡ 25e62c4c-2bea-4b51-a906-b13bff69fd45
aside(md"""
![](https://www.researchgate.net/profile/James-Peters-3/post/Why_LaTex_is_better_choice_than_Microsoft_Word/attachment/5e7df27a498d5000016dee25/AS%3A873677591674882%401585312378613/image/LaTeX-vs-Word.jpg)""")


# ╔═╡ 847f3a0a-f86d-482e-a257-f8fc91e02cb3
md"""
$$\newcommand{\P}{\mathbb{P}}$$
$$\newcommand{\N}{\mathcal{N}}$$ 
$$\newcommand{\U}{\mathcal{U}}$$
"""

# ╔═╡ 2b1684e0-65da-4d86-b694-5f6f19958e41
md"""
# Practice with probability density functions (PDFs)

- There are infinite possible PDFs. In the end, they are just functions for which the area under the curve (i.e. probability a random variable takes some value) is one. 

- There are lots of *common* pdfs, used in maths a lot. The code below shows some of the default one in the Distributions package (for univariate RVs, i.e. scalar random variables)

In this section we will get a bit of insight into why, despite all these pdfs, continuous random variables are so often modelled as uniform or Gaussian. 


"""

# ╔═╡ 4d931118-272b-4192-bf4d-bc51dd3f91ca
subtypes(UnivariateDistribution)

# ╔═╡ 18da4764-d04e-469a-9be1-d38310b8b636
md"""

> Suppose I randomly pick a number, between $0$ and $10$. What do you think I picked? 

We could have a random variable $R$ that maps my choice (the outcome) to the specific number I chose (a number between $0$ and $10$).
- *In a sense this random variable doesn't **do anything**. If I chose $0.7$ the RV would map to the same output $0.7.$*
- *Mathematically though, the input is an outcome in the outcome space (which happens to be a number). The output happens to be the same number, but now in the interval $[0,10]$*. **Same object, embedded in a different space.** 
"""

# ╔═╡ 862663e6-4395-4b54-98c4-dd31b53ce899
question_box(md"""
1. Does $R$ have a PMF or a PDF?
2. Sketch how you think the PMF/PDF of $R$ might look
""")

# ╔═╡ 8ce82d63-95ac-43d2-bf41-c5fc25c569d5
answer_box(md"""
1. PDF: the set of outcomes is a continuous space. There are infinite possible outcomes.
2. That's personal!
""")

# ╔═╡ 94f1bb7c-d863-4318-8856-eddcaca5621f
md"""
A lot of you might have chosen a **uniform distribution** for $R$. In other words, $R \sim \U([0,10])$.

Why?

We're going to think about this in detail. First, we are going to code a uniform random variable using the `Distributions` package, and plot it:





"""

# ╔═╡ cd2f6812-8566-46a0-8b73-bfface274d65
u = Uniform(0,10) # look at the live docs to see what you can do with it

# ╔═╡ 5d588e3f-5dfe-4e99-ad89-77f253eac3d2
md"""
We can get its probability density function with the function `pdf`:
`pdf(u,x)` gives the probability density of the RV $u$, at the value $x$.

---
### Aside: Plotting pdfs
For instance, let's plot it using the `plot` function. We *could* write

>`plot(x,y; label = ..., xlims = ..., ylims = ...., ...)`

- Here, `label` and `ylims` are **optional**, and known as keyword arguments. Keyword arguments work *exactly the same* as in Python. You put them after the unnamed function inputs, in any order. A semicolon ; separates them from the usual funcion inputs. There are many other optional keyword arguments you can use, and you usually check the documentation for their names.

-  `x` should be an ordered collection (i.e. array or range) of numbers: the x-values
-  `y` should similarly be an ordered collection of $y$-values of the same length as `x`.

Many plotting packages (Python and Julia) offer an alternative: directly plotting a function, rather than evaluating the functions inputs and outputs and plotting those (as above). So instead we can write:

>`plot(f, lb, ub; kwargs)`

*(where kwargs are the keyword arguments like `label` and `xlims`)*

Here, `f` is a function, and `[lb, ub]` (i.e. lower bounds, upper bounds) is the interval over which to plot it. 

**Plotting a function directly usually provides a better looking graph, in all languages**. The plotting package intelligently figures out the appropriate spacing of the x values it should evaluate `f` at. 

---
"""

# ╔═╡ be1e10cf-90c2-4d35-93fb-440b62d45b1f
plot(     #it's nice to write functions with lots of arguments on multiple lines like this!
	x -> pdf(u, x), # this is an anonymous function that takes x-vals to y-vals
	-5, 15; #lower and upper bounds
	ylims = (0,0.3), 
	label = "uniform RV",
	linewidth=6,
	linecolor=RGB(1,0,0),
	title = "PDF of a uniform on [0,10]"
)

# ╔═╡ c01f84c9-5b3c-4250-9564-cea467f6680f
md"""

### Back to guessing the random number 
(and why we chose a uniform distribution for $R$)

We asked:
> Suppose I randomly pick a number, between $0$ and $10$. What do you think I picked? 

My informal answer to why we modelled it uniformly:

> In the absence of more information, I believe that any number is equally likely as any other number. There is no reason for e.g. $7$ to be more likely than $3$ given the information available. A uniform pdf reflects the fact that you don't have confidence about any number being true. A non-uniform distribution wouldn't be flat, and would be thus more confident about particular ranges of numbers without any good reason. 

- You chose a uniform distribution because you **don't want to be more confident about any particular outcome than you have to be**, given your information on the task. 

- You want the **most uncertain** distribution that corresponds to the information given *(i.e. support is $[0,10]$ and mean is 5)*.

- As such, you unconsciously used the [**Principle of maximum entropy**](https://en.wikipedia.org/wiki/Principle_of_maximum_entropy), which we're going to explain a bit now:


1. Look at the two probability distributions below. Which looks more uncertain? 

*In other words if you made a guess on the outcome, in which case are you likely to get an actual outcome wildly different from your guess?*

"""

# ╔═╡ 95d19ac6-75b7-41ca-adba-66f11de6d1f0
function plot_two_gaussians()
	n1 = Normal(5, 0.1)
	n2 = Normal(5, 1.5)
	x = 0.1:0.1:10

	p = plot(x -> pdf(n1,x), 0,10; label = "low entropy", linewidth=4)
	plot!(p, x, x -> pdf(n2,x), label = "high entropy", linewidth=4, linestyle=:dash)
	
	return p
end

# ╔═╡ 3e56dc21-f899-430b-8c0a-77c905922746
plot_two_gaussians()

# ╔═╡ 8d71f9f9-f0a6-432d-88b2-7bd687742809
md"""
- The red probability distribution has higher uncertainty. For the blue distribution, the outcome is almost always going to be very close to $5$.

- In other words, **we have encoded less prior information in the red probability distribution.** It's more of an *"I'm not sure"* distribution.

There is a precise mathematical concept for the uncertainty of a distribution (and also for information). It has a mathematical formula that interested readers can refer to [here](https://en.wikipedia.org/wiki/Entropy_(information_theory)). It's called the entropy of a distribution. 
"""

# ╔═╡ e66edd6d-3b70-4059-b669-c9b30c6878d8
md"## Entropy"

# ╔═╡ c87cb5d8-8e39-41a9-bb94-11b9ffa2ce94
keyconcept("Entropy", md"""

- Intuitively, it measures how *spread out* the graph of the distribution is. Which corresponds to the uncertainty of the distribution.

- The formula for the entropy of a random variable $X$, if you're interested, is:

$$H(X) = \mathbb{E}[-\log \P[X]]$$

**Intuition for the formula**: 
- First look at the graph of $-\log \P[X]$ below
- I run an experiment, and record $X$
- Was the outcome of $X$ something that was highly likely (i.e. $\P[X]$ was close to $1$) or highly surprising (i.e. $\P[X]$ was close to 0)
- Note that $-\log \P[X]$ corresponds to the degree of surprise. It's higher if $\P[X]$ is closer to zero.
- Now run the experiment thousands of time, and record the average degree of surprise. This is your entropy!
""")

# ╔═╡ 5faf9f98-61b9-4acf-8d5a-9ef353170753
plot(x -> -log(x), 0.001, 1, linewidth=4, title = "Plot of log X")

# ╔═╡ aa509ff6-34f8-4d2f-9c18-df291a50e790
question_box(md"""
### Entropy: interactive demo:

 $\sigma^2 =$. $(@bind σ²_entropy Slider(0:0.1:10, show_value = true, default=5))
 
 $\mu =$ $(@bind μ_entropy Slider(-5:5, show_value = true, default=0))

- Look at the code in the function `entropy_demo` below
- Play with the sliders here. Explain verbally why changing $\mu$ has no effect, while increasing $\sigma^2$ increases the entropy.

""")

# ╔═╡ 06e82676-69c5-477f-a2b5-0a9093707bbc
function entropy_demo()
	μ = μ_entropy
	σ² = σ²_entropy
	
	n1 = Normal(μ, σ²)
	e = entropy(n1)
	
	p1 = plot(x -> pdf(n1, x), -10, 10, label="entropy = $(e)", ylims=(0,0.4), linewidth=4)
	return p1
end

# ╔═╡ 953c3184-da11-4b5a-ac17-84b6bab5fef8
entropy_demo()

# ╔═╡ 3bbbdc01-162a-4571-8cd7-1b4795e3fb20
keyconcept("Principle of maximum entropy", md"""
This principle says that you should pick the **most uncertain** (i.e. highest entropy) probability distribution consistent with what you know about the experiment.

- There are mathematical ways to figure out the max entropy pdf in different scenarios. 
- Here is a list of common [maximum entropy probability distributions](https://en.wikipedia.org/wiki/Maximum_entropy_probability_distribution)
- The uniform distribution is the max ent distribution on an interval $[a, b]$, where $a, b \in \mathbb{R}$
- **The Normal/Gaussian distribution is the max ent distribution given a specified mean and variance**

In other words, if I know nothing about a distribution except its mean and variance, it makes the most sense to model it as a Gaussian!! For exactly the same reason we modelled my random number above as a uniform.
""")

# ╔═╡ ad8d555e-dffe-4e56-b1a7-47620a7b2ddb
question_box(md"""
1. Use the information in the key concept above to explain why it was sensible to pick a uniform RV to represent the outcome of me choosing a random number between $0$ and $10$.

2. Express a flaw with choosing this uniform distribution, referring to the hint below:

3. I know that the mean height of a class is $170cm$, and the variance is $20$. Explain verbally why 
 	
a) Naively applying the principle of maximum entropy should lead me to model class height as a Gaussian.

 b) Using my extra 'common sense' (i.e. prior knowledge of the world not contained in this question) should lead me to not model class height as a Gaussian.

""")

# ╔═╡ 172b3814-7f2a-4cd6-8859-8d0438c10876
answer_box(md"""
1. The uniform distribution is the maximum entropy probability distribution on an interval $[a, b]$ (here, $a=0$ and $b = 10$). If we knew absolutely nothing about the probability distribution except that the outcome is between $0$ and $10$, we should pick a uniform.

2. We have extra information about the distribution from 'common sense', or our knowledge of what is normal in this world. Clearly, I'm not going to pick the number $4.45983749058745375$ as this takes ages to say and I'm lazy. There is a bias towards numbers that are easy to express, like $6$ or $\pi$.

3. 

a) A Gaussian specifies the principle of maximum entropy, given knowledge of the mean and variance. 

b) I know that most people are either biologically male or female, and this leads to differences in height. Thus the distribution might have two peaks (for mean heights of these two groups). This is extra information that should ideally be encoded in the probability distribution we choose.

""")

# ╔═╡ 81769a12-f7f1-405d-9da5-7b56dfe46761
hint(md"""
Which of these two numbers am I more likely to pick, given that I don't enjoy spending time reading digits:

1. $3.4324983705872095728340349823740587324895245$
2. $4.5$
""")

# ╔═╡ 9f12de78-8aae-4c9b-a5e2-5f9c21f24198
md"""
## Cumulative distribution functions
"""

# ╔═╡ 3667283c-be7b-4bda-9988-5afb37899b6a
keyconcept("CDF", md"""

1. Take a random variable $X$ whose outputs are in $\mathbb{R}$ *(a 'real-valued' RV)*
2. Consider a number $x \in \mathbb{R}$. What's the probability of the event $X \leq x$?
3. This is what the CDF, $F_X(x)$ provides:
$$F_X(x) = \P[X \leq x]$$

""")

# ╔═╡ 79e2df76-ba41-491f-be47-39a717491e5c
question_box(md"""

- In code: `cdf(n,x)` gives the cdf of a distribution `n` at x
- Use this to find the probability that a Gaussian (ie Normal) RV with mean $170$ and variance $30$ is between $165$ and $167$.
- Fill in the function below (`prob_between_a_and_b`). It should take in a distribution (e.g. `n = Normal(3,4)`)
- Play with the plots below. They show the PDF and CDF for both the (familiar) Gaussian distribution, and the (unfamiliar) Exponential distribution. What's the relationship with the pdf and the cdf? Why does the CDF tend towards $1$ for ANY pdf?

μ: $(@bind μᵪ Slider(1:10, show_value=true, default=0))

 $\sigma^2$: $(@bind σ²ᵪ Slider(0.2:0.2:2, show_value=true, default=1))

- alter the code in `gaussian_pdf_and_cdf` or `exponential_pdf_and_cdf`: make a new line on the plot that depicts the function: $f(x) = \P[ 2 \leq X \leq x]$, where $X$ is the (gaussian/exponential) random variable
""")

# ╔═╡ 60620f47-5ce5-45bd-8cbb-c879f3a064f2
answer_box(md"""
We have 
$$X \sim \N(170, \sqrt{30})$$

*(note that the second argument of `Normal` in julia is the standard deviation, not the variance. Standard deviation is the square root of variance)*



$\P[ 165 \leq X \leq 167] = \P[X \leq 167] - \P[X \leq 165]$

So we get 

$(cdf(Normal(170, sqrt(30)), 167) - cdf(Normal(170, sqrt(30)), 165))

- Same intuition for filling in the `prob_between_a_and_b` function below

- Add the line
`plot!(p, x -> cdf(n,x) - cdf(n,2), linewidth=4, label="prob between 2 and x")` to either of the functions `gaussian_pdf_and_cdf` or `exponential_pdf_and_cdf`

""")

# ╔═╡ 790e8e47-f68e-4dc1-a4ea-85cf5add66aa
function prob_between_a_and_b(distribution, a, b)
	(a > b) && return 0 
	return cdf(distribution, b) - cdf(distribution,a)
end

# ╔═╡ 7afb3924-a811-45cf-b4ea-b0e26d9374ae
function gaussian_pdf_and_cdf(μ, σ²)
	n = Normal(μ, σ²)
	p = plot(x -> pdf(n, x), linewidth=4, label="pdf", title = "Normal distribution", xlims=(0,10))
	plot!(p, x -> cdf(n,x), linewidth=4, label="cdf")
	plot!(p, x -> cdf(n,x) - cdf(n,2), linewidth=4, label="prob between 2 and x")
	return p
end

# ╔═╡ d75138a3-51e8-41be-b8d1-14a8207fd21f
function exponential_pdf_and_cdf(μ)
	e = Exponential(μ)
	p = plot(x -> pdf(e, x), linewidth=4, label="pdf", title = "Exponential distribution", xlims=(-1,10))
	plot!(p, x -> cdf(e,x), linewidth=4, label="cdf")
	return p
end

# ╔═╡ 4d4d16c1-7812-40d1-afdf-4fcb339ba64d
plot(gaussian_pdf_and_cdf( μᵪ,σ²ᵪ), exponential_pdf_and_cdf( μᵪ), layout=(2,1))

# ╔═╡ 14fe2fbc-b4aa-4aed-a53b-027b3007e791
if prob_between_a_and_b(Normal(3,2), 3, 4) ≈ (cdf(Normal(3,2), 4) - cdf(Normal(3,2), 3))
	correct()
	confetti()
else
	keep_working()
end

# ╔═╡ 9b1fc7b8-c6a9-47fc-a45f-0d08a3081845
md"""

# Law of conditional probabilities


$$\P[A | B] = \frac{\P[A \cap B]}{\P[B]}$$


**Draw a similar Venn diagram, and a few accompanying sentences of explanation, motivating the following law**

$$\P[A | B] = \frac{\P[B | A] \P[A]}{\P[B]}$$.

This is known as **Bayes' law**, and is really important to know if you're solving any complicated problem involving probabilities.



"""

# ╔═╡ 657eb6f7-927a-4081-b748-40cb36e7c616
keyconcept("Law of conditional probability", md"""

$$\P[A | B] = \frac{\P[A \cap B]}{\P[B]}$$

""")

# ╔═╡ 4da25a5b-cd2b-441d-99df-223244d18ce8
@drawsvg begin


	Luxor.translate(-250,-250)

setline(5)

@layer begin
		sethue((127,201,127)./255)
		setfont("Helvetica", 30)
		setline(6)
		settext("Ω: All outcomes", Point(250,35); halign="center" )
		squircle(Point(250, 250), 250, 250, action=:stroke)
end


	sethue((190,174,212)./255)
	Luxor.translate(200,300)
	Luxor.rotate(π/3)
	ellipse(Point(0,0),150,300, action = :stroke)
	settext("A", Point(-30,30); angle=30)
	ellipse(Point(0,0),150,300, action = :clip)
	
	Luxor.rotate(-π/3)
	Luxor.translate(-200,-300)

	sethue((253,192,134)./255)
	Luxor.translate(350,250)
	@layer begin
		setcolor((255,255,153, 100)./255)
		ellipse(Point(0,0),150,300, action = :fill)
	end
	clipreset()
	sethue((253,192,134)./255)
	ellipse(Point(0,0),150,300, action = :stroke)
	settext("B", Point(0,-100))

# color scheme from colorbrewer:
# 127,201,127
# 190,174,212
# 253,192,134
# 255,255,153
# 56,108,176
# 240,2,127

	
end 500 500


# ╔═╡ 45ee118a-1380-46ed-b8bb-6d4c599b0d34
md"""

- Make sure you understand how the law of conditional probability follows from the diagram above. It might help to note that when we draw a Venn diagram like above, we can draw it so the **area** of an event corresponds to its probability. 

Here is my explanation.

>Suppose the event $B$ has already happened. Then the possible set of outcomes is restricted to $B$. Now the set of events where $A$ happens is $A \cap B$ (shaded).
>
>Now the **probability** of $A$ happening relates to $\P(A \cap B)$. However, we're not looking for the probability of $A \cap B$ given any outcome. We are restricting ourselves to outcomes inside $B$, since $B$ happened. 
>
>This means we have to **divide** by $\P[B]$. Why? If we extended $B$ by adding outcomes outside of $A$ that made $B$ twice as probable, then the probability of $A|B$ would be half as much.  


"""

# ╔═╡ d88b7d79-9573-4a8c-8e2a-e7fd56174dbc
md"""
# Bayes Theorem

$$\P[A | B] = \frac{\P[B | A] \P[A]}{\P[B]}$$.
"""

# ╔═╡ 51a02fb6-3332-4015-9bcd-a320b7b30ef2
keyconcept("Bayes' Law", md"""
$$\P[A | B] = \frac{\P[B | A] \P[A]}{\P[B]}$$.
""")

# ╔═╡ 9a67069d-54f4-4d9a-9445-a43c831eda66
question_box(md"""
**Deriving Bayes Law**

1. Use the law of conditional probabilities to write expressions for both $\P[B | A]$ and $\P[A | B]$

2. Use the previous question to write two expressions for $\P[A \cap B]$. One in terms of $\P[B | A]$, and the other in terms of $\P[A | B]$.

3. Use this to derive Bayes' Law
""")

# ╔═╡ 4fe16934-28a1-469f-a41c-0d42a6ebaa1a
answer_box(md"""

$$\P[B | A ] = \P[ A \cap B] \P[A]$$



$$\P[A \cap B] = \P[B | A] \P[A] = \P[A | B]\P[B]$$

Rearrange the last two terms to get Bayes' law
""")

# ╔═╡ 2e7b6321-8f56-400d-8f34-d6b3a11189c1
md"""

## Case study: notebooks and marks

In this question we will the consider the marks you get on your assessment as the experiment.

- Suppose there are $230$ students
- Let the set of possible marks be $[0, 100] \cap \mathbb{N}$

*(In other words, any number on the interval between 0 and 100, intersected with the natural numbers)*
"""

# ╔═╡ 87cf64f5-1707-4ba3-ac54-ae5b7c705461
question_box(md"""
1. What is the sample space (/outcome space) for this experiment? Ideally write it in maths.
2. Is the sample space a vector space?
3. Can you verbally describe the event space? *(Challenge: what is its cardinality?)*
4. If we built a probability measure for the event space, would random variables on the sample space have a probability density function (PDF) or a probability mass function (PMF)?
""")

# ╔═╡ 82372462-2ab2-4ce3-b3c4-36548be2c276
answer_box(md"""

*I'm assuming zero marks is impossible, ie $\mathbb{N}$ doesn't contain zero. It's absolutely fine to assume it's possible, in which case replace $100$ below with $101$*

1. $$\Omega = \{n \in \mathbb{N}^{230}: n_i \in [0, 100] \ \forall i \}$$

IE the set of vectors of length $230$, whose entries are all natural numbers, and whose entries all fall between $0$ and $100$.

2. No it's not a vector space. We could do addition $\mod 100$ in this set and it would be closed under addition. But there is no multiplicative inverse. Just like the natural numbers themselves: the multiplicative inverse of $2$ is $\frac{1}{2}$, but this isn't in $\mathbb{N}$.

3. The set of sets of outcomes. Including the empty set $\emptyset$ and the entire outcome space $\Omega$. Also known as the power set of outcomes. 

- *The cardinality of the outcome space is $$| \Omega | = 100^{230}$$. Each student can get $100$ different possible marks. There are $230$ students*

- *The power set of a a set of cardinality $N$ has cardinality $2^N$. You can prove this by induction, starting with a set of cardinality one. I'm not going to here.*

- *So the number of possible events is $2^{100^{230}}$. Far higher than atoms in the universe.* 

4. Probability density function. Despite the big numbers above, there are still finite outcomes. At least some outcomes must have a nonzero probability, since $\P[\Omega] = 1$, i.e. the probabilities summed across the outcomes must get to one.
""")

# ╔═╡ 371e7bc6-e229-4dfa-b998-e5caabe53f44
md"""


- Let's divide the MCMCs students into two sets. Those who attempted the notebooks and those who didn't. We will call these respective sets $Y$ (attempted notebooks) and $X$ (ignored notebooks).

- Let the cardinalities of the two sets be $\| Y \| = 150 $ and $ \| X \| = 80$

- Let the mean and variances respectively be:

$$\mu(Y) = 70; \quad \mu(X) = 60$$
$$\sigma^2(Y) = 10; \quad \sigma^2(X) = 30$$

*Notice that $\mu$ and $\sigma^2$ are commonly used shorthands for the mean and variance, respectively. $\sigma$ itself is the standard deviation: the square root of the variance*

So students who attempted the notebooks did a bit better, and had lower variance.

- If marks were continuous, the principle of maximum entropy would tell us that it's reasonable to model them as a Gaussian distribution.
- Marks can't be distributed as a Gaussian, since they are discrete. Instead, let's take the probability of a student  in $X$ getting a mark $m$ as:

 $\P[x = m] = \P[z \in [m, m+1]], \quad \text{where} \quad z \sim \mathcal{N}(\mu(X), \sigma^2(X))$.

- Let's take the same formula for students in $Y$, but substituting $\mu(Y)$ and $\sigma^2(Y)$ instead.


"""

# ╔═╡ adb2ede5-f22d-4ca3-9f0a-2662499eebbf
question_box(md"""
1. Suppose I pick a student $s$ who got $53$. What's the probability that $s \in X$?
2. Suppose I pick a student $s$ who got $x$ marks. What's the probability that $s \in X$? Can you fill in the Julia function below to output this probability?
3. Suppose I pick two students: $s_1$ and $s_2$. They are both in the same set ($X$ or $Y$). They get marks $x_1$ and $x_2$. What is the probability they are both in $X$?
""")

# ╔═╡ 26a0d631-3471-49a8-88e7-b68db4509c6c
md"""

## Answer to 1. and 2.

Let $e$ be the event that the picked student got $x$ marks (for number 1, $x=53$). We are looking for $\P[X | e]$. Bayes theorem is:

$$\P[X | e] = \frac{\P[e |  X] \P[X]}{\P[e]}$$

Let's figure out these terms individually:

1.  $\P[X] = \frac{80}{230}$, $\P[Y] = \frac{150}{230}$



2.  $\P[e]  = \P[e | X]\P[X] + \P[e | Y]\P[Y]$. Mathematically, this is the [law of total probability](https://en.wikipedia.org/wiki/Law_of_total_probability). 

If the formula doesn't make sense, consider that $\P[e] = \P[e \cap X ] + \P[e \cap Y]$, since $X$ and $Y$ have no intersection, but at least one of them must be true. Then you can use the law of conditional probability.

Now we need to build functions for $\mathbb{P}[e | X]$ and $\mathbb{P}[e | Y]$. See below:

"""

# ╔═╡ c6d37894-b8e2-4b5e-948b-7170bbbe91f6
function mark_prob(mark::Integer, μ, σ²)
	n = Normal(μ, sqrt(σ²))
	return prob_between_a_and_b(n, mark, mark+1)
end

# ╔═╡ 057a3e00-3a1a-4999-b201-d29981674646
	function prob_in_set(which_set)
		if which_set=="X"
			return 80/230
		elseif which_set == "Y"
			return 150/230
		end
	end

# ╔═╡ c2ac0a95-d7cc-4ccd-83ed-a1a404f6c37a
function prob(mark, which_set)
	if which_set == "Y"
		return mark_prob(mark, 70, 10)
	elseif which_set == "X"
		return mark_prob(mark, 60, 30)
	end
end

# ╔═╡ 89de7369-8719-4ede-b095-68de3ed62c68
md"""
Let's use the law of conditional probability to get the overall probability of a mark in code:
"""

# ╔═╡ df0a1958-a7cb-42a1-8e21-712f35bd63e4
function prob(mark::Integer) # if there is no second input, julia will know to select this method for prob, instead of the ones above

	return prob(mark,"X")*prob_in_set("X") + prob(mark,"Y")*prob_in_set("Y")
end

# ╔═╡ ddf90aad-4738-4fd5-b827-f89b4ca1823b
prob(53, "X") # example 

# ╔═╡ 0df513b8-995c-41cf-9801-d3182f3cd643
prob(53)

# ╔═╡ 850293ec-e586-43bf-9e66-206d59386b27
function prob_student_is_in_set(mark, which_set)

	numerator = prob(mark, which_set)*prob_in_set(which_set)
	denominator = prob(mark)
	return numerator/denominator
end

# ╔═╡ da27f10e-7ade-456e-aa83-6c4c171d7838
prob_student_is_in_set(53,"X")

# ╔═╡ eca2ac62-b85d-48e2-974e-b5509cd338b7
md"""
#### (Optional) hidden complication:

- In the question, we said:
$\P[x = m] = \P[z \in [m, m+1]], \quad \text{where} \quad z \sim \mathcal{N}(\mu(X), \sigma^2(X))$.

- If you're observant, you may have noticed a possible issue. Probabilities have to sum to one. The support of a Gaussian distribution is unbounded (i.e. the interval $[-\infty, \infty]$). The support of our marks is bounded. How do we know that our new probability measure indeed sums to one? (i.e. $\sum_{m=1}^{100} \P[x = m] = 1$?

- Strictly speaking it doesn't. We should actually have:

$$\P[x = m] \propto \P[z \in [m, m+1]]$$

i.e. proportionality rather than equality. ($\propto$ means *is proportional to*). The constant of proportionality should be:

$$\P[x = m] = \frac{\P[z \in [m, m+1]]}{\P[z \in [0, 100]]}$$


However, both of the Gaussian distributions $\N(70, 10)$ and $\N(60, 30)$ are overwhelmingly likely to be inside the interval $[0, 100]$. In other words, $\P[z \in [0, 100] \approx 1$.

So we can ignore this complication!

We check this below:
"""

# ╔═╡ 5543c1d7-741e-443e-b3f5-91b7bc53758a
sum(mark -> prob(mark,"X"), 1:100)

# ╔═╡ 1760846f-2cef-4d2a-811d-814ce20d8aa7
sum(mark -> prob(mark,"Y"), 1:100)

# ╔═╡ e9ea8e14-87e9-4128-b9e4-dd41ca39e9c1
md"""
### Answer to 3.

- Let $B$ be the event that both students are in the same set.

- Let $A$ be the event that both students are in $X$.

- Let $C$ be the event that both students are in $Y$.

We are looking for $\P[A | B]$:

Law of conditional probability:

$\P[A | B] = \frac{\P[A \cap B]}{\P[B]}$


- Let $e_i$ be the event that student $s_i \in X$. We worked out the probabilities of these events in the last question.

Then $\P[A \cap B] = \P[A] =  \P[e_1]\P[e_2]$. (since event $A$ is a subset of event $B$)

Next, what is $\P[B]$? It's the union of the following two events: 
- probability both students are in $X$ 
- probability both students are in $Y$

Since these events, have no intersection, it's the sum of the probabilities of these two events:

$\P[B] = \P[A] + \P[C]$.

Overall

$\P[A | B] = \frac{\P[A]}{\P[A] + \P[C]}$. This is coded below
"""

# ╔═╡ 295d6097-02c7-41b7-8e45-944b67d655c3
function prob_both_in_X(mark1, mark2)

	PA = prob(mark1, "X")*prob(mark2,"X") # probability of event A
	PC = prob(mark1, "Y")*prob(mark2,"Y") #probability of event C
	
	return PA / (PA + PC)
end

# ╔═╡ 1130fa76-221a-4980-b8ec-05363ce5924f
prob_both_in_X(65,70)

# ╔═╡ 47276d09-9cb2-46f8-b4cd-9dd8a0323161
aside(md"![](https://i.redd.it/el0bknfgdg091.jpg)")

# ╔═╡ 5b02cb14-01ce-4207-92d5-13e59a9561d6
question_box(md"""
- What's the relationship between the central limit theorem and the picture to the right?

- Would the pattern of wear look the same if there were only e.g. $5$ machine users?
""")

# ╔═╡ b770914b-c416-4309-9f50-d9e439bff1d1
answer_box(md"""
Suppose there are $n$ gym users. Let $w_i$ be the weight that the $i^{th}$ gym user works out with.

We can think of $\{w_i\}_{i=1}^n$ as a set of identically distributed random variables. No idea what the distribution is, of course.

let's assume that the wear on each weight is roughly proportional to the number of users. Then $S_n = \frac{1}{n}\sum_{i=1}^n$ is approximately distributed as a Gaussian, if $n$ is large, by the central limit theorem. This is regardless of the distribution of each random variable $w_i$.


- If $n$ is small, the central limit theorem doesn't hold. We might e.g. have 3 'strong' gymmers, and 2 'weak' gymmers. The pattern of wear would then have two peaks at the 'weak' weight and the 'strong' weight. There is no reason for it to look Gaussian.

""")

# ╔═╡ f0bb41d5-43e2-4531-ac33-3c3ea7d70ef7
md"""
## Practice on transforming expectations and variances
"""

# ╔═╡ 12805d96-9dcc-4fb2-b882-7b0cbd16fbe6
question_box(md"""
In the lecture we talked about Bernoulli random variables. They describe questions about an experiment with a binary outcome (e.g. did the coin flip heads?).

Recall that if $X \sim Bern(p)$, then $X$ has the following PMF:
$$f_X(x) = 
\begin{cases}
1-p & (x = 0) \\
p & (x = 1)
\end{cases}$$

*This is a correction: In the original questions I swapped $x=0$ and $x=1$. The answers should be the same, as long as you substitute your $p$ for $q=1-p$*

A binomial random variable is describes the sum of $n$ Bernoulli random variables. (e.g. how many heads did I get out of $n=5$ coin flips). We write: $X \sim B(n,p)$

1.  Use the PMF of a Bernoulli random variable to calculate its expected value and variance as a function of $p$.

2. **Use the answer to 4a** to determine the expected value and variance of a binomial random variable as a function of $n$ and $p$. You only need to think about how to calculate the variance of a sum of Bernoulli random variables. 
3. (Hard, optional)
In the previous answer, we derived the expected value and variance of a Binomial random variable **without** using its probability mass function. In this question, try to derive the probability mass function of a binomial random variable. Hints:
- Think about the probability of getting $k$ heads on a sequence of $n$ coin flips:
    - What's the probability of one particular sequence of heads and tails with $k$ heads? 
    - How many different sequences of flips with $k$ heads exist? [This page](https://en.wikipedia.org/wiki/Binomial_coefficient) might help answer that.
    
The answer to this question is summarised on the [wiki page](https://en.wikipedia.org/wiki/Binomial_distribution#Probability_mass_function). 
""")

# ╔═╡ 9e7daf27-1985-45c1-9cde-c808b076f383
md"""
*There is a correction: In the original questions I swapped $x=0$ and $x=1$. The answers should be the same, as long as you substitute your $p$ for $q=1-p$*


1. The mean is:
$$\mathbb{E}[X] = \P[X=0]*0 + \P[X=1]*1] = p$$

Note that
$$\mathbb{E}[X^2] = \P[X=0]*0^2 + \P[X=1] = p$$

The variance is therefore

$$\mathbb{E}[X^2] - \mathbb{E}[X]^2 = p-p^2 = p(1-p)$$

2. Suppose we have $n$ random variables $\{X_i\}_{i=1}^n$ that are independent and identically distributed (i.i.d) So they each have the same mean and variance. Let $S_n = \sum_{i=1}^nX_i$.

Then by the laws of adding variances, we have:

$var(S_n) = \sum var(X_n)$.

So if $X_i \sim \text{Bernoulli}(p)$, then $S_n$ is a binomial, and $var(S_n) = np(1-p)$

3. The answer to this question is summarised on the [wiki page](https://en.wikipedia.org/wiki/Binomial_distribution#Probability_mass_function). 
"""

# ╔═╡ e617500c-9c64-4303-a663-1986c32ee66f
md"""
## Practice on central limit theorem
"""

# ╔═╡ 96a30247-e66b-4324-80cd-ac1e9fe726d9
question_box(md"""
Take the following uniform distribution:

$$Z \sim \mathcal{U}[\{1,2,4,9\}]$$.

Note that it can be simulated with the following code: `rand([1,2,4,9])`. I've made a function below: `random_output`, that does this for you.

1. Fill in the missing code for the histogram below. It should give you the histogram of the outcomes of $Z$ over $1000$ trials.

We now want to investigate the distribution of a random variable $$\bar{Z}_n = \frac{1}{n} \sum_{i=1}^n Z_i,$$ which charts the average of $n$ i.i.d (independent, identically distributed) samples of $Z$ from the question above. 

2. Build a function ```trial_average(n)```, that returns $\bar{Z}_n$. In other words, it samples ```random_output()``` $n$ times, and returns the average of these $n$ trials.

3. Build a function ```trial_average_distribution(m,n)```, which runs ```trial_average(n)``` $m$ times, and returns an array of length $m$ with the output of each experiment.

4. Plot a histogram of ```trial_average_distribution(400,100)```. What do you notice about the distribution? Can you explain in terms of the central limit theorem?

**Optional, harder**:

We talked about the (true) variance of a random variable in the lecture. One can also estimate the variance of a random variable by analysing the variation in its different samples. This is done by applying ```var``` to an array of samples (`np.var` in python). This is called the **sample variance**.


5. Plot a scatter graph of the sample variance of ```trial_average(n)``` as a function of $n$ (i.e. $n$ on the x-axis, sample variance on the y-axis. For each $n$, you may need to do several repeats, as the sample variance will naturally change from trial-to-trial. Use ```5:100``` as the range of $n$-values to plot.

6. Plot the mean of the scatter graph. What function does/should it look like, given the central limit theorem?

""")

# ╔═╡ c7a1dfe9-742e-4ab1-b14e-d2e80685ba87
random_output() = rand([1,2,4,9])

# ╔═╡ b2cbffc5-887b-4731-8235-92cf5e84044d
random_output()

# ╔═╡ a5229c70-87d3-4761-8e52-7cce04d1ada5
histogram([random_output() for i in 1:1000], bar_width=1) # fill this code for 1.

# ╔═╡ 114b986e-0b7e-4547-8c93-7b49ceb2000c
function trial_average(n)
	run(i) = random_output()
	return mean(i -> run(i), 1:n) # could also just write mean(run, 1:n)
end

# ╔═╡ 21c7c5e3-a3cd-46e0-a59e-b515d25851be
function trial_average_distribution(m,n)
	return [trial_average(n) for i = 1:m]
end

# ╔═╡ 3bf0a11c-96c2-4926-a229-c914bb58d65b
histogram(trial_average_distribution(400,100))

# ╔═╡ ae11179d-8217-43eb-bbc3-3e6a675e2c5c
md"""
- The distribution is Gaussian. The random variable is an average of another random variable (`rand_output`). It's an average of a sufficiently large number of copies (100) that the central limit theorem applies.

- If you change the 100 above to a lower number than 30, you might see that it looks less Gaussian
"""

# ╔═╡ 0b8e0eea-ed7e-4918-93cd-c169781764c2
sample_variance(m,n) = var(trial_average(n) for i = 1:m) #m samples

# ╔═╡ 499d8223-48e4-49ea-ac60-b5dc562003e4
num_samples = 144 # change this and see what happens!

# ╔═╡ 69c90987-7baf-4218-9617-ff1d309f5a88
my_sample_variance(n) = sample_variance(num_samples,n)

# ╔═╡ 4c11438c-15c8-4eaf-99e9-afe165d9ea03
my_sample_variance(10)

# ╔═╡ 943c822f-97b4-4a37-a428-7f577d2e926b
begin
	s = plot()
	repeats = 6
	for i = 1:repeats
		scatter!(s,my_sample_variance, 5:100, label = "repeat $i")
	end
	plot!(s, x -> 10/x, 5:100, linewidth=6, label="plot of $(sqrt(num_samples))/x")
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
Luxor = "ae8d54c2-7ccd-5906-9d76-62fc9837b5bc"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[compat]
Distributions = "~0.25.100"
Luxor = "~3.8.0"
Plots = "~1.39.0"
PlutoTeachingTools = "~0.2.13"
PlutoUI = "~0.7.52"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.0"
manifest_format = "2.0"
project_hash = "afa9af8ff0192ffd87c6de3ebb010a7ac25144c6"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "91bd53c39b9cbfb5ef4b015e8b582d344532bd0a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "43b1a4a8f797c1cddadf60499a8a077d4af2cd2d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.7"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo]]
deps = ["Cairo_jll", "Colors", "Glib_jll", "Graphics", "Libdl", "Pango_jll"]
git-tree-sha1 = "d0b3f8b4ad16cb0a2988c6788646a5e6a17b6b1b"
uuid = "159f3aea-2a34-519c-b102-8c37f9878175"
version = "1.0.5"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "a1296f0fe01a4c3f9bf0dc2934efbf4416f5db31"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.4"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "02aa26a4cf76381be7f66e020a3eddeb27b0a092"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.2"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "67c1f244b991cad9b0aa4b7540fb758c2488b129"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.24.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "600cc5508d66b78aae350f7accdb58763ac18589"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.10"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Compat]]
deps = ["UUIDs"]
git-tree-sha1 = "e460f044ca8b99be31d35fe54fc33a5c33dd8ed7"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.9.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.2+0"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "5372dbbf8f0bdb8c700db5367132925c0771ef7e"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.2.1"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3dbd312d370723b6bb43ba9d02fc36abade4518d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.15"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "938fe2981db009f531b6332e31c58e9584a2f9bd"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.100"

    [deps.Distributions.extensions]
    DistributionsChainRulesCoreExt = "ChainRulesCore"
    DistributionsDensityInterfaceExt = "DensityInterface"

    [deps.Distributions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DensityInterface = "b429d917-457f-4dbc-8f4c-0cc954292b1d"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[deps.EpollShim_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8e9441ee83492030ace98f9789a654a6d0b1f643"
uuid = "2702e6a9-849d-5ed8-8c21-79e8b8f9ee43"
version = "0.0.20230411+0"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "e90caa41f5a86296e014e148ee061bd6c3edec96"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.9"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "4558ab818dcceaab612d1bb8c19cee87eda2b83c"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.5.0+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "299dc33549f68299137e51e6d49a13b5b1da9673"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.1"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random"]
git-tree-sha1 = "a20eaa3ad64254c61eeb5f230d9306e937405434"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.6.1"
weakdeps = ["SparseArrays", "Statistics"]

    [deps.FillArrays.extensions]
    FillArraysSparseArraysExt = "SparseArrays"
    FillArraysStatisticsExt = "Statistics"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d8db6a5a2fe1381c1ea4ef2cab7c69c2de7f9ea0"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.1+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "8e2d86e06ceb4580110d9e716be26658effc5bfd"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.72.8"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "da121cbdc95b065da07fbb93638367737969693f"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.72.8+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "e94c92c7bf4819685eb80186d51c43e71d4afa17"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.76.5+0"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "d61890399bc535850c4bf08e4e0d3a7ad0f21cbd"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "5eab648309e2e060198b45820af1a37182de3cce"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.0"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "OpenLibm_jll", "SpecialFunctions"]
git-tree-sha1 = "f218fe3736ddf977e0e772bc9a586b2383da2685"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.23"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "f377670cda23b6b7c1c0b3893e37451c5c1a2185"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.5"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6f2675ef130a300a112286de91973805fcc5ffbc"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.91+0"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "81dc6aefcbe7421bd62cb6ca0e700779330acff8"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.25"

[[deps.Juno]]
deps = ["Base64", "Logging", "Media", "Profile"]
git-tree-sha1 = "07cb43290a840908a771552911a6274bc6c072c7"
uuid = "e5e0dc1b-0480-54bc-9374-aad01c23163d"
version = "0.8.4"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f689897ccbe049adb19a065c495e75f372ecd42b"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.4+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "f428ae552340899a935973270b8d98e5a31c49fe"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.1"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "f9557a255370125b405568f9767d6d195822a175"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.17.0+0"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Librsvg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pango_jll", "Pkg", "gdk_pixbuf_jll"]
git-tree-sha1 = "ae0923dab7324e6bc980834f709c4cd83dd797ed"
uuid = "925c91fb-5dd6-59dd-8e8c-345e74382d89"
version = "2.54.5+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "7d6dd4e9212aebaeed356de34ccf262a3cd415aa"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.26"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "0d097476b6c381ab7906460ef1ef1638fbce1d91"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.2"

[[deps.LoweredCodeUtils]]
deps = ["JuliaInterpreter"]
git-tree-sha1 = "60168780555f3e663c536500aa790b6368adc02a"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "2.3.0"

[[deps.Luxor]]
deps = ["Base64", "Cairo", "Colors", "DataStructures", "Dates", "FFMPEG", "FileIO", "Juno", "LaTeXStrings", "PrecompileTools", "Random", "Requires", "Rsvg"]
git-tree-sha1 = "aa3eb624552373a6204c19b00e95ce62ea932d32"
uuid = "ae8d54c2-7ccd-5906-9d76-62fc9837b5bc"
version = "3.8.0"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9ee1618cbf5240e6d4e0371d6f24065083f60c48"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.11"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Media]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "75a54abd10709c01f1b86b84ec225d26e840ed58"
uuid = "e89f7d12-3494-54d1-8411-f7d8b9ae1f27"
version = "0.5.0"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "51901a49222b09e3743c65b8847687ae5fc78eb2"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.1"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a12e56c72edee3ce6b96667745e6cbbe5498f200"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.23+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "2e73fe17cac3c62ad1aebe70d44c963c3cfdc3e3"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.2"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+0"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "3129380a93388e5062e946974246fe3f2e7c73e2"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.18"

[[deps.Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "4745216e94f71cb768d58330b059c9b76f32cb66"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.50.14+0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "716e24b21538abc91f6205fd1d8363f39b442851"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.2"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "64779bc4c9784fee475689a1752ef4d5747c5e87"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.42.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.0"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "f92e1315dadf8c46561fb9396e525f7200cdc227"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.5"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Preferences", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "ccee59c6e48e6f2edf8a5b64dc817b6729f99eb5"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.39.0"

    [deps.Plots.extensions]
    FileIOExt = "FileIO"
    GeometryBasicsExt = "GeometryBasics"
    IJuliaExt = "IJulia"
    ImageInTerminalExt = "ImageInTerminal"
    UnitfulExt = "Unitful"

    [deps.Plots.weakdeps]
    FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
    GeometryBasics = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    ImageInTerminal = "d8c32880-2388-543b-8c61-d9f865259254"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.PlutoHooks]]
deps = ["InteractiveUtils", "Markdown", "UUIDs"]
git-tree-sha1 = "072cdf20c9b0507fdd977d7d246d90030609674b"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0774"
version = "0.0.5"

[[deps.PlutoLinks]]
deps = ["FileWatching", "InteractiveUtils", "Markdown", "PlutoHooks", "Revise", "UUIDs"]
git-tree-sha1 = "8f5fa7056e6dcfb23ac5211de38e6c03f6367794"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0420"
version = "0.1.6"

[[deps.PlutoTeachingTools]]
deps = ["Downloads", "HypertextLiteral", "LaTeXStrings", "Latexify", "Markdown", "PlutoLinks", "PlutoUI", "Random"]
git-tree-sha1 = "542de5acb35585afcf202a6d3361b430bc1c3fbd"
uuid = "661c6b06-c737-4d37-b85c-46df65de6f69"
version = "0.2.13"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "e47cd150dbe0443c3a3651bc5b9cbd5576ab75b7"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.52"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00805cd429dcb4870060ff49ef443486c262e38e"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "0c03844e2231e12fda4d0086fd7cbe4098ee8dc5"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+2"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "eeab25344bf9901146c0200a7ca64ea479f8bf5c"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.9.0"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "90bc7a7c96410424509e4263e277e43250c05691"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.0"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Revise]]
deps = ["CodeTracking", "Distributed", "FileWatching", "JuliaInterpreter", "LibGit2", "LoweredCodeUtils", "OrderedCollections", "Pkg", "REPL", "Requires", "UUIDs", "Unicode"]
git-tree-sha1 = "7364d5f608f3492a4352ab1d40b3916955dc6aec"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.5.5"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "f65dcb5fa46aee0cf9ed6274ccbd597adc49aa7b"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.1"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6ed52fdd3382cf21947b15e8870ac0ddbff736da"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.4.0+0"

[[deps.Rsvg]]
deps = ["Cairo", "Glib_jll", "Librsvg_jll"]
git-tree-sha1 = "3d3dc66eb46568fb3a5259034bfc752a0eb0c686"
uuid = "c4c386cf-5103-5370-be45-f3a111cca3b8"
version = "1.0.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "30449ee12237627992a99d5e30ae63e4d78cd24a"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "c60ec5c62180f27efea3ba2908480f8055e17cee"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "e2cfc4012a19088254b3950b85c3c1d8882d864d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.3.1"

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

    [deps.SpecialFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "75ebe04c5bed70b91614d684259b661c9e6274a4"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.0"

[[deps.StatsFuns]]
deps = ["HypergeometricFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "f625d686d5a88bcd2b15cd81f18f98186fdc0c9a"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.3.0"

    [deps.StatsFuns.extensions]
    StatsFunsChainRulesCoreExt = "ChainRulesCore"
    StatsFunsInverseFunctionsExt = "InverseFunctions"

    [deps.StatsFuns.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "9a6ae7ed916312b41236fcef7e0af564ef934769"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.13"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.URIs]]
git-tree-sha1 = "b7a5e99f24892b6824a954199a45e9ffcc1c70f0"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "a72d22c7e13fe2de562feda8645aa134712a87ee"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.17.0"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "e2d817cc500e960fdbafcf988ac8436ba3208bfd"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.3"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "EpollShim_jll", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "7558e29847e99bc3f04d6569e82d0f5c54460703"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+1"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "04a51d15436a572301b5abbb9d099713327e9fc4"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.10.4+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "afead5aba5aa507ad5a3bf01f58f82c8d1403495"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6035850dcc70518ca32f012e46015b9beeda49d8"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.11+0"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "34d526d318358a859d7de23da945578e8e8727b7"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.4+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8fdda4c692503d44d04a0603d9ac0982054635f9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "b4bfde5d5b652e22b9c790ad00af08b6d042b97d"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.15.0+0"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "730eeca102434283c50ccf7d1ecdadf521a765a4"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.2+0"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "330f955bc41bb8f5270a369c473fc4a5a4e4d3cb"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.6+0"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "691634e5453ad362044e2ad653e79f3ee3bb98c3"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.39.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e92a1a012a10506618f10b7047e478403a046c77"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "49ce682769cd5de6c72dcf1b94ed7790cd08974c"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.5+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "868e669ccb12ba16eaf50cb2957ee2ff61261c56"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.29.0+0"

[[deps.gdk_pixbuf_jll]]
deps = ["Artifacts", "Glib_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pkg", "Xorg_libX11_jll", "libpng_jll"]
git-tree-sha1 = "e9190f9fb03f9c3b15b9fb0c380b0d57a3c8ea39"
uuid = "da03df04-f53b-5353-a52f-6a8b0620ced0"
version = "2.42.8+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.7.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9c304562909ab2bab0262639bd4f444d7bc2be37"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+1"
"""

# ╔═╡ Cell order:
# ╠═29ca8dc6-7fc0-11ee-1453-47e017e908ee
# ╟─32dfd8e1-5379-4403-b074-17d482fadd0d
# ╟─89b49e35-a0c9-4654-b2ad-23507be62512
# ╟─25e62c4c-2bea-4b51-a906-b13bff69fd45
# ╠═847f3a0a-f86d-482e-a257-f8fc91e02cb3
# ╟─2b1684e0-65da-4d86-b694-5f6f19958e41
# ╠═4d931118-272b-4192-bf4d-bc51dd3f91ca
# ╟─18da4764-d04e-469a-9be1-d38310b8b636
# ╟─862663e6-4395-4b54-98c4-dd31b53ce899
# ╟─8ce82d63-95ac-43d2-bf41-c5fc25c569d5
# ╟─94f1bb7c-d863-4318-8856-eddcaca5621f
# ╠═cd2f6812-8566-46a0-8b73-bfface274d65
# ╟─5d588e3f-5dfe-4e99-ad89-77f253eac3d2
# ╠═be1e10cf-90c2-4d35-93fb-440b62d45b1f
# ╟─c01f84c9-5b3c-4250-9564-cea467f6680f
# ╟─95d19ac6-75b7-41ca-adba-66f11de6d1f0
# ╠═3e56dc21-f899-430b-8c0a-77c905922746
# ╟─8d71f9f9-f0a6-432d-88b2-7bd687742809
# ╟─e66edd6d-3b70-4059-b669-c9b30c6878d8
# ╟─c87cb5d8-8e39-41a9-bb94-11b9ffa2ce94
# ╠═5faf9f98-61b9-4acf-8d5a-9ef353170753
# ╟─aa509ff6-34f8-4d2f-9c18-df291a50e790
# ╠═953c3184-da11-4b5a-ac17-84b6bab5fef8
# ╠═06e82676-69c5-477f-a2b5-0a9093707bbc
# ╟─3bbbdc01-162a-4571-8cd7-1b4795e3fb20
# ╟─ad8d555e-dffe-4e56-b1a7-47620a7b2ddb
# ╟─172b3814-7f2a-4cd6-8859-8d0438c10876
# ╟─81769a12-f7f1-405d-9da5-7b56dfe46761
# ╟─9f12de78-8aae-4c9b-a5e2-5f9c21f24198
# ╟─3667283c-be7b-4bda-9988-5afb37899b6a
# ╟─79e2df76-ba41-491f-be47-39a717491e5c
# ╟─60620f47-5ce5-45bd-8cbb-c879f3a064f2
# ╠═790e8e47-f68e-4dc1-a4ea-85cf5add66aa
# ╠═4d4d16c1-7812-40d1-afdf-4fcb339ba64d
# ╠═7afb3924-a811-45cf-b4ea-b0e26d9374ae
# ╠═d75138a3-51e8-41be-b8d1-14a8207fd21f
# ╟─14fe2fbc-b4aa-4aed-a53b-027b3007e791
# ╟─9b1fc7b8-c6a9-47fc-a45f-0d08a3081845
# ╟─657eb6f7-927a-4081-b748-40cb36e7c616
# ╟─4da25a5b-cd2b-441d-99df-223244d18ce8
# ╟─45ee118a-1380-46ed-b8bb-6d4c599b0d34
# ╟─d88b7d79-9573-4a8c-8e2a-e7fd56174dbc
# ╟─51a02fb6-3332-4015-9bcd-a320b7b30ef2
# ╟─9a67069d-54f4-4d9a-9445-a43c831eda66
# ╟─4fe16934-28a1-469f-a41c-0d42a6ebaa1a
# ╟─2e7b6321-8f56-400d-8f34-d6b3a11189c1
# ╟─87cf64f5-1707-4ba3-ac54-ae5b7c705461
# ╟─82372462-2ab2-4ce3-b3c4-36548be2c276
# ╟─371e7bc6-e229-4dfa-b998-e5caabe53f44
# ╟─adb2ede5-f22d-4ca3-9f0a-2662499eebbf
# ╟─26a0d631-3471-49a8-88e7-b68db4509c6c
# ╠═c6d37894-b8e2-4b5e-948b-7170bbbe91f6
# ╠═057a3e00-3a1a-4999-b201-d29981674646
# ╠═c2ac0a95-d7cc-4ccd-83ed-a1a404f6c37a
# ╠═ddf90aad-4738-4fd5-b827-f89b4ca1823b
# ╟─89de7369-8719-4ede-b095-68de3ed62c68
# ╠═df0a1958-a7cb-42a1-8e21-712f35bd63e4
# ╠═0df513b8-995c-41cf-9801-d3182f3cd643
# ╠═850293ec-e586-43bf-9e66-206d59386b27
# ╠═da27f10e-7ade-456e-aa83-6c4c171d7838
# ╟─eca2ac62-b85d-48e2-974e-b5509cd338b7
# ╠═5543c1d7-741e-443e-b3f5-91b7bc53758a
# ╠═1760846f-2cef-4d2a-811d-814ce20d8aa7
# ╟─e9ea8e14-87e9-4128-b9e4-dd41ca39e9c1
# ╠═295d6097-02c7-41b7-8e45-944b67d655c3
# ╠═1130fa76-221a-4980-b8ec-05363ce5924f
# ╟─47276d09-9cb2-46f8-b4cd-9dd8a0323161
# ╟─5b02cb14-01ce-4207-92d5-13e59a9561d6
# ╟─b770914b-c416-4309-9f50-d9e439bff1d1
# ╟─f0bb41d5-43e2-4531-ac33-3c3ea7d70ef7
# ╟─12805d96-9dcc-4fb2-b882-7b0cbd16fbe6
# ╟─9e7daf27-1985-45c1-9cde-c808b076f383
# ╟─e617500c-9c64-4303-a663-1986c32ee66f
# ╟─96a30247-e66b-4324-80cd-ac1e9fe726d9
# ╠═c7a1dfe9-742e-4ab1-b14e-d2e80685ba87
# ╠═b2cbffc5-887b-4731-8235-92cf5e84044d
# ╠═a5229c70-87d3-4761-8e52-7cce04d1ada5
# ╠═114b986e-0b7e-4547-8c93-7b49ceb2000c
# ╠═21c7c5e3-a3cd-46e0-a59e-b515d25851be
# ╠═3bf0a11c-96c2-4926-a229-c914bb58d65b
# ╟─ae11179d-8217-43eb-bbc3-3e6a675e2c5c
# ╠═0b8e0eea-ed7e-4918-93cd-c169781764c2
# ╠═499d8223-48e4-49ea-ac60-b5dc562003e4
# ╠═69c90987-7baf-4218-9617-ff1d309f5a88
# ╠═4c11438c-15c8-4eaf-99e9-afe165d9ea03
# ╠═943c822f-97b4-4a37-a428-7f577d2e926b
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
