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

# ╔═╡ 06dde7a0-8893-11ee-2886-bde88a457045
using Plots, Distributions, PlutoUI, PlutoTeachingTools

# ╔═╡ a6edeb63-48ad-4cfe-98b8-4307f9cb2d50
PlutoUI.TableOfContents()

# ╔═╡ a2a023c6-4e92-4c75-8572-d42429293615
md"""
# Stochastic model of COVID infection excluding recovery

(from the lecture)

We're going to build the simulation that was shown in the lecture. We will keep adding to it until we get to the full SIR model.

The goals are to
- get better with the methodology of model building
- reinforce understanding of differential equations
- get exposure to different coding patterns

Since you're in a busy period, I will do most of the coding for you in this notebook. Nevertheless, carefully inspect the code: you should understand it, and add the coding patterns I use into your arsenal.


## The situation
-  $N$ students in total
-  $S_k$ is the number of uninfected (i.e. **S**usceptible) students on day $k$
- Probability of an uninfected person getting infected on a given day is $\lambda$


In this model, each day, a certain number of people. The output of the model is the timecourse of infected people over time.

We'll start with a highly simplified model where a proportion $p = 1 - \lambda$  (e.g. $35 \%$) of the remaining people get infected every day. Therefore, the infection rate is **independent** of the proportion of infected people.
"""

# ╔═╡ 85a0ff43-cf22-45d9-a474-60c1772154b5
question_box(md"""
Why is this independence a bad assumption?
""")

# ╔═╡ a33a63d1-6bed-44a6-b799-2eb590e7b0f3
answer_box(md"""
The number of infected people should depend on both the number of suspectible people as well as the number of infected people.

To see this, consider a small classroom of $20$ people and the following two cases:
1. on day $k$, $15$ infected people went to class;
2. on day $k$, $1$ infected person went to class;

If you were in the class, would it be more likely to get infected in case $1$ or case $2$ on day $k+1$?
""")

# ╔═╡ 0a416c61-56b2-473b-9cb0-5d02b0226e03
md"""
### Step 1. Build the hyperparameters

- Hyperparameters are quantities that change the problem itself. Most programming / AI workflows will have some hyperparameters.
- It's often useful to put them all in a single dictionary, which can be passed to the functions that run the simulation
- That way, if you want to test different groups of hyperparameters, you can pack them all in different dictionaries and they won't interfere with each other.

We've built the hyperparameter dictionary below. The actual values for the different hyperparameters are in sliders located above the first plot. So you can change them
"""

# ╔═╡ c54580ea-63f3-45a8-849c-69b669dad3a2
md"""
- Does a given person get infected on a given day? This is a quantitative question about an experiment: i.e. a random variable. It takes the form of a true/false question. Hence we can model it probabilistically with a Bernoulli distribution

- How many susceptible people get infected on a given day? This is the sum of $S$ true/false questions, each with the same probability. IE $S$ identical Bernoulli distributions. Hence, it is a **Binomial distribution**.
"""

# ╔═╡ e84f8355-7653-4c16-a2b4-fe39c076aa90
answer_box(md"""
- The answer to the first question is a boolean answer, i.e., either true or false. Assume that the answer is the random variable $X$. Then we can model $X=1$ to be: yes it got infected, and $X=0$ to be: no, not infected. Then let's say that the probability to get infected is $P[X = 1] = p$ and $P[X = 0] = 1-p$ if not infected. Then the Bernoulli distribution would look like:
```math
P[X = x\,; p] = p^x\times (1-p)^{x-1},
```

- Now let's say we ask the same question to all susceptible people $S$ on a given day $k$. This is the same as taking $S$ answers from the previous question (i.e., we draw the random variable $X$ from the Bernoulli distribution $S$ times). Let's call the asnwer to this new question $Y$, which is the number of susceptible people that got infected. Then the binomial distribution for the random variable $Y$ is
```math
P[Y = y\,; S, p] = \frac{S!}{(S-y)!\,y!}\times p^y(1-p)^1-y.
```
"""
)

# ╔═╡ 38678692-925d-41f2-8c1d-2180b6fd426d
question_box(md"""
What assumptions did I make in the text box above?
""")

# ╔═╡ 6d836878-d1ef-4270-80bb-672c5890bb5f
answer_box(
	md"""
	We assumed that the question: "did you get infected on a given day?" is independent of the answers of all the other people. A bit like, when you construct the Binomial distribution from coin tossings, we assume that the result of the coin is independent of the previous coin toss. In this case, there may be some dependence between students in the class. For instance, consider three students who are friends with each other. If on day $k$ one of the three friends gets infected, the probability of the two other students getting infected the day after is probably higher that that of another person who is not in the friends group.
	"""
)

# ╔═╡ b0d89fb6-f122-416d-8ff1-05262ce0d0ed
md"""
- Now we are going to simulate infections over time. Inspect the `run_simulation` code below, carefully. Make sure you understand what is going on
"""

# ╔═╡ bc0b1b7a-5dc9-4f60-a3eb-097623b385fe
function run_simulation(hyperparams)

	B(susceptible) = Binomial(susceptible, 1 - hyperparams["λ"])  # make the correct binomial function
	
	S = zeros( hyperparams["days"],  hyperparams["repeats"]) # rows = days. cols = repeats. entries = number of susceptible people
	
	S[1,:] .= hyperparams["N"]
	for repeat in 1:size(S,2)
		for i in 2:size(S,1)
			S[i, repeat] = rand(B(S[i-1, repeat])) # random number distributed according to B(previous day susceptible people, repeat])
		end
	end
	return S

end

# ╔═╡ 161e0086-46b7-4fa8-aea8-c01594e7e564
hint(md"""
- `B(susceptible)` defines the binomial probability distribution using the number of Susceptible people and the probability of infection as parameters;
- `S` is defined to store tha values of Susceptible people for each day (each row a diff day) ad each trial (each column a different trial);
- `S[1,:]` the first value of $S$ for day $1$ is equal to $N$, i.e., all students are susceptible, there is no infected person yet on day $1$;
- then we loop for each day, and find the number of infected people everyday depending on the number of susceptible people $S$ from the day before;
- `repeats`, is the number of simulations we are running at once.

The result of the simulations is $S$ output below.
""")

# ╔═╡ 33e93bc2-5674-4ff1-9eb1-6d7e0f90862f
md"""
Each column stores the number of susceptible people each day for a differet trial (i.e., for `repeat = 2` we have $2$ simulations, hence $2$ columns).
"""

# ╔═╡ 2ade85d5-8f2a-4dd6-a6b4-e9f87d6a4d10
md"""
Now we can plot the simulation (see code below).
"""

# ╔═╡ 25b4e77f-dd7c-4638-b2c9-5ae8b82be5b5
function plot_simulation(h)
	S = run_simulation(h)
	I = h["N"] .- S

	labels = ["repeat $(i)" for i in 1:h["repeats"]] # Here we use string interpolation, see https://docs.julialang.org/en/v1/manual/strings/#string-interpolation
	labels = reshape(labels, 1, :) # labels need to be a 1 x n matrix for some silly reason
	s = plot() #susceptible
	i = plot() #infected

	scatter!(s, 1:h["days"], S, label = labels, ylabel = "Number of people", xlabel = "day", title = "Susceptible")

	scatter!(i, 1:h["days"], I, label=false, ylabel = "Number of people", xlabel = "day", title = "Infected")

	return s, i
end

# ╔═╡ ee30d5dd-a083-41da-b002-f1f40459e8ab
question_box(md"""
- Interpret the line 
`I = h["N"] .- S`

*(`.- ` is broadcasted minus: minus a scalar (`h["N"]`) from each element of a vector (`S`))*
""")

