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

# ╔═╡ daa98962-37a1-49da-bb80-fcad4eb1e618
md"""# Goals

- You're all busy with assignments. For those of you without a mathematics background, there is a lot of material to cover.

- The point of this notebook is to get more practice in simulating and analysing differential equations. Some of you will use these in your masters projects. **It's less important than the previous notebooks if you're struggling**.

- We're only doing a single type of analysis: *fixed point analysis*...i.e. whether the dynamical system has any equilibria, and whether the dynamical system will eventually reach an equilibrium. More generally, this is known as [stability theory](https://en.wikipedia.org/wiki/Stability_theory).


"""

# ╔═╡ 1bef0312-21bc-48ed-b04e-d672ab8e3dc0
md"""
# Warm up

"""

# ╔═╡ 3bb23b68-5e5d-4683-a631-a9df20e0e548
question_box(md"""
- Turn the following into a first order differential equation (on pen and paper)
$$\dddot{x}(t) = \ddot{x}(t) + 2\dot{x}(t) - x(t)^2$$
""")

# ╔═╡ b7c96f76-dab1-4294-adac-12b2af1f7894
hint(md"""
Take 
-  $x_1(t) = x(t)$
-  $x_2(t) = \dot{x}_1(t)$
-  $x_3(t) = \dot{x}_2(t) = \ddot{x}_1(t)$

""")

# ╔═╡ 9bcd1bf7-d034-49a7-b718-f464fe35daae
md"""
I've copied the `forward_euler_solve` function from last week's notebook below. We will need it. Make sure you still understand it!
"""

# ╔═╡ c4a03602-1f6c-40d0-999b-955872a87645
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



# ╔═╡ c0f0b4f6-74d7-4a69-99ed-4ac488d0aed4
md"""
# Damped oscillator model

![](https://upload.wikimedia.org/wikipedia/commons/e/ea/Simple_Harmonic_Motion_Orbit.gif)


In the lecture, we derived the following equation:

$$m \ddot{x}(t) + c \dot{x}(t) + kx(t) = 0$$

or equivalently

$$m \ddot{x}(t) = -c \dot{x}(t) - kx(t).$$

In the lectures, we showed how we can turn this second order (i.e. two derivatives) Ordinary Differential Equation (ODE) into a first order ODE. **Make sure you can do this for yourself**. Here is the answer, anyway:


$$\begin{bmatrix}
\dot{x}_1(t) \\
\dot{x}_2(t)
\end{bmatrix}

= 

\begin{bmatrix}
0 & 1 \\
-\frac{k}{m} & -\frac{c}{m}
\end{bmatrix}
\begin{bmatrix}
x_1(t) \\
x_2(t)
\end{bmatrix}$$




"""

# ╔═╡ d6e497f1-bff3-4198-8474-85ab2aff3985
question_box(md"""
**Optional, low-priority question**

- Let's consider the undamped case, where $c=0$. The analytical solution is 

$$x(t) = A \sin \left(\sqrt{\frac{k}{m}}t + \phi \right)$$

where $A$ and $\phi$ are constants of integration.

1. Verify the analytical solution for yourself by differentiating it twice:

2. What would be the formula for A and $\phi$, given initial conditions $x(0)$ and $\dot{x}(0)$?


""")

# ╔═╡ b8427915-fcdb-44b0-8cab-4d36f3623b1f
md"""
Now let's simulate it! Make sure you understand the code below. Some people had issues understanding dictionaries last week. They are conceptually the same (and super useful) in Python or Julia. Recall week 2 or just google!
"""

# ╔═╡ bb193440-8b53-459c-b661-8a003f4a3972
mass_spring_hyperparams = Dict("k" => 3, "m" => 1, "c" => 0.1, "p0" => 1, "v0" => 1)

# ╔═╡ 570898c6-6dc8-47c6-94b9-e942793ad899
function build_mass_spring_vf(hyps)
	k,c,m = hyps["k"],  hyps["c"],  hyps["m"]
	function mass_spring_vf(x,t)
			A = [0;-k/m ;; 1;-c/m ]
		return A*x
	end
end