# ╔═╡ 8fbb0fab-ea5b-4236-9178-b7b609db60b3
answer_box(md"""
The number of infected people is the number of all people `N` minus the number of suscpetible people `S`. By broadcasting the difference, we subtract `N` from each value stored in `S`. This way, we quickly find the number of infected people for each day and for each trial using a single operation.
""")

# ╔═╡ ba1f85e5-811d-4860-8b04-a5ceaae55117
@bind n_students Slider(5:100; default=20, show_value=true)

# ╔═╡ b71ad838-3da0-4277-af14-49ff4f96ac81
@bind infection_rate Slider(0:0.01:1; default=0.1, show_value=true)

# ╔═╡ 0fa785ba-6ea4-4c5f-9bb7-2d9b0ec600ae

@bind simulation_length Slider(1:100; default=30, show_value=true)


# ╔═╡ 16d0f28d-5a12-4a75-b19a-232141b2ce13
@bind repeats Slider(1:10; default=2, show_value=true)

# ╔═╡ ff045d5f-9fcc-4700-abae-cf95109e2e9d
hyperparameters = Dict("N" => n_students, "λ" => infection_rate, "days" => simulation_length, "repeats" => repeats)

# ╔═╡ 6431ab2c-c478-437d-b53c-b95dbb21f272
let
	S = run_simulation(hyperparameters)
	# h = hyperparameters
	# I = h["N"] .- S
end

# ╔═╡ e9de440a-7417-49cb-8891-596d7e2d80ed
plot(plot_simulation(hyperparameters)..., layout=(2,1))

# ╔═╡ 92de969f-5197-4bd9-9c43-995c9b13f143
question_box(md"""
Explain how each of the parameters affect the inter-trial stochasticity, and why.
""")

# ╔═╡ 57b1a4d7-400c-4455-a03c-9ac4d4c768b5
answer_box(md"""
First of all, what is inter-trial stochasticity?
Inter-trial stochasticity is a another way of saying difference due to random effects between different simulations. If there was no inter-trial stochasticity, then each simulation will give exactly the same output at each step.

To answer the question, let's take a look at the parameters we have used for the simulation and determine which ones may affect the inter-trial stochasticity.

The `hyperparameters` are:
- `repeat` i.e., the number of trials. The more trials we have, the more sumulations we run. This allows us to investigate the stochasticity of the model, but the parameter itself does not change the inter-trial stochasticity. However, it does allows us to better estimate the inter-trial stochasticity;
- `λ` is the constant infection rate we have. Each day, `p = 1 - λ` is the percentage of susceptible people that get infected. It is a probability! Hence, it may not be the same each trial $\Rightarrow$ `λ` definitely affects the stochasticity of the system. However, consider the case `λ = 0`. In this case there is no stochasticity in the system, since nobody gets infected. Similarly, if `λ = 1` everyone gets infected on day $2$. Again, no stochasticity in these two cases;
- `N` is the total number of people which also greatly affects the stochasticity of the model. To see this, (informally) if we only had $3$ people, and $0 < \lambda < 1$, then there are only a few possible scenarios, either $0$,$1$,$2$ or $3$ people getting infected. If instead `N = 100`, there will be many more possible scenarios.

In conclusion, in a simulation many different parameters may affect the inter-trial stochsticity. Since this simulation is modeled exactly by the binomial distribution, we have a closed form function for the inter-trial stochsticity of the model: the variance of the binomial distribution, which indeed depends on the probability of infection and the number of susceptible students.
""")

# ╔═╡ 31390c3a-65ba-4133-b313-61d5f00ac1f9
hyperparameters

# ╔═╡ 456de239-2292-487d-a997-c9e60b797540
md"""
### Step 2: Mean field approximations

We can build the deterministic approximants of the stochastic dynamics of infection, using the methods from the lecture.

#### Option 1:

- Assume that the expected value of infections happens each day. This is deterministic, given the hyperparameters. 

"""

# ╔═╡ cfde4889-30e6-4999-b25b-c49a1bc26998
function calculate_expected_value(hyps)
	λ = hyps["λ"]
	q = 1 - λ
	days = hyps["days"]
	N = hyps["N"]
	return [N*(q^k) for k in 1:days]
end

# ╔═╡ 26f403a8-b13f-43f0-ad5c-a119f908a500
function plot_expected_SI_value(hyps)
	s,i = plot_simulation(hyps)
	scatter!(s, calculate_expected_value(hyps), linewidth=4, label="infections=expected infections", marker=:hex, markersize=6)
end

# ╔═╡ 49e0bd4d-ed47-437f-9db0-a150b2ab724e
plot_expected_SI_value(hyperparameters)

# ╔═╡ 6c73e1f3-61ea-4823-8c7b-b8dc0e73341c
md"""
#### Option 2

- Calculate continuous time, mean-field approximation.

In other words, assume that infections are happening constantly, rather than at midnight each day (see lecture)
"""

# ╔═╡ de348b20-c759-48eb-839a-c398773f51d7
function calculate_meanfield_approx(hyps)
    λ = hyps["λ"]
    N = hyps["N"]
	approx(t) = N*exp(-λ*t)
    return approx
end

# ╔═╡ decaab6d-c2be-4bc1-b342-2d64e30e6e83
function plot_meanfield_SI(hyps)
	s,i=plot_simulation(hyps)
	plot!(s, calculate_meanfield_approx(hyps), linewidth=4, label="mean field approximation")
return s
end

# ╔═╡ 40bf0e02-5355-43f3-9dae-43f16849c16e
plot_meanfield_SI(hyperparameters)

# ╔═╡ 8e07d19f-217d-4a3f-b3ac-038eae645daf
md"""
# Interlude
## Forward Euler algorithm for solving ODEs

### (Because there is a backward Euler too!)

- We derived the Forward Euler algorithm in the lectures. We're deriving it here again, just to make sure it's solidified in your head!

- We mentioned in the lecture that approximation error on successive steps of the algorithm could compound, leading to a terrible numerical solution that looks nothing like the true solution. This becomes more likely as $\delta t$ increases. 

- In this exercise, you will explore at what point the Forward Euler starts to diverge on a simple example. Play around with the code. Make sure you understand how the code works to help your coding skills.



### Quick re-derivation of Forward Euler

We start with the general form of a first order ODE:
$$\frac{dx}{dt}(t) = f(x,t)$$

**Expressing the derivative as a limit**

$$\frac{dx}{dt}(t) =  f(x(t), t) = \lim_{\delta t \to 0} \frac{x(t + \delta t) - x(t)}{\delta t}$$

(Note that we usually use $\dot{x}(t)$ instead of $\frac{dx}{dt}(t)$). 

**Rearranging**:

$\lim_{\delta t \to 0} x(t + \delta t) = \lim_{\delta t \to 0} \Big[ x(t) + \delta t * f(x(t), t) \Big]$ 

$x(t + \delta t) \approx  x(t) + \delta t * f(x(t), t)$

- The smaller the timestep $\delta t$, the closer we get to equality.
- *But how small is small enough???*

---
**Euler's method**
- Start with $x(0)$ *(initial condition)*
- Choose a fixed, small $\delta t$ *(how small?)*

$$x(\delta t) = x(0) + (\delta t)f(x(0),0)$$
$$x(2\delta t) = x(\delta t) + (\delta t)f(x(\delta t),\delta t)$$
$$\dots$$
$$x(N\delta t) = x\big((N-1)\delta t\big) + (\delta t) f\big(x((N-1)\delta t), t\Big)$$

---

"""

# ╔═╡ 078a41ae-2567-437e-93cc-f18a1a3edd04
md"""
### Let's code it!

Our goal is to implement the Forward Euler algorithm to solve ODEs of the form:

$$\frac{dx}{dt}(t) = \dot{x}(t) =  f(x(t),t),$$

where $x(t)$ is a vector, and $f(x,t)$ is an arbitrary function often called the *vector field* (since it takes in vectors, and spits out vectors of the same size) 

Let's take an arbitrary vector field (coded below) for testing
"""

# ╔═╡ 9d1be65e-4a6e-4f1e-85ff-2511411fafb0
function vf(x::Vector,time::Number)
	ẋ =  [x[2], -x[1], -x[1]*x[3]^2]
	return ẋ
end

# ╔═╡ b6d0c535-6614-430b-81ac-d0fe75a7aaa8
vf([1,2,3], 0)

# ╔═╡ 0f82229a-6393-4793-b4fa-aa404ac680ae
"""
	forward_euler_solve(f::Function, x₀, t₀, tₑ, δt)
f should be a function that accepts a vector x₀ of initial conditions, and a function `f` that takes an input state and a time: ie `f(x::Vector,time::Number)`

- t₀ is the starting time 
- tₑ is the end time
- δt is the step size
"""
function forward_euler_solve(f::Function, x₀, t₀, tₑ, δt)

	timepoints = t₀:δt:tₑ
	xs = zeros(length(x₀), length(timepoints))
	xs[:,1] .= x₀
	
	function populate(i) 
		xs[:,i] = xs[:,i-1] + δt*f(xs[:,i-1], timepoints[i-1]) # the forward euler step
	end

	[populate(i) for i in 2:length(timepoints)]
	return timepoints, xs'
end



# ╔═╡ 7d71f8b2-42fe-49e2-85e0-33ac189268f0
tip(md"""
Notice I've described `forward_euler_solve` using a string right above the function. This makes the string documentation. You can search for `forward_euler_solve` in the live docs now
""")

# ╔═╡ 773ef290-7ef3-4e5e-a296-1ca68cf7f673
plot(forward_euler_solve(vf, [1,2,3], 0, 10, 0.01)...) # ... is the splatting operator (* in python). it makes the separate outputs of `forward_euler_solve` act as separate inputs to plot

# ╔═╡ a07437a4-9ab3-4ffe-808f-e5230078c114
md"""
### When does approximation error compound and give a 'nonsense' solution?

**Let's approach this question with an example where we have the ground truth**

$$\frac{dx}{dt} =-2.5 x(t)$$

True solution:
$$x(t) = x(0) \exp(-2.5 t)$$

Euler step:
$$x(t + \delta t ) = x(t) - (\delta t) 2.5 x(t)$$

"""

# ╔═╡ daf84f8e-3bb6-4ede-9786-b74fb5ac1973
function ground_truth_vf(x,t) 
	ẋ = -2.5x
	return ẋ
end

# ╔═╡ e56f01b6-6fa5-4f40-a839-1852c4bc0da3
md"""	
` tstop = ` $(@bind tstop Slider(10:100;default=20, show_value=true))

`δt = ` $(@bind δt Slider(0.01:0.01:2; default=0.6, show_value=true))

` x0 = ` $(@bind x₀ Slider(0:10; default=8, show_value=true))
	"""

# ╔═╡ 177fe419-f5eb-4579-abbc-ef32cca86d5a
function plot_euler_vs_truth()
	p = plot()
	plot!(p,forward_euler_solve(ground_truth_vf, x₀, 0, tstop, δt)..., label = "Euler solution", linewidth=3)

	true_sol(t) = x₀*exp(-2.5t)
	
	plot!(p,true_sol,0, tstop,
	label = "true solution",
	linewidth = 4)
end

# ╔═╡ 6eb04617-e98d-463c-a954-de97c23db0b6
plot_euler_vs_truth()

# ╔═╡ 77a53a98-cc37-4d09-a805-b09c84326815
md"""
### Initial observations

- We can see that there are 'small enough' values for $dt$ where the Euler solution is pretty much perfect

- As we increase $\delta t$, the approximation error seems to increase. 

- At some point, there is a step change, and the Euler approximaton shows **qualitatively different behaviour**, rather than just being a bad approximation: the approximation error compounds.

### What's going on?!

First let's note the true solution is monotonically *shrinking*:

---
**True solution:** 

$x(t) = x(0)\exp(-2.5t)$

Therefore:

$\Bigg| \frac{x(t + \delta t)}{x(t)} \Bigg| = | \exp(-2.5\delta t) | < 1$, for $\delta t > 0$.

---
**Approximate solution:**

$\begin{align}
x(t+ \delta t) 	&= (1 - 2.5 \delta t) x(t) \\
				&= Ax(t)
\end{align}$

So we can see that the solution is perfect if 

$\exp(-2.5\delta t) = 1 - 2.5 \delta t$. 
Is there something meaningful about this formula? Think about the Taylor expansion of the exponential function (see Enrico's extras a few cells below, not required for the exam!). Meanwhile:

$\Bigg| \frac{x(t + \delta t)}{x(t)} \Bigg| = |A|.$

Now if $|A| > 1$ we can see that the Euler solution will **grow** over time, instead of shrinking like the true solution. The solution is **unstable**.

---



"""

# ╔═╡ 96c637bb-0460-494e-9e17-39cefd2b787e
question_box(md"""

1. Use the maths I wrote down above to determine mathematically which values of $\delta t$ will make the Euler solution diverge. Does your answer correspond to the results on the graph?

#### Optional questions


2. Consider a single step of the Euler approximation for the differential equation we covered. So given $x(t)$, consider the value of $x(t + \delta t)$, for a stable value of $\delta t$. 
* How much does it differ from the true solution? 
* How does this approximation error decrease as we decrease the step size by a linear factor $k$?
* How does the computational burden of simulation change as we decrease the step size?
*Note: the Euler method doesn't get accurate very fast as we shrink the step size, compared to more sophisticated methods. Coupled with it's poor stability issues, it's not actually a great algorithm in practice*

#### Optional challenges
3. Suppose I give you an arbitrary value of $\delta t$. For instance, $\delta t = 0.01$, or more generally $\delta t = \epsilon$, for some $\epsilon$. Can you design a differential equation for which the Euler approximation, with $\delta t = \epsilon$, is unstable?

4. (Bonus) Can you design a differential equation where the Euler approximation won't converge to the solution, however small your step size $\delta t$? *Hint: Think about the function $sin(\frac{1}{t}$)*

""")

# ╔═╡ c953aece-1811-4926-a3dc-f8fe446eacf4
md"""
---
**Extra by Enrico: not required for the exam!**

Where does the solution to the linear ODE $\dot{x} = -ax(t)$ come from?

A general solution (actually, this is the physicist way of solving ODEs) can be found using the following steps.

Assuming that we can split the fraction $\dot{x} = \mathrm{d}x / \mathrm{d}t$, we move the $\mathrm{d}t$ to the RHS and $x(t)$ to the LHS, then:

$\int (1/x)\mathrm{d}{x} = \int -a \mathrm{d}{t} \Rightarrow \ln(x) = c - at \Rightarrow x(t) = e^{c}e^{-at} = x(0)e^{-at},$
where the integration constant $e^{c} = x(0)$ is obtained by assuming that we know some initial condition $x(0)$ at time $t=0$. To see this explicitly, at time $t=0$ we have:

$x(0) = e^{c}e^{-a0} \Rightarrow x(0) = e^{c}.$

---
"""

# ╔═╡ 121c14bf-5b2c-499b-959c-315197cd18a8
md"""
For Question 1:
"""