# ╔═╡ c3050726-2895-4e16-bf6b-eee0663e872d
function plot_mass_spring(hyps)
	k,c,m = hyps["k"],  hyps["c"],  hyps["m"]
	p0,v0 = hyps["p0"],  hyps["v0"]
	t0=0
	tend = 10
	tstep = 0.01

	f = build_mass_spring_vf(hyps)
	
	ts, xs = forward_euler_solve(f,[p0,v0], t0,tend,tstep)
plot(ts,xs, label = ["position" "velocity"], legendfontsize=16, linewidth=4)
end

# ╔═╡ dc6c274a-c10f-40d0-8b2f-f0eb5b85a6c3
plot_mass_spring(mass_spring_hyperparams)

# ╔═╡ 57d7c7cb-0df0-4de8-95d9-6d1d906592c7
question_box(md"""
Change the timestep of the Forward Euler approximation to $0.1$. What happens? What does this tell you about the dangers of numerical error when using Forward Euler?
""")

# ╔═╡ bcef92e4-5033-44f9-9649-43823b0eab75
md"""
## Stability of the damped oscillator model

Recall the lectures. The ODE is of the form

$$\dot{x}(t) = Ax(t)$$

where $A$ is a matrix that can depend on (unchanging) parameters but not (time varying) states. Indeed

$$A = \begin{bmatrix}
0 & 1 \\
-\frac{k}{m} & -\frac{c}{m}
\end{bmatrix}$$.

Stability requires that all the real part of all eigenvalues is less than zero. If the eigenvalues are real numbers (no imaginary component), this just means they are less than zero. 


Technically (if you're interested), such a matrix is called a [Hurwitz stable matrix](https://en.wikipedia.org/wiki/Hurwitz_matrix#Hurwitz_stable_matrices).

"""

# ╔═╡ b9466c49-11bf-43e6-a867-4bd1b6b9393b
tip(md"""

**Just for fun, skip if you're in a hurry**...

- Engineers often build dynamical models of mechanical systems, e.g. the flight angle of a cruising aeroplane
- These models are usually linear ($\dot{x}(t) = Ax(t)$). Just like for our damped oscillator, one balances the forces, and writes a differential equation by evaluating the forces. Of course, they have many more states. Not just position and velocity, but the state of e.g. individual actuators and components on the plane. (e.g. see [page 2 here](https://books.google.co.uk/books?hl=en&lr=&id=xvMQAQAAIAAJ&oi=fnd&pg=PA1&dq=f16+stability&ots=CA9Gtuxquh&sig=bAmzv5X2P022qwY53TZ3c-fWgdQ#v=onepage&q=f16%20stability&f=false))
- They then have to design stabilisation systems. Mathematically, this means designing the flight control systems so that the $A$ matrix above is Hurwitz-stable. In other words, a small perturbation from e.g. a wind gust perturbs the plane, but the dynamics settle back to a fixed poing (e.g. a particular angle of attack)


- Some fighter planes are deliberately unstable. This requires a sophisticated control system and/or pilot, but gives greater maneouverability.

- As something of a pacifist, I urge you to not start designing fighter planes, even though the modelling and design are cool

""")

# ╔═╡ 781fc66e-f1c7-42f1-b9fe-a0cd9238a94b
question_box(md"""

**If you're finding things hard, it might be worth coming back to this question after you've gone through the SIRL model**

Explain why the system will always be stable, regardless of the (physically plausible) values of $k$, $c$, and $m$. How?...

1. Use the fact that the trace of a matrix is the sum of its eigenvalues ($\lambda_1 + \lambda_2)$, and the determinant is the product of its eigenvalues ($\lambda_1 \times \lambda_2$), and is always real. 
2. Use the sign (i.e. negative vs positive) of the trace and determinant to say something about the $A$ matrix.

3. Can you provide a non-physically-plausible parameter value for $k$, $c$, and $m$ that make the system unstable (i.e. eigenvalues have positive real component)? How did you find it?

4. Can you set the parameters so that the real part of the eigenvalues is exactly zero? What happens to the behaviour of the system?

""")