# ╔═╡ 14b0994b-c1ee-4e23-8b54-a9ed9cdf2220
answer_box(md"""
**Answer to Question 1**


So we have seen that the true solution, $x(t) = x(0)e^{-2.5t}$, is monotonically shrinking: i.e., it is an exponential with a negative exponent: $-2.5\times t$, since $t>0$. Hence, $e^{-2.5t}$ will always be a number smaller than $1$ (to see this, note that you can write $e^{-2.5t} = \frac{1}{e^{2.5t}}$, if still unsure it is always a nice idea to plot it: `plot([ℯ^(-2.5x) for x in 0:0.01:10])`). **Crucially**: *we require our approximation to also satisfy this property*. Hence, we require that 
```math
\begin{align}
\Bigg| \frac{x(t + \delta t)}{x(t)} \Bigg| &< 1 \\
\Bigg| \frac{x(t + \delta t)}{x(t)} \Bigg| &= \Bigg| \frac{(1-2.5\delta{t})x(t)}{x(t)} \Bigg| \\
& = |1-2.5\delta{t}| < 1
\end{align}
```
What $\delta{t}$ satisfies this inequality?
```math
\begin{align}
&|1-2.5\delta{t}| < 1 \\
\\
&\Rightarrow1-2.5\delta{t} < 1\quad\text{or}\quad -1+2.5\delta{t} < 1 \\
&\Rightarrow \delta{t} < \frac{2}{2.5} \approx 0.8
\end{align}
```
while the other inequality is satisfied for any $\delta{t}$.

Of course, we only consider solutions for $\delta{t} > 0$, so the final answer is $\delta{t} < 0.8$. You can now try to go back to the plot above and slowly change $\delta{t}$ from $0.7$ to $0.81$. At exactly $0.8$ the Euler solution will start to oscillate with a constant period, while for values of $\delta{t} > 0.8$ it will exponentially increase!
""")

# ╔═╡ 3140c630-c077-4b6f-82f3-7975dcf75fc6
md"""
For question 2:
"""

# ╔═╡ 6eac4b22-46de-4baf-82aa-104b007b1c22
answer_box(md"""

**Answers to Question 2**

Use the code below to see how we can code an answer for this, you can use the Slider to change the value of the linear factor $k$. Below as an extra not required for the exam, you can also take a look at how we can answer to this question analytically.

Finally, to answer to the last part of question 2, notice how the smaller the step size, the longer the computation. For instance, if we want to solve a differential equation for a particularly long time range, say between times $t_0 = 0$ seconds and $t_f = 10000$ seconds, then a step size of $\delta{t} = 0.01$ will already result in 

```math
\frac{t_f - t_0}{\delta{t}} = 10^6\quad\text{operations!}
```
In this particular case Julia has no issues performing $10^6$ operations, but if the Euler method calculation was a bit more complicated (for instance the solution of a system of equations, which will look like a matrix), this may be a big issue. Hence, it is important to be pragmatic sometimes! If we are computing some differential equation to calculate something like the speed of a car, we probably don't really care about incredible precisions unless you are a huge fan of the F1. Hence, in many cases an error of $\sim 0.02$ is more than acceptable.

---
---

**Again, extra by Enrico: no need to know about this for the exam**

Analytically, we may use the Taylor expansion of the true solution of the differential equation to see how the Euler step compares to the true solution.
This is a bit more advanced but the [Taylor expansion](https://en.wikipedia.org/wiki/Taylor_series) is a method to rewrite a function as an infinite sum. For now, you may just convince yourself that this infinite sum is exactly the same as the original function!

In practice, notice that the Taylor expansion of the exponential is:
```math
\exp(-2.5\delta t) = \sum_{k}\frac{(-2.5\delta{t})^{k}}{k!} = 1 - 2.5\delta{t} + \frac{1}{2!}(-2.5\delta{t})^2 + \frac{1}{3!}(-2.5\delta{t})^3 + \dots
```
Note how the first two terms of the expansion of the RHS are exactly the same as our Euler step! i.e., $1 - 2.5\delta{t}$.

Then, the rest of the infinite sum is basically the difference between our finite difference method and the true solution. Notice how the terms of the infinite series are some powers of $\delta{t}$. Since $\delta{t} < 1$, each will be smaller and smaller. For instance, using $\delta{t} = 0.1$ we have $\frac{1}{2!}(-2.5\delta{t})^2 = 0.03125$ while $\frac{1}{3!}(-2.5\delta{t})^3 = -0.0026041$ and so on, smaller and smaller.

Hence, the highest error terms: $\frac{1}{2!}(-2.5\delta{t})^2 + \frac{1}{3!}(-2.5\delta{t})^3 = 0.02864$ will give us a good idea of the error of the Euler's method! indeed, using the code below, for $k=1$, we have $\delta{t} = 0.1$ and the error is around $0.028$.

Plugging in the linear factor $k$ in the error terms from the Tayor example will give us an idea of how the solution will change if we had a different $\delta{t}$.
""")

# ╔═╡ 69cbafd3-50fc-4f1f-b447-b54fb9ed9b1e
md"""
For questions 3 and 4
"""

# ╔═╡ 40a8e3af-6f57-4292-a75a-8c3299f22148
answer_box(md"""
**Answers to Question 3**

One way to do this, is to "reverse-engineer" our solution to question 1. Consider the general linear ordinary differential equation $\dot{x} = -a x(t)$ with solution $x(t) = x(0)e^{-at}$ for $a > 0$.

Then, our approximate solution using the Euler step will look like: $x(t+ \delta t)	= (1 - a \delta t) x(t)$. Similarly to question 1, we require $|(1 - a \delta t)| < 1$ for stable solutions and $|(1 - a \delta t)| > 1$ for unstable solutions. Then, for unstable solutions, assuming that $\delta{t} = \epsilon$ we have:
```math
\begin{align}
|(1 - a \epsilon)| &> 1 \\
(1 - a \epsilon) > 1\quad &\text{or}\quad -(1 - a \epsilon) > 1
\end{align}
```
the first inequality is true for any $\epsilon > 0$ since we assumed that $a>0$. The second inequality instead is true as long as $a\epsilon > 2$. By plugging in $\delta{t} = \epsilon = 0.01$ we find $a > 2 / \epsilon = 200$.

Hence, if we had the differential equation $\dot{x} = -200 x(t)$ the Euler step solution will be unstable for $\delta{t}  = 0.01$. You can check this by changing the `ground_truth_vf` and `plot_euler_vs_truth` functions from a few cells above, using $-200$ rather than $-2.5$ in the exponent.

**Answer to question 4**

As suggested in the question, consider something that has the form:

$\dot{x} = a\sin(1/t)$

The Euler approximation will then look like:

$x(t+\delta{t}) \approx x(t) + \delta{t}\times a\sin(1/t)$

We do not know the true solution to the function, i.e., $x(t)$, but we can still appreciate why the Euler approximation won't work very well in this case.

Note that $\sin(1/t)$ will always be a number smaller than $1$. Depending on the step size, we will have very different behaviours.
""")

# ╔═╡ 7b7f3fe5-658e-45f4-865f-e23f11c674b5
@bind select_t Slider(collect([10. ^(-i) for i in 1:5]), show_value = true)

# ╔═╡ b76efc34-a790-4e60-ab4b-06c3816435b4
let
	t = collect(0.000001:select_t:1)
	x(t) = sin(1/t)

	plot(
		x,
		t
	)
end

# ╔═╡ 4c752449-b22d-42df-b362-45061ac86f17
begin
	K_slider = @bind k Slider([1,10,25,50,100,500,1000,10000], show_value = true)
	md"""
	Select $k$: $(K_slider)
	"""
end

# ╔═╡ 4e6aa219-1417-48d9-97e7-05ab5dbf0c58
let
	println("Question 2\n")
	Δt = 0.1 * (1/k)
	x(t) = 1 * ℯ^(-2.5*Δt)
	println("Euler's method after one step using x(0) = 1: $(1*(1-2.5*Δt))")
	println("true solution after time t = Δt using x(0) = 1: $(x(Δt))")

	println("\nError or difference between Euler's method and true solution: $(abs(1*(1-2.5*Δt) - x(Δt)))\nusing Δt = $(Δt) and k = $(k).")