# ╔═╡ 647708e0-3e3a-44c7-916c-18262c68fa83
md"""
# SIRL model: 

## Simulating the model


Recall that 

-  $S$ is susceptible (healthy, previously uninfected people)
-  $I$ is currently infected people
-  $R$ is recovered people

From the lecture, the original SIR model was

$$\dot{S}(t) = -p\frac{S(t)I(t)}{N}$$

$$\dot{I}(t) = p\frac{S(t)I(t)}{N} - \gamma I(t)$$

$$\dot{R}(t) = \gamma I(t)$$

This has a single fixed point (equilibrium). You should be able to see what it is without referring to the lectures.

We then wanted to extend the model to account for recovered people regaining susceptibility to the virus. Therefore, we made a new model:

$$\begin{align}
& \dot{S}(t) =  - p \frac{S(t)  I(t)}{N}  & &+  qR(t) & \\
& \dot{I}(t) =   p \frac{S(t)  I(t)}{N} - &\gamma I(t) \\
& \dot{R}(t) = & \gamma I(t) &-qR(t)
\end{align}$$

- There is a new parameter $q$: the resusceptibility rate by which recovered people become susceptible again.

We then **reduced** the SIR model so it only has two states. How? Note that 

$$S(t) + I(t) + R(t) = N$$

Therefore, we can figure out $S(t)$ without solving a differential equation, if we have access to $I(t)$ and $R(t)$. This allowed us to reformulate the differential equation, substituting $S(t) = N - I(t) - R(t)$. *We can do the same for the SIRL model!*

We get

$$\begin{align}
 \dot{I}(t) &=   \frac{ p I(t)}{N}\big(N - I(t) - R(t) \big) - \gamma I(t) \\
\dot{R}(t) &=  \gamma I(t) -qR(t)
\end{align}$$ 


"""

# ╔═╡ 128e710b-9dd7-4484-9012-b12c62685ade
md"""

Let's simulate the model:

1. We code up the vector field above (see `build_SIRL_dynamics` below). 
2. We derive the initial conditions from the hyperparameters (see `build_initial_conditions` below)
3. We add parameters as a dictionary with slideable values (see the sliders and `SIRL_hyperparameters` below)
4. We build a `plot_SIRL` function that simulates and then plots the output.

Make sure you understand how this code works, and could do it yourself if necessary. **The code structure is exactly the same as for the SIR model in last week's notebook. Just with a slightly different model**
"""

# ╔═╡ cbd7b28a-83d6-4a2c-aad5-9712835e0cbf
## the 'factory' function
function build_SIRL_dynamics(hyps)    
    p, γ, N = [hyps[el] for el in ["p", "γ", "N"]]
	q = hyps["q"]
	
    function SIRL_dynamics(x,t)
		I,R= x # x is a 2-vector, so this puts its elements into I and R
        S = N - I - R
		return [p*S*I/N - γ*I,γ*I - q*R ]
	end
    return SIRL_dynamics
end

# ╔═╡ 24d3e953-71d6-4180-93a9-b03918f87ffe
function build_initial_conditions(hyperparameters)
    S0 = hyperparameters["N"] - hyperparameters["I₀"] - hyperparameters["R₀"]
    I0, R0 = [hyperparameters[el] for el in ["I₀", "R₀"]]
    return [I0, R0]
end

# ╔═╡ e16bb143-a2fd-4da4-8bec-466f286302d4
@bind n_students Slider(5:5:200, default=100, show_value=true)

# ╔═╡ ee9857e5-8755-4321-8360-7a03b2726ef8
@bind I0 Slider(0:n_students, default=35, show_value=true)

# ╔═╡ c2ee8fe6-5fcb-4146-8ddd-dfb0b7694082
@bind R0 Slider(0:5:n_students, default=1, show_value=true)

# ╔═╡ 5d3afbe2-e0de-4db5-b4ec-1faa7d560ad3
@bind days Slider(5:200, default=100, show_value=true) 

# ╔═╡ d45f4a0b-62bc-4633-b02c-ea2e8244a367
@bind recovery_rate Slider(0:0.01:2, default=0.6, show_value=true)

# ╔═╡ a59df3b0-b4fe-49d9-8845-1f1cc7665937
@bind infectiveness Slider(0.0:0.01:5, default=2, show_value=true)

# ╔═╡ d1d881e3-f5d0-499d-8b70-0dd00f74e1aa

@bind euler_step Slider(10.0 .^(-4:2), default=1e-1, show_value=true )

# ╔═╡ 11e4b139-6be9-4dc7-a5bb-8231cb772672
@bind resusceptibility_rate Slider(0:0.002:0.2, default = 0.02, show_value=true)

# ╔═╡ 96985210-390b-4a11-a3d3-a00e1c77f752
SIRL_hyperparameters = Dict( 
	"N" => n_students,
	"I₀" => I0,
	"R₀" =>  R0,
	"days" => days,
	"p" => infectiveness,
	"γ" => recovery_rate,
	"δt" => euler_step,
	"q" => resusceptibility_rate
)


# ╔═╡ 60a56482-509a-4ffb-beba-7889cd4c73eb
function plot_SIRL(hyps)
	# run simulation
	ts, xs = forward_euler_solve(
		build_SIRL_dynamics(hyps), 
		build_initial_conditions(hyps),
		0,
		hyps["days"],
		hyps["δt"]
)
	# what's going on here?
	xs = hcat(hyps["N"] .- xs[:,1] .- xs[:,2], xs )
	
	return plot(ts, xs, label=["susceptible" "infected" "recovered"], linewidth=4, legendfontsize=14)
	
end

# ╔═╡ 550a0763-3313-448e-827a-38c2886fa66c
plot_SIRL(SIRL_hyperparameters)

# ╔═╡ e4b6f6b8-220b-48c9-a141-6f129bd8b140
question_box(md"""
1. Explain how the plot shows the number of susceptible people, even though this wasn't in the differential equation

2. Explain verbally (not mathematically) why the model shows bumps of reinfection
""")

# ╔═╡ 6a648e4f-b724-4b07-8212-4dfdc982fda8
question_box(md"""

Refer to the previous week's notebook to build a stochastic simulation of the SIRL model, where infection, recovery, and resusceptibility of relevant people are modelled as Bernoulli (true/false) random variables that occur once per day. 

*Remember that we already did this for the SIR model!*
""")

# ╔═╡ 6007373f-e961-4d9a-9db9-dff8529c24bf
md"""
## Stability of the SIRL model


What's the long term behaviour of the SIRL model? Are there parameter values for which we get endless cycles of epidemics? Or do we always settle to a fixed point? 

1. We could simulate. But we would need to simulate for all conditions and parameter values to be sure. This is impossible: we can only choose particular parameter values. Even if we choose a grid of parameter values and ignore intermediate values (e.g. like picture below), we will suffer from the [curse of dimensionality](https://en.wikipedia.org/wiki/Curse_of_dimensionality#Sampling), and need huge numbers of simulations as the number of parameters increase.

![](https://cofactorgenomics.com/wp-content/uploads/2019/04/picture1.png)

2. We could draw a phase portrait to get slightly better intuition. Let's do that! We'll see below how this gives us a good idea as to the fixed point and its stability *(and we get some optional plotting practice in)*


3. We could do it mathematically. But we'll leave that until after we have drawn the phase portrait!

"""

# ╔═╡ 8ebfa3b5-f6b1-449d-8d0f-e1d52600b764
md"""
### ...through phase portraits

I've written code for drawing quiver plots below. You don't **need** to understand the code in detail. But it's useful: getting good at plotting things is a great skill to practise. I've purposely matched the syntax to Python. **If you're time pressured, just skip to the plot itself, and ignore how I drew it**
"""

# ╔═╡ 032b60df-c8a1-406e-9806-e11a73f701bb
"""
This replicates the `np.meshgrid` function in numpy (python), which you can google for further info (eg [here](https://www.sharpsightlabs.com/blog/numpy-meshgrid/). It makes a grid of (x,y) values on which we will draw the vector field of the SIRL model.
"""
function meshgrid(rangex, rangey)
	X = rangex' .* ones(length(rangey))
	Y = rangey .* ones(length(rangex))'
	return X,Y
end

# ╔═╡ 12518bb2-40b7-4dfc-bb55-074140767690
meshgrid(-1:0.5:1.5, -2:1:2) #arbitrary example

# ╔═╡ 50ee85e6-ec69-4167-b7bf-718c36c402af
md"""

- We can use `meshgrid` to make the grid of points for which we draw the arrows of our vector field. **However** we are only interested in points where $I + R < N$ (**you should be able to tell me why**)

- So let's make a filtering function that gets rid of other points on the grid! Again, good coding practise to understand or try for yourself:

"""