end

# ╔═╡ 9a3fbd66-bf9d-4864-a44c-6522367c7a45
let
	println("Question 2 Extra by Enrico\n")
	δt = 0.1
	x(t) = 1 * ℯ^(-2.5*δt)

	# These are the terms of the Taylor expansion of the true solution
	error_terms(Δt, power) = (1/factorial(power)) * (-2.5*Δt)^power

	# then see how the "error terms", i.e., terms 3 and 4 of the Taylor expansion
	# are very close to the difference between the true solution and the Euler step method for a given step size δt
	println(
		"Error from first two error terms in the expansion:\n",
		sum([error_terms(δt, i) for i in 2:3])
	)

	# here I used δt = 0.1 (feel free to change it above), and the output is 0.02864... very close to the difference we found earlier:

	println(
		"\nError or difference between Euler's method and true solution:\n",
		abs(1-2.5*δt - x(δt))
	)
end

# ╔═╡ f012d075-e41e-4258-945a-044579bc61de
md"""
### Final notes on Forward Euler

- There are literally hundreds of algorithms like Forward Euler for numerically solving ODEs. Forward Euler is the most basic. You can use an ODE solving package 

- In real life, you would not code up the numerical algorithm (Forward Euler/...) yourself. You would use a package like [this](https://docs.sciml.ai/OrdinaryDiffEq/stable/) (docs [here](https://docs.sciml.ai/DiffEqDocs/stable/getting_started/)). 


"""

# ╔═╡ 647708e0-3e3a-44c7-916c-18262c68fa83
md"""
# Full SIR Model

Let's get back to modelling pandemics. Recall that 

-  $S$ is susceptible (healthy, previously uninfected people)
-  $I$ is currently infected people
-  $R$ is recovered people

From the lecture, we had 

$$\dot{S}(t) = -p\frac{S(t)I(t)}{N}$$

$$\dot{I}(t) = p\frac{S(t)I(t)}{N} - \gamma I(t)$$

$$\dot{R}(t) = \gamma I(t)$$

"""

# ╔═╡ 952b3da1-9221-4730-801a-239a71bf88f2
question_box(md"""
List as many assumptions as you can on the SIR model above
""")

# ╔═╡ efa4453a-c445-4481-802b-c6b50f5c438e
answer_box(md"""
- Infections follow a binomial distribution with probability equal to infection rate $p$.
- Infections are proportional to the proportion of the infected population.
- Recoveries follow a binomial distribution with probability equal to recovery rate $γ$.
- Recovered people do not become susceptible again.
""")

# ╔═╡ 128e710b-9dd7-4484-9012-b12c62685ade
md"""

Let's code up the vector field above (see `build_SIR_dynamics`) below. Instant issue, the vector field depends on hyperparameters. But for `forward_euler_solve`, it should only depend on states $x$ and time $t$. How can we fix this issue?

- One way (see below), is to have a 'factory' function, that takes in hyperparameters, and emits the actual function, which is now seeded with the appropriate hyperparameters. 

- Note that some hyperparameters are shared with the SI model above: you can slide them there. If this is annoying, open the notebook in two windows simultaneously!
"""

# ╔═╡ cbd7b28a-83d6-4a2c-aad5-9712835e0cbf
## the 'factory' function
function build_SIR_dynamics(hyps)    
    p, γ, N = [hyps[el] for el in ["p", "γ", "N"]]
    
    function SIR_dynamics(x,t)
		S,I,R= x # x is a 3-vector, so this puts its elements into S I and R
        return [-p*S*I/N , p*S*I/N - γ*I,γ*I ]
	end
    return SIR_dynamics
end

# ╔═╡ e16bb143-a2fd-4da4-8bec-466f286302d4
@bind n_SIR_students Slider(5:5:200, default=100, show_value=true)

# ╔═╡ ee9857e5-8755-4321-8360-7a03b2726ef8
@bind initial_SIR_infections Slider(5:5:n_SIR_students, default=1, show_value=true)

# ╔═╡ 5d3afbe2-e0de-4db5-b4ec-1faa7d560ad3
@bind SIR_days Slider(5:200, default=50, show_value=true) 

# ╔═╡ d45f4a0b-62bc-4633-b02c-ea2e8244a367
@bind recovery_rate Slider(0:0.01:1, default=0.1, show_value=true)

# ╔═╡ a59df3b0-b4fe-49d9-8845-1f1cc7665937
@bind infectiveness Slider(0.0:0.01:1, default=0.4, show_value=true)

# ╔═╡ d1d881e3-f5d0-499d-8b70-0dd00f74e1aa

@bind euler_step Slider(10.0 .^(-4:2), default=1e-1, show_value=true )

# ╔═╡ 96985210-390b-4a11-a3d3-a00e1c77f752
SIR_hyperparameters = Dict( 
	"N" => n_SIR_students,
	"I₀" => initial_SIR_infections,
	"R₀" => 0, # initial recovered
	"days" => SIR_days,
	"p" => infectiveness,
	"γ" => recovery_rate,
	"δt" => euler_step
)


# ╔═╡ 4a73b9ee-3387-4673-892a-b31e688b9652
SIR_hyperparameters

# ╔═╡ 24d3e953-71d6-4180-93a9-b03918f87ffe
function build_initial_conditions(hyperparameters)
    S0 = hyperparameters["N"] - hyperparameters["I₀"] - hyperparameters["R₀"]
    I0, R0 = [hyperparameters[el] for el in ["I₀", "R₀"]]
    return [S0, I0, R0]
end

# ╔═╡ 4df711d0-2224-48c6-bdfc-4cb22530f2ab
build_initial_conditions(SIR_hyperparameters)

# ╔═╡ 60a56482-509a-4ffb-beba-7889cd4c73eb
function plot_SIR(hyps)
	ts, xs = forward_euler_solve(
		build_SIR_dynamics(hyps), 
		build_initial_conditions(hyps),
		0,
		hyps["days"],
		hyps["δt"]
)
return plot(ts, xs, label=["susceptible" "infected" "recovered"])
end

# ╔═╡ 550a0763-3313-448e-827a-38c2886fa66c
plot_SIR(SIR_hyperparameters)

# ╔═╡ 26a338b8-495f-4650-aa58-384784d3cfcb
question_box(md"""

1. Go through the lecture notes and make sure you understand $R_0$, and why $\dot{I}(t) < 0 $ always if $R_0 < 1$. 


2. Make a function whose input is the hyperparameters, and whose output is $R_0$. Run the function below the SIR plot, so you can see how changing the parameters changes both the $R_0$, and the dynamics of the pandemic

3. Suppose I extended the model by allowing recovered people to eventually become susceptible again (i.e. they lose immunity). Would this affect the statement that $R_0 < 1$ avoids a pandemic?


**Optional challenges**
- Extend the model by allowing recovered people to eventually become susceptible again (i.e. they lose immunity)
- Add seasonality to the model. EG the infectiveness varies sinusoidally with some frequency.


""")

# ╔═╡ c83bc246-2cd6-41e9-bd4c-790838b4a243
answer_box(md"""
1. If at time point $t$ we have a population of $I(t)$ infected people and on average each one of them infects other $R_0$ people, then at time $t+1$ the population will become a group of $\dot{R}(t+1)=I(t)$ recovered people and $I(t+1)=I(t)*R_0$ infected people. The rate of change of infected population is $\dot{I}(t) = I(t+1)-I(t) = I(t)*R_0-I(t) = I(t)*(R_0-1)$. We can then see that if $R_0=1$ the number of infected people won't change ($\dot{I}=0$), if $R_0>1$, the number of infected people will keep rising ($\dot{I}>0$), and if $R_0<1$, the number of infected people will keep falling ($\dot{I}<0$).
 
3. Allowing recovered people to become susceptible again returns some of the population back to the susceptible pool, but it doesn't change the infection dynamics. If $R_0<1$, then $\dot{I}<0$, which means that the number of infections will keep falling regardless of how many susceptible people there are.
""")

# ╔═╡ d0b7e47f-9243-46dd-b490-e4cc3341e878
md"""
Below you can find the code solution to question 2.

First define the hyperparameters:
"""

# ╔═╡ 7df4c090-3086-49c4-b560-c558d36df7ee
md"""
Then we modify the previous functions to add the reinfections:
"""

# ╔═╡ a6b56c96-df45-409a-a678-cf6d47c33b5e
## the 'factory' function
function build_SIR_dynamics_reinfection(hyps)    
    p, γ, N, r, freq, amp = [hyps[el] for el in ["p", "γ", "N", "r", "freq", "amp"]]
    
    function SIR_dynamics(x,t)
		S,I,R= x # x is a 3-vector, so this puts its elements into S I and R
		
        return [r*R-p*S*I/N*(sin(t*freq)*amp+1) , p*S*I/N*(sin(t*freq)*amp+1) - γ*I,γ*I - r*R]
	end
    return SIR_dynamics
end

# ╔═╡ d1a38411-a967-4ab6-848d-25958c8fe369
function plot_SIR_reinfection(hyps)
	ts, xs = forward_euler_solve(
		build_SIR_dynamics_reinfection(hyps), 
		build_initial_conditions(hyps),
		0,
		hyps["days"],
		hyps["δt"]
)
return plot(ts, xs, label=["susceptible" "infected" "recovered"])
end

# ╔═╡ 84b77ae5-7d70-480d-b728-40881da1a04a
begin
	Slider_a = @bind n_SIR_students_new Slider(5:5:200, default=100, show_value=true)

	Slider_b = @bind initial_SIR_infections_new Slider(5:5:n_SIR_students_new, default=1, show_value=true)

	Slider_c = @bind SIR_days_new Slider(5:200, default=50, show_value=true) 

	Slider_d = @bind recovery_rate_new Slider(0:0.01:1, default=0.1, show_value=true)

	Slider_e = @bind infectiveness_new Slider(0.0:0.01:1, default=0.4, show_value=true)

	Slider_f = @bind resusceptibility_rate Slider(0.0:0.01:1, default=0.01, show_value=true)

	Slider_g = @bind seasonality_frequency Slider(0.0:0.01:1, default=0, show_value=true)

	Slider_h = @bind seasonality_severity Slider(0.0:0.01:1, default=0.5, show_value=true)

	md"""


	Select number of students: $Slider_a

	Select initial number of infections: $Slider_b
	
	Select number of days: $Slider_c

	Select recovery rate: $Slider_d

	Select ineffectiveness: $Slider_e

	Select resusceptibility rate: $Slider_f

	Select seasonality frequency: $Slider_g

	Select seasonality severity: $Slider_h
	
	"""
end

# ╔═╡ e6157ebc-9a21-4089-b05b-3e7010346a05
SIR_hyperparameters_reinfection = Dict( 
	"N" => n_SIR_students_new,
	"I₀" => initial_SIR_infections_new,
	"R₀" => 0, # initial recovered
	"days" => SIR_days_new,
	"p" => infectiveness_new,
	"γ" => recovery_rate_new,
	"r" => resusceptibility_rate,
	"δt" => euler_step,
	"freq" => seasonality_frequency,
	"amp" => seasonality_severity
)

# ╔═╡ c0913933-1048-4d53-a11d-f4bd7e4451c7
plot_SIR_reinfection(SIR_hyperparameters_reinfection)

# ╔═╡ b67296e3-4592-493c-975d-b06ae047ae4f
md"""
### Full stochastic SIR model

- Our ODE above was a mean field approximation, as derived in the lectures
- Here we simulate the full stochastic solution

"""

# ╔═╡ aeb8cb3e-21bf-46de-9eff-c3800a327d88
function run_stochastic_simulation(hyps)
	days = hyps["days"]
	N = hyps["N"]
	SIR = zeros(3, days)
	I0, R0 = hyps["I₀"], hyps["R₀"]
	S0 = hyps["N"] - I0 - R0
	p = hyps["p"]
	γ = hyps["γ"]
	
	SIR[:,1] = [S0, I0, R0]

	infections(i) = rand(Binomial(SIR[1,i-1], p*SIR[2,i-1]/N))
	recoveries(i) = rand(Binomial(SIR[2,i-1], γ))

	function SIR_update(i)
		S,I,R = SIR[:,i-1]
		inf = infections(i)
		rec = recoveries(i)
		S = S - inf
		I = I + inf - rec
		R = R + rec
		return [S,I,R]
	end

	for i in 2:days
		SIR[:,i] = SIR_update(i)
	end
	return SIR
end

# ╔═╡ 6a648e4f-b724-4b07-8212-4dfdc982fda8
question_box(md"""
Explain the two nested functions

`infections(i)` and `recoveries(i)` in the `run_stochastic_simulation` function above
""")

# ╔═╡ c3b62ac1-54ab-4b2d-b568-c4a45de902cd
answer_box(md"""
- `infections(i)` randomly samples the susceptible people from a binomial distribution. Instead of using analytical solutions, it provides us with more realistic randomness (stochasticity).
- `recoveries(i)` randomly samples the infected people in a similar manner to transfer them to the recovered group.
""")