# ╔═╡ 34781c4d-3a39-4c73-a49c-4822b248d36c
"""
Returns the original matrices (reshaped), removing entries where the sum of the matrices is more than N, the total number of students
"""
function filtergrid(g1, g2, hyps)
	h = g1 + g2
	return g1[h .<= hyps["N"]], g2[h .<= hyps["N"]]
end

# ╔═╡ da721ad8-8696-4882-a7d6-bd7e099476cc
md"""
- Now we can draw the quiver plot! We provide the grid of points to draw arrows on, and a function `f(x,y)` that takes the $i^{th}$ value from each grid, and outputs the 2d vector to draw at that point

- first we need to build this function `f(x,y)`. We already built a vector field `SRvf(x,t)`, where `x` is a 2-vector representing the state (infections, recoveries), and `t` is time. We modify it below to remove time, and to take two separate arguments, instead of one vector of two arguments.
"""

# ╔═╡ ea22e1a1-27b0-4350-92fc-75724c159616
SRvf = build_SIRL_dynamics(SIRL_hyperparameters)

# ╔═╡ aa46b504-2b5a-42a2-91e7-1f3bd4b0ac37
SRvf2(x,y) = SRvf([x,y],0)

# ╔═╡ 98cfe075-22af-4786-a312-27924f0f65e7
md"""

- `quiver` plots are useful for plotting vector fields on a meshgrid of points. `plt.quiver` in python using matplotlib.pyplot. 

- Play with the sliders to change the grid on which it is drawn

- I've overlaid the quiver plot with an actual simulation (plotted previously), for a particular number of initial infections and recoveries (see `plot_ode_and_quiver` below)

- I've made a **new dictionary of parameters** below. Same as before, but with new sliders for $I0$ and $R0$. Just so you can tweak them below. Storing parameters in dictionaries is useful! (similarly in python)
"""

# ╔═╡ 18869172-ac26-4337-831d-e08efb940238
md"""

x lower bound
$(@bind x_lb Slider(1:5:60, show_value=true, default=1))

x upper bound
$(@bind x_ub Slider(20:5:100, show_value=true, default=55))

ylower bound
$(@bind y_lb Slider(1:5:60, show_value=true, default=1))

y upper bound
$(@bind y_ub Slider(5:5:100, show_value=true, default=100))

arrow spacing
$(@bind arrow_spacing Slider(2:10, show_value=true, default=5))

Arrow length
$(@bind arrow_size Slider(0.01:0.01:1, show_value=true, default=0.6))

New initial infections
$(@bind new_I0 Slider(1:100, show_value=true))

New initial recoveries
$(@bind new_R0 Slider(1:100, show_value=true))
"""

# ╔═╡ ba079c3b-0ca4-41e4-acd3-dab67e3c64d6
XGrid, YGrid = filtergrid(meshgrid(x_lb:arrow_spacing:x_ub, y_lb:arrow_spacing:y_ub)..., SIRL_hyperparameters)

# ╔═╡ 284d8768-227e-46a0-86dc-5cfa111b6c59
begin
	new_SIRL_hyperparameters = deepcopy(SIRL_hyperparameters)
	new_SIRL_hyperparameters["I₀"] = new_I0
	new_SIRL_hyperparameters["R₀"] = new_R0
end

# ╔═╡ c913964a-773b-43f3-9ab3-ba504557cd48
function plot_ode_and_quiver(hyps)
# run simulation
	ts, xs = forward_euler_solve(
		build_SIRL_dynamics(hyps), 
		build_initial_conditions(hyps),
		0,
		hyps["days"],
		hyps["δt"]
)
	p = plot(xs[:,1],xs[:,2], linewidth=3, label = "single simulation")

	# draw the grid of arrows, independently of simulation
	quiver!(p, XGrid, YGrid,quiver=(x,y) -> arrow_size*SRvf2(x,y), linecolor=:black, xlabel = "Infections", ylabel = "Recoveries")
end

# ╔═╡ c4e6a9bc-0dcc-49d7-a022-ce31329e8ab2
plot_ode_and_quiver(new_SIRL_hyperparameters) # see function code below

# ╔═╡ 22ff59b5-8e4a-4bd8-9297-8d1e49adc30a
question_box(md"""

*remember that the magnitude of the arrows is proportional to the magnitude of the vector field: how fast the dynamical system is changing*

- Recall that the $R_0$ value is $\frac{p}{\gamma}$. What is qualitatively different about the phase portrait when $R_0 > 1$ vs when it is $<1$? Why? What does this suggest about stability?

- What initial number of infections and recoveries (roughly) would take the longest time to reach the fixed point? Can you change the sliders for initial infections and recoveries at the top of the notebook to these values?

""")

# ╔═╡ 2967ae74-5a5c-4a75-8ddc-506994ccee8a
md"""
...through mathematical analysis


1. We will **linearise** the system: make a linear approximation of the dynamical system close to the fixed point.

2. We will show that the fixed point of this linear approximation is stable (i.e. it attracts). 

You have to trust me that if the linear approximation is stable, then it's mathematically proven that the actual fixed point is stable (for small enough perturbations)! If you don't trust me, read the wikipedia page on the [Hartmann Grobmann theorem](https://en.wikipedia.org/wiki/Hartman%E2%80%93Grobman_theorem) that proves it.

We have a nonlinear dynamical system of the form $\dot{x}(t) = f(x(t))$, where $x(t) = [I(t), R(t)]$, and $f(x(t))$ is

$$\begin{align}
 \dot{I}(t) &=   \frac{ p I(t)}{N}\big(N - I(t) - R(t) \big) - \gamma I(t) \\
\dot{R}(t) &=  \gamma I(t) -qR(t)
\end{align}$$ 


Suppose $x(t) = x^* + \delta x(t)$, where $x^*$ is the fixed point and $\delta x(t)$ is a small perturbation. Will $\delta x(t)$ converge to the fixed point?

$$
\begin{align}
\dot{\delta x}(t) &= f(x^* + \delta x(t)) \\
&\approx f(x^*) + \Big[\frac{\partial f}{\partial x}(x^*) \Big] \delta x(t)
\end{align}
$$
where the approximation above comes from the finite difference approximation.


$$
\Big[\frac{\partial f}{\partial x}(x^*) \Big] \delta x(t) \approx f(x^* + \delta x(t)) - f(x^*)
$$

- Now, $\dot{\delta x}(t)  = \Big[\frac{\partial f}{\partial x}(x^*) \Big] \delta x(t)$     is a linear system!!!


So we can just check that its eigenvalues have negative real part, like for the damped oscillator model.


Our first step is to get the derivative matrix $$\frac{\partial f}{\partial x}(x)$$. We will drop the explicit dependence on $t$ for convenience.

$$\frac{\partial f}{\partial x}(x) = 
\begin{bmatrix}
\frac{\partial \dot{I}}{\partial I} & \frac{\partial \dot{I}}{\partial R} \\
\frac{\partial \dot{R}}{\partial I} & \frac{\partial \dot{R}}{\partial R}
\end{bmatrix}$$

**Try and differentiate this for yourself.** Either way, here is the answer:

$$
\frac{\partial f}{\partial x}(x) =
\begin{bmatrix}
\frac{p}{N}(N - 2I - R) - \gamma & \frac{-pI}{N} \\
\gamma & -q
\end{bmatrix}$$

"""

# ╔═╡ 7f4e7deb-d9f9-4162-b3e8-07e6479e2abe
md"""

We now have to evaluate this matrix at the fixed point $x^*$, where $\dot{x}(t) = 0$ 

(i.e. the values $I^*$ and $R^*$ where $\dot{I}(t) = \dot{R}(t)=0$).





"""

# ╔═╡ 9b9485f6-13e0-4470-a1af-ad10bed2bec2
question_box(md"""

Verify for yourself that

-  $S^* = \frac{N \gamma}{p}$ (this needs the full, three-state differential equation we had at the beginning)
-  $R^* = \frac{\gamma}{q} I^*$
Hence, since $N = S^* + I^* + R^*$: 
-  $I^* = (N - S^*)/(1+ \frac{γ}{q})$



""")

# ╔═╡ c0e3273f-a2fc-4917-9b30-7063571d653e
md"""
We now need to substitute these values into the derivative matrix. This is time consuming to do by hand. I've done it for you. 




$$\frac{\partial f}{\partial x} =  \begin{equation}
\left[
\begin{array}{cc}
\frac{ - p q + q \gamma}{q + \gamma} & \frac{\left(  - p + \gamma \right) q}{q + \gamma} \\
\gamma &  - q \\
\end{array}
\right]
\end{equation}$$


"""