# ╔═╡ 512fd9a4-4585-4471-b194-3977a4dd2a3e
function plot_stochastic_and_ODE_SIR(hyps)
	p = plot_SIR(hyps)
	SIR_stoch = run_stochastic_simulation(hyps)
	scatter!(p, SIR_stoch', labels = ["susceptible" "infected" "recovered"])
end

# ╔═╡ 34c940c7-6e75-4573-b212-ab5510f3731e
plot_stochastic_and_ODE_SIR(SIR_hyperparameters)

# ╔═╡ 632e1b11-1960-4401-98cd-139869f72a7d
tip(md"""
- To repeatedly run the same cell, you can press `shift` + `enter` while the cursor is on the cell. 

- You don't have to manually click play each time!

""")

# ╔═╡ f7befb09-5aa7-4783-94ac-16ae70325fcf
question_box(md"""

- Read the tip above 
- Move the  `plot_stochastic_and_ODE_SIR(SIR_hyperparameters)` cell above so it's next to the associated sliders. 
- Repeatedly run the `plot_stochastic_and_ODE_SIR(SIR_hyperparameters)` cell. You should see the stochastic simulation change. 

1. Can you ever get a qualitatively different behaviour in the stochastic and deterministic models? Look at when the number of initial infections is small, for instance.
2. Is $R_0 <1$ a good indicator that a pandemic can't occur in the stochastic simulation, as for the deterministic? Could we have derived $R_0$ from the stochastic equations, like we did for the deterministic equations?
""")

# ╔═╡ c0d975bd-0e2f-47b2-b195-615a2260e208
answer_box(md"""
1. When we find a repeat where the infections are low at the very start of the simulation, they often stay low for most of the duration. When infections are high, the same might happen with recoveries. However, the final number of infections is relatively stable, and the stochasticity mostly seems to affect how many people got infected, and recovered, over the duration of the simulation.
2. If $R_0<1$, then the number of infections should still keep decreasing. It can momentarily sharply increase, but the infections will go down and the infection spread will die down eventually. The pandemic is therefore still extremely unlikely, but theoretically, it has a non-zero chance of happening.

""")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Distributions = "~0.25.103"
Plots = "~1.39.0"
PlutoTeachingTools = "~0.2.13"
PlutoUI = "~0.7.53"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.3"
manifest_format = "2.0"
project_hash = "19320ff766ecab5d1b462b29cd8442243f625888"

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
git-tree-sha1 = "2dc09997850d68179b69dafb58ae806167a32b1b"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.8"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

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

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "e0af648f0692ec1691b5d094b8724ba1346281cf"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.18.0"

[[deps.ChangesOfVariables]]
deps = ["InverseFunctions", "LinearAlgebra", "Test"]
git-tree-sha1 = "2fba81a302a7be671aefe194f0525ef231104e7f"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.8"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "c0216e792f518b39b22212127d4a84dc31e4e386"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.5"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "cd67fc487743b2f0fd4380d4cbd3a24660d0eec8"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.3"

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
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "8a62af3e248a8c4bad6b32cbbe663ae02275e32c"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.10.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "0.5.2+0"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "8cfa272e8bdedfa88b6aefbbca7c19f1befac519"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.3.0"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c53fc348ca4d40d7b371e71fd52251839080cbc9"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.4"

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

[[deps.DensityInterface]]
deps = ["InverseFunctions", "Test"]
git-tree-sha1 = "80c3e8639e3353e5d2912fb3a1916b8455e2494b"
uuid = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
version = "0.4.0"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["ChainRulesCore", "DensityInterface", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "a6c00f894f24460379cb7136633cef54ac9f6f4a"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.103"

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
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "466d45dc38e15794ec7d5d63ec03d776a9aff36e"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.4+1"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "35f0c0f345bff2c6d636f95fdb136323b5a796ef"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.7.0"

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
git-tree-sha1 = "27442171f28c952804dede8ff72828a96f2bfc1f"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.72.10"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "025d171a2847f616becc0f84c8dc62fe18f0f6dd"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.72.10+0"

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
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "68772f49f54b479fa88ace904f6127f0a3bb2e46"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.12"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "9fb0b890adab1c0a4a475d4210d51f228bfc250d"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.6"

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
git-tree-sha1 = "0592b1810613d1c95eeebcd22dc11fba186c2a57"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.26"

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
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "f428ae552340899a935973270b8d98e5a31c49fe"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.1"

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

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "2da088d113af58221c52828a80378e16be7d037a"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.5.1+1"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "7d6dd4e9212aebaeed356de34ccf262a3cd415aa"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.26"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "c1dd6d7978c12545b4179fb6153b9250c96b0075"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.3"

[[deps.LoweredCodeUtils]]
deps = ["JuliaInterpreter"]
git-tree-sha1 = "60168780555f3e663c536500aa790b6368adc02a"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "2.3.0"

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
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "f512dc13e64e96f703fd92ce617755ee6b5adf0f"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.8"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

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
version = "0.3.20+0"

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
git-tree-sha1 = "cc6e1927ac521b659af340e0ca45828a3ffc748f"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.12+0"

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
version = "10.40.0+0"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "f6f85a2edb9c356b829934ad3caed2ad0ebbfc99"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.29"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "a935806434c9d4c506ba941871b327b96d41f2bf"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.0"

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
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

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
git-tree-sha1 = "db8ec28846dbf846228a32de5a6912c63e2052e3"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.53"

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

[[deps.Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Vulkan_Loader_jll", "Xorg_libSM_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_cursor_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "libinput_jll", "xkbcommon_jll"]
git-tree-sha1 = "37b7bb7aabf9a085e0044307e1717436117f2b3b"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.5.3+1"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "9ebcd48c498668c7fa0e97a9cae873fbee7bfee1"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.9.1"

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
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Revise]]
deps = ["CodeTracking", "Distributed", "FileWatching", "JuliaInterpreter", "LibGit2", "LoweredCodeUtils", "OrderedCollections", "Pkg", "REPL", "Requires", "UUIDs", "Unicode"]
git-tree-sha1 = "a38e7d70267283888bc83911626961f0b8d5966f"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.5.9"

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

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

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
git-tree-sha1 = "5165dfb9fd131cf0c6957a3a7605dede376e7b63"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.0"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "e2cfc4012a19088254b3950b85c3c1d8882d864d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.3.1"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "1d77abd07f617c4868c33d4f5b9e1dbb2643c9cf"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.2"

[[deps.StatsFuns]]
deps = ["ChainRulesCore", "HypergeometricFunctions", "InverseFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "f625d686d5a88bcd2b15cd81f18f98186fdc0c9a"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.3.0"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.1"

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
git-tree-sha1 = "1fbeaaca45801b4ba17c251dd8603ef24801dd84"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.2"

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

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
deps = ["ConstructionBase", "Dates", "InverseFunctions", "LinearAlgebra", "Random"]
git-tree-sha1 = "242982d62ff0d1671e9029b52743062739255c7e"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.18.0"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "e2d817cc500e960fdbafcf988ac8436ba3208bfd"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.3"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Vulkan_Loader_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Wayland_jll", "Xorg_libX11_jll", "Xorg_libXrandr_jll", "xkbcommon_jll"]
git-tree-sha1 = "2f0486047a07670caad3a81a075d2e518acc5c59"
uuid = "a44049a8-05dd-5a78-86c9-5fde0876e88c"
version = "1.3.243+0"

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
git-tree-sha1 = "24b81b59bd35b3c42ab84fa589086e19be919916"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.11.5+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "522b8414d40c4cbbab8dee346ac3a09f9768f25d"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.4.5+0"

[[deps.Xorg_libICE_jll]]
deps = ["Libdl", "Pkg"]
git-tree-sha1 = "e5becd4411063bdcac16be8b66fc2f9f6f1e8fe5"
uuid = "f67eecfb-183a-506d-b269-f58e52b52d7c"
version = "1.0.10+1"

[[deps.Xorg_libSM_jll]]
deps = ["Libdl", "Pkg", "Xorg_libICE_jll"]
git-tree-sha1 = "4a9d9e4c180e1e8119b5ffc224a7b59d3a7f7e18"
uuid = "c834827a-8449-5923-a945-d239c165b7dd"
version = "1.2.3+0"

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

[[deps.Xorg_xcb_util_cursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_jll", "Xorg_xcb_util_renderutil_jll"]
git-tree-sha1 = "04341cb870f29dcd5e39055f895c39d016e18ccd"
uuid = "e920d4aa-a673-5f3a-b3d7-f755a4d47c43"
version = "0.1.4+0"

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
version = "1.2.12+3"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "49ce682769cd5de6c72dcf1b94ed7790cd08974c"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.5+0"

[[deps.eudev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "gperf_jll"]
git-tree-sha1 = "431b678a28ebb559d224c0b6b6d01afce87c51ba"
uuid = "35ca27e7-8b34-5b7f-bca9-bdc33f59eb06"
version = "3.2.9+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "47cf33e62e138b920039e8ff9f9841aafe1b733e"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.35.1+0"

[[deps.gperf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3516a5630f741c9eecb3720b1ec9d8edc3ecc033"
uuid = "1a1c6b14-54f6-533d-8383-74cd7377aa70"
version = "3.1.1+0"

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
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.libevdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "141fe65dc3efabb0b1d5ba74e91f6ad26f84cc22"
uuid = "2db6ffa8-e38f-5e21-84af-90c45d0032cc"
version = "1.11.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libinput_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "eudev_jll", "libevdev_jll", "mtdev_jll"]
git-tree-sha1 = "ad50e5b90f222cfe78aa3d5183a20a12de1322ce"
uuid = "36db933b-70db-51c0-b978-0f229ee0e533"
version = "1.18.0+0"

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

[[deps.mtdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "814e154bdb7be91d78b6802843f76b6ece642f11"
uuid = "009596ad-96f7-51b1-9f1b-5ce2d5e8a71e"
version = "1.1.6+0"

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
# ╟─06dde7a0-8893-11ee-2886-bde88a457045
# ╟─a6edeb63-48ad-4cfe-98b8-4307f9cb2d50
# ╟─a2a023c6-4e92-4c75-8572-d42429293615
# ╟─85a0ff43-cf22-45d9-a474-60c1772154b5
# ╟─a33a63d1-6bed-44a6-b799-2eb590e7b0f3
# ╟─0a416c61-56b2-473b-9cb0-5d02b0226e03
# ╠═ff045d5f-9fcc-4700-abae-cf95109e2e9d
# ╟─c54580ea-63f3-45a8-849c-69b669dad3a2
# ╟─e84f8355-7653-4c16-a2b4-fe39c076aa90
# ╟─38678692-925d-41f2-8c1d-2180b6fd426d
# ╟─6d836878-d1ef-4270-80bb-672c5890bb5f
# ╟─b0d89fb6-f122-416d-8ff1-05262ce0d0ed
# ╠═bc0b1b7a-5dc9-4f60-a3eb-097623b385fe
# ╟─161e0086-46b7-4fa8-aea8-c01594e7e564
# ╠═6431ab2c-c478-437d-b53c-b95dbb21f272
# ╟─33e93bc2-5674-4ff1-9eb1-6d7e0f90862f
# ╟─2ade85d5-8f2a-4dd6-a6b4-e9f87d6a4d10
# ╠═25b4e77f-dd7c-4638-b2c9-5ae8b82be5b5
# ╟─ee30d5dd-a083-41da-b002-f1f40459e8ab
# ╟─8fbb0fab-ea5b-4236-9178-b7b609db60b3
# ╠═ba1f85e5-811d-4860-8b04-a5ceaae55117
# ╠═b71ad838-3da0-4277-af14-49ff4f96ac81
# ╠═0fa785ba-6ea4-4c5f-9bb7-2d9b0ec600ae
# ╠═16d0f28d-5a12-4a75-b19a-232141b2ce13
# ╠═e9de440a-7417-49cb-8891-596d7e2d80ed
# ╟─92de969f-5197-4bd9-9c43-995c9b13f143
# ╟─57b1a4d7-400c-4455-a03c-9ac4d4c768b5
# ╠═31390c3a-65ba-4133-b313-61d5f00ac1f9
# ╟─456de239-2292-487d-a997-c9e60b797540
# ╠═cfde4889-30e6-4999-b25b-c49a1bc26998
# ╠═26f403a8-b13f-43f0-ad5c-a119f908a500
# ╠═49e0bd4d-ed47-437f-9db0-a150b2ab724e
# ╟─6c73e1f3-61ea-4823-8c7b-b8dc0e73341c
# ╠═de348b20-c759-48eb-839a-c398773f51d7
# ╠═decaab6d-c2be-4bc1-b342-2d64e30e6e83
# ╠═40bf0e02-5355-43f3-9dae-43f16849c16e
# ╟─8e07d19f-217d-4a3f-b3ac-038eae645daf
# ╟─078a41ae-2567-437e-93cc-f18a1a3edd04
# ╠═9d1be65e-4a6e-4f1e-85ff-2511411fafb0
# ╠═b6d0c535-6614-430b-81ac-d0fe75a7aaa8
# ╠═0f82229a-6393-4793-b4fa-aa404ac680ae
# ╟─7d71f8b2-42fe-49e2-85e0-33ac189268f0
# ╠═773ef290-7ef3-4e5e-a296-1ca68cf7f673
# ╟─a07437a4-9ab3-4ffe-808f-e5230078c114
# ╠═daf84f8e-3bb6-4ede-9786-b74fb5ac1973
# ╠═177fe419-f5eb-4579-abbc-ef32cca86d5a
# ╟─e56f01b6-6fa5-4f40-a839-1852c4bc0da3
# ╠═6eb04617-e98d-463c-a954-de97c23db0b6
# ╟─77a53a98-cc37-4d09-a805-b09c84326815
# ╟─96c637bb-0460-494e-9e17-39cefd2b787e
# ╟─c953aece-1811-4926-a3dc-f8fe446eacf4
# ╟─121c14bf-5b2c-499b-959c-315197cd18a8
# ╟─14b0994b-c1ee-4e23-8b54-a9ed9cdf2220
# ╟─3140c630-c077-4b6f-82f3-7975dcf75fc6
# ╟─6eac4b22-46de-4baf-82aa-104b007b1c22
# ╟─69cbafd3-50fc-4f1f-b447-b54fb9ed9b1e
# ╟─40a8e3af-6f57-4292-a75a-8c3299f22148
# ╠═7b7f3fe5-658e-45f4-865f-e23f11c674b5
# ╟─b76efc34-a790-4e60-ab4b-06c3816435b4
# ╟─4c752449-b22d-42df-b362-45061ac86f17
# ╠═4e6aa219-1417-48d9-97e7-05ab5dbf0c58
# ╠═9a3fbd66-bf9d-4864-a44c-6522367c7a45
# ╟─f012d075-e41e-4258-945a-044579bc61de
# ╟─647708e0-3e3a-44c7-916c-18262c68fa83
# ╟─952b3da1-9221-4730-801a-239a71bf88f2
# ╟─efa4453a-c445-4481-802b-c6b50f5c438e
# ╟─128e710b-9dd7-4484-9012-b12c62685ade
# ╠═cbd7b28a-83d6-4a2c-aad5-9712835e0cbf
# ╠═96985210-390b-4a11-a3d3-a00e1c77f752
# ╠═e16bb143-a2fd-4da4-8bec-466f286302d4
# ╠═ee9857e5-8755-4321-8360-7a03b2726ef8
# ╠═5d3afbe2-e0de-4db5-b4ec-1faa7d560ad3
# ╠═d45f4a0b-62bc-4633-b02c-ea2e8244a367
# ╠═a59df3b0-b4fe-49d9-8845-1f1cc7665937
# ╠═d1d881e3-f5d0-499d-8b70-0dd00f74e1aa
# ╟─4a73b9ee-3387-4673-892a-b31e688b9652
# ╟─24d3e953-71d6-4180-93a9-b03918f87ffe
# ╟─4df711d0-2224-48c6-bdfc-4cb22530f2ab
# ╠═60a56482-509a-4ffb-beba-7889cd4c73eb
# ╠═550a0763-3313-448e-827a-38c2886fa66c
# ╟─26a338b8-495f-4650-aa58-384784d3cfcb
# ╟─c83bc246-2cd6-41e9-bd4c-790838b4a243
# ╟─d0b7e47f-9243-46dd-b490-e4cc3341e878
# ╟─e6157ebc-9a21-4089-b05b-3e7010346a05
# ╟─7df4c090-3086-49c4-b560-c558d36df7ee
# ╟─a6b56c96-df45-409a-a678-cf6d47c33b5e
# ╟─d1a38411-a967-4ab6-848d-25958c8fe369
# ╟─84b77ae5-7d70-480d-b728-40881da1a04a
# ╠═c0913933-1048-4d53-a11d-f4bd7e4451c7
# ╟─b67296e3-4592-493c-975d-b06ae047ae4f
# ╠═aeb8cb3e-21bf-46de-9eff-c3800a327d88
# ╟─6a648e4f-b724-4b07-8212-4dfdc982fda8
# ╟─c3b62ac1-54ab-4b2d-b568-c4a45de902cd
# ╠═512fd9a4-4585-4471-b194-3977a4dd2a3e
# ╠═34c940c7-6e75-4573-b212-ab5510f3731e
# ╟─632e1b11-1960-4401-98cd-139869f72a7d
# ╟─f7befb09-5aa7-4783-94ac-16ae70325fcf
# ╟─c0d975bd-0e2f-47b2-b195-615a2260e208
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