# ╔═╡ b1e31e1b-5e34-4e6b-9ca9-d74508dbfc47
tip(md"""
I didn't do it by hand!!!! There is an extra pluto notebook attached to the [lectures](https://algorithmic-approaches-to-mathematics.github.io/lectures/all_lectures/) page of the website that shows how I used Julia to do these calculations for me. This is useful to look at if you want Julia/Python to do your pen-and-paper maths for you (and copy paste it as $\LaTeX$ code)
""")

# ╔═╡ 8046330e-3b1b-4a91-9304-c174e840af48
md"""
We can also calculate the trace and determinant (again, see how I did it on a computer without pen and paper on the extra pluto notebook)

$$\begin{equation}
Tr(\frac{\partial f}{\partial x}) = \frac{ - p q - q^{2}}{q + \gamma}
\end{equation}$$

$$\det(\frac{\partial f}{\partial x}) = \begin{equation}
p q - q \gamma
\end{equation}$$


"""

# ╔═╡ d5647e7e-39f0-41f1-a4de-7b5e33efded7
question_box(md"""
What are the conditions on the parameters for both eigenvalues to be negative? Is this counterintuitive?
""")

# ╔═╡ b42c7492-31a9-48e9-b379-f96861cdac57
hint(md"""

- Weirdly, we need $p(q - \gamma)$ to be positive for the fixed point to be stable. In other words, we need the infection rate to be **higher** than the recovery rate. 

- Why? I hypothesise the following. Bonus points if you can verify/disprove!


1. Remember the steady state has nonzero values for $S$, $I$ and $R$. 

2. Suppose we did a small perturbation proportional to $[1, 0, -1]$ for $S,I,R$. 

3. Stability requires the system immediately moves back to the original fixed point. But if infectivity is low relative to recovery, then the increased flow from $S \to I$ (more susceptibles) is outcompeted by the increased flow from $I \to R$. So infections transiently decrease, and this decrease is fast enough to transiently move the system further away from the equilibrium.
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

julia_version = "1.9.0"
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
weakdeps = ["SpecialFunctions"]

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Compat]]
deps = ["UUIDs"]
git-tree-sha1 = "8a62af3e248a8c4bad6b32cbbe663ae02275e32c"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.10.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.2+0"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "8cfa272e8bdedfa88b6aefbbca7c19f1befac519"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.3.0"

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
deps = ["FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns"]
git-tree-sha1 = "a6c00f894f24460379cb7136633cef54ac9f6f4a"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.103"

    [deps.Distributions.extensions]
    DistributionsChainRulesCoreExt = "ChainRulesCore"
    DistributionsDensityInterfaceExt = "DensityInterface"
    DistributionsTestExt = "Test"

    [deps.Distributions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DensityInterface = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
    Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

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
deps = ["LinearAlgebra", "Random"]
git-tree-sha1 = "35f0c0f345bff2c6d636f95fdb136323b5a796ef"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.7.0"
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
version = "2.28.2+0"

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
version = "10.42.0+0"

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
git-tree-sha1 = "1d77abd07f617c4868c33d4f5b9e1dbb2643c9cf"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.2"

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
git-tree-sha1 = "1fbeaaca45801b4ba17c251dd8603ef24801dd84"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.2"
weakdeps = ["Random", "Test"]

    [deps.TranscodingStreams.extensions]
    TestExt = ["Test", "Random"]

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
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "242982d62ff0d1671e9029b52743062739255c7e"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.18.0"

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
version = "1.2.13+0"

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
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.7.0+0"

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
# ╠═06dde7a0-8893-11ee-2886-bde88a457045
# ╟─a6edeb63-48ad-4cfe-98b8-4307f9cb2d50
# ╟─daa98962-37a1-49da-bb80-fcad4eb1e618
# ╟─1bef0312-21bc-48ed-b04e-d672ab8e3dc0
# ╟─3bb23b68-5e5d-4683-a631-a9df20e0e548
# ╟─b7c96f76-dab1-4294-adac-12b2af1f7894
# ╟─9bcd1bf7-d034-49a7-b718-f464fe35daae
# ╟─c4a03602-1f6c-40d0-999b-955872a87645
# ╟─c0f0b4f6-74d7-4a69-99ed-4ac488d0aed4
# ╟─d6e497f1-bff3-4198-8474-85ab2aff3985
# ╟─b8427915-fcdb-44b0-8cab-4d36f3623b1f
# ╠═bb193440-8b53-459c-b661-8a003f4a3972
# ╠═570898c6-6dc8-47c6-94b9-e942793ad899
# ╠═c3050726-2895-4e16-bf6b-eee0663e872d
# ╠═dc6c274a-c10f-40d0-8b2f-f0eb5b85a6c3
# ╟─57d7c7cb-0df0-4de8-95d9-6d1d906592c7
# ╟─bcef92e4-5033-44f9-9649-43823b0eab75
# ╟─b9466c49-11bf-43e6-a867-4bd1b6b9393b
# ╟─781fc66e-f1c7-42f1-b9fe-a0cd9238a94b
# ╟─647708e0-3e3a-44c7-916c-18262c68fa83
# ╟─128e710b-9dd7-4484-9012-b12c62685ade
# ╠═cbd7b28a-83d6-4a2c-aad5-9712835e0cbf
# ╠═24d3e953-71d6-4180-93a9-b03918f87ffe
# ╠═96985210-390b-4a11-a3d3-a00e1c77f752
# ╠═e16bb143-a2fd-4da4-8bec-466f286302d4
# ╠═ee9857e5-8755-4321-8360-7a03b2726ef8
# ╠═c2ee8fe6-5fcb-4146-8ddd-dfb0b7694082
# ╠═5d3afbe2-e0de-4db5-b4ec-1faa7d560ad3
# ╠═d45f4a0b-62bc-4633-b02c-ea2e8244a367
# ╠═a59df3b0-b4fe-49d9-8845-1f1cc7665937
# ╠═d1d881e3-f5d0-499d-8b70-0dd00f74e1aa
# ╠═11e4b139-6be9-4dc7-a5bb-8231cb772672
# ╠═60a56482-509a-4ffb-beba-7889cd4c73eb
# ╠═550a0763-3313-448e-827a-38c2886fa66c
# ╟─e4b6f6b8-220b-48c9-a141-6f129bd8b140
# ╟─6a648e4f-b724-4b07-8212-4dfdc982fda8
# ╟─6007373f-e961-4d9a-9db9-dff8529c24bf
# ╟─8ebfa3b5-f6b1-449d-8d0f-e1d52600b764
# ╠═032b60df-c8a1-406e-9806-e11a73f701bb
# ╠═12518bb2-40b7-4dfc-bb55-074140767690
# ╟─50ee85e6-ec69-4167-b7bf-718c36c402af
# ╠═34781c4d-3a39-4c73-a49c-4822b248d36c
# ╟─da721ad8-8696-4882-a7d6-bd7e099476cc
# ╠═ea22e1a1-27b0-4350-92fc-75724c159616
# ╠═aa46b504-2b5a-42a2-91e7-1f3bd4b0ac37
# ╠═ba079c3b-0ca4-41e4-acd3-dab67e3c64d6
# ╟─98cfe075-22af-4786-a312-27924f0f65e7
# ╠═284d8768-227e-46a0-86dc-5cfa111b6c59
# ╟─18869172-ac26-4337-831d-e08efb940238
# ╠═c4e6a9bc-0dcc-49d7-a022-ce31329e8ab2
# ╠═c913964a-773b-43f3-9ab3-ba504557cd48
# ╟─22ff59b5-8e4a-4bd8-9297-8d1e49adc30a
# ╟─2967ae74-5a5c-4a75-8ddc-506994ccee8a
# ╟─7f4e7deb-d9f9-4162-b3e8-07e6479e2abe
# ╟─9b9485f6-13e0-4470-a1af-ad10bed2bec2
# ╟─c0e3273f-a2fc-4917-9b30-7063571d653e
# ╟─b1e31e1b-5e34-4e6b-9ca9-d74508dbfc47
# ╟─8046330e-3b1b-4a91-9304-c174e840af48
# ╟─d5647e7e-39f0-41f1-a4de-7b5e33efded7
# ╟─b42c7492-31a9-48e9-b379-f96861cdac57
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
