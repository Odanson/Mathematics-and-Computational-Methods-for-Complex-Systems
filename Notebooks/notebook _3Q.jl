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

# ╔═╡ 227137e6-21c4-11ee-0fe8-0fa474726fab
using PlutoUI, PlutoTeachingTools, Colors, ColorVectorSpace, LinearAlgebra, Images, Luxor

# ╔═╡ ccf5ef1b-6341-43fb-9cb7-5743b034fbd5
md"# Introduction to Linear Algebra"

# ╔═╡ 2ec75628-1d65-4f38-ac5c-53168286b3f0
PlutoUI.TableOfContents()

# ╔═╡ aa5a077d-552e-4922-a5ac-cf8607f0781d
begin
	url = "https://upload.wikimedia.org/wikipedia/commons/thumb/b/bf/Anas_platyrhynchos_male_female_quadrat.jpg/800px-Anas_platyrhynchos_male_female_quadrat.jpg"
	path = "data/duck.jpg"
	url_jack = "https://thesaurus.plus/img/synonyms/186/jack-of-all-trades.png"
	path_jack = "jack.png"
	url_pic = "https://upload.wikimedia.org/wikipedia/commons/2/29/20090211_thousand_words-01.jpg"
	path_pic = "snoopy.jpg"
end;

# ╔═╡ 82850d96-02f9-4825-bcf0-84af3a039f89
md"""
# All about matrices 
Also known as *2-tensors* (see last notebook)


Here are examples of two matrices:
"""

# ╔═╡ 7bcd2490-3543-4e6a-9e53-df37783b52ea
A = [1;4;;5;7]

# ╔═╡ 1bc03f27-fbc6-442f-9132-367680897a21
md"""
- As we said last week, "*matrix*" means 2-tensor. 
- So **all** matrices have dimension 2: their elements can be referred to with two indices (rows and columns).

Different matrices have different **sizes**
"""

# ╔═╡ 11f93907-9037-4d15-ac6e-d2b00dbe039e
tip(md"""
Dimension and size are often used interchangeably! One person might say a $4 \times 3$ matrix has **dimension** $4$ by $3$. Another person (us/you) will say that all matrices have **dimension 2**, and **size** $4 \times 3$. 

Just note the potential for confusion!
""")

# ╔═╡ b385d533-0775-4693-b2d2-eaddcaba22b7
A[1,2]

# ╔═╡ 1837a32f-378a-4e47-a8bb-5229a074d2b8
size(A)

# ╔═╡ 1c848b46-6ea8-44a3-84d4-2619f724375e
question_box(md"""
- Use the `size` function to work out the sizes of `A` and `_A`. 
- Use your result to write a sentence or two about what the size of a matrix refers to, and whether it is distinct from dimension. 
- Build a 4-tensor (look at last week's notebook to remember how). What is the relationship between `size(A)` and the dimension of `A`, for any array `A`?
- Look up the `reshape` function. Use this to build a 1-tensor, $C$, that has the same elements as $A$, but in a different order. What aspect of `size(A)` is **invariant** to reshaping?
""")

# ╔═╡ aa8d4c23-7a89-40d7-a4ba-1ce53079ba2e
md"""
$(RobustLocalResource(url_jack, path_jack, :width=>600, :alt=>"hi") |> aside)
## What are they good for?
#### (Absolutely everything)

"""

# ╔═╡ d08d299c-71bd-4620-86f0-ececd359ef11
md"""
### 1. Storing data

Many of the courses you will do this year boil down to...
"""

# ╔═╡ ea4e38c4-b8fc-44f4-bdd3-4dc9d64960d3
blockquote("Doing transformations on data.")

# ╔═╡ 3b9dd93c-10d9-4471-aaeb-111384678b80
md"""
Let's be a bit more specific. Data can vary across lots of different dimensions, although space and/or time are common. (the word is spatiotemporally varying)

EG

- **Number of COVID infections each day** (spatial if measured in multiple places, temporal)
- **Images** (e.g. from an [MRI scan](https://en.wikipedia.org/wiki/Magnetic_resonance_imaging)). Adding a temporal component makes it a video.
- **Credit card scores** (varies across people, and time)

What do you do with this data?

- **Make decisions** (e.g. impose a lockdown)
- **Summarise** (e.g. by likelihood of an MRI scan including a cancerous tumour)
- **Predict** (what's the probability this person will default on their debt?)
- **Visualise** 
$(RobustLocalResource(url_pic, path_pic, :width=>600, :alt=>"hi") |> aside)

All of these actions require some computational model that **transforms** the data. EG 

- A model that predicts consequences of different lockdown options, and can be [**optimised**](https://en.wikipedia.org/wiki/Mathematical_optimization) to find the option with the best consequences. *(you're going to be doing a **lot** of optimisation!*)
- A classifier that bins MRI images as *cancerous* or *non-cancerous*
- A quantitative model that emits a probability of credit-card default, given somebody's personal data. *(please don't put your skills to bad use in your jobs next year!)*

In summary:

Raw input -> Stored data (e.g. as matrix) -> Preprocessing -> Computational model -> Output

As you progress in the year, you will see that each of these stages corresponds to a transformation of data. 
- Data is often represented in matrices
- We'll soon find out that even **transformations** are often represented as matrices.
"""

# ╔═╡ 3245a69d-0b94-4291-ae1a-fac2d66325eb
tip(md""" 
In real life (and sometimes in university courses). **There is no correct answer!** Too many years of jumping through loopholes for exams in school can induced a kind of [learned helplessness](https://en.wikipedia.org/wiki/Learned_helplessness) in these scenarios. Don't be that person! Make an educated guess. Justify it. Think, don't just google.
""") |> aside

# ╔═╡ d4c4f68a-2b3e-4452-ac78-a3455da6f5f2
question_box(md"""
What dimension of tensor would best store my data in the following cases? Why?

1. A database holding peoples' names, ages, job titles, and hometowns. 

2. Measurement of the diffusion of an inkdrop in a jug of water

3. A movie
""")

# ╔═╡ e1614adb-8978-488f-828b-f6326c523713
md"""
### 2. Images are matrices

The purpose of this subsection is to
- get you some practice at working with matrices
- cement into you the principle of storing lots of data types as matrices 
- preparation for the subsequent concept of a **vector space**

We are going to consider [digital raster images](https://en.wikipedia.org/wiki/Raster_graphics). These are images represented as a matrix of pixels. Each pixel holds a colour.
"""

# ╔═╡ a538110d-6e14-4589-8301-2e9b08814c88
question_box(md"""

**This is a less structured question. You will need to use the live docs, and potentially google, a bit more heavily. This is good practise for real life!**

1. Find a png image off the internet. Or just keep the photo of the seagull boyband I found (see a few cells below). Or even more alternatively use the webcam to get an image of yourself (see cell below).

2. You will note that the image is a matrix. Previously, we have seen matrices whose elements are numbers. What is the `eltype` (type of the elements) of the matrix storing the image? What are the fields? What do they represent?

3. Make functions that take in an image (e.g. the seagulls) that do the following:
	
- Invert the image: send every RGB value $(x,y,z)$ to $(1 - x, 1 - y, 1-z)$
- Flip the image. When provided with the keyword argument `:tb`, it should do a top-to-bottom flip. `:lr` should do a left-to-right flip.
- Crop the right-half of the image
""")

# ╔═╡ 47fb2828-a963-41ec-a891-37c613c70b18
tip(md"""
Individual elements of the image array will show as colours. Prepending your code with `@show` (see below) will display textual information on the type itself
""")

# ╔═╡ adc48d6d-debf-4cc7-95e3-e35a62f7d17a
@show println("hi")

# ╔═╡ 6ce59510-287e-4059-9efe-82133e7a0da7
tip(md"""
Recall the concept of [**broadcasting**](https://docs.julialang.org/en/v1/manual/arrays/):

1. You have an array `an_array::Array{some_type}` of arbitrary size
2. You want to apply a function `my_func(some_type)` to each element of the array 
3. `my_func`
If you want to apply a function  to each element of an array, you append the function name with a dot: `.`. 

**See below for a simple example**

*An alternative (try it!) is to use a list comprehension.*
""")

# ╔═╡ 11952fe0-8cff-43f1-8011-45df9bba84fe
an_array = [3;4;;5;6]

# ╔═╡ d3bd74de-726f-42d7-9c07-df76deb81f2d
@bind dont_do_maths_naked PlutoUI.WebcamInput(help=false, max_size=150)

# ╔═╡ 1d1f3bac-c85c-4d48-9cb5-acac79870608
uu = "https://i.pinimg.com/originals/e9/84/90/e98490ea3dc49e5c326b8a6c9594d2e5.png"

# ╔═╡ 125e0886-2844-4748-831d-cff7656e206d
x = download(uu) 

# ╔═╡ 253e8cb6-39ae-468c-bc86-e138bea8110e
img = load(x)

# ╔═╡ 3df387bb-87a5-46ee-8052-9c932f510f72
question_box(md"""
1. Compare the colour of `RBG(1.,0.,0.)` to `RBG(10.,0.,0.)` . Use this to write a few sentences on the concept of 'colour saturation'. 

2. What happens when you *multiply* (using the `*` operator) the image by a coefficient $c$, e.g. $c=2$? What happens as $c$ increases? What are the remaining colours when $c=200$? Why?

3. How much computer storage (bits) would you imagine a single pixel to take up? Is this a question with one answer? If not, why not?

""")

# ╔═╡ ca0eb491-384b-4a1e-8178-fd1a0ce77e33
tip(md"""
Use a slider, e.g. `@bind c Slider(0:0.1:10)` to easily change the coefficient by which you multiply the image
""")

# ╔═╡ a9f934f2-3758-4abf-af7f-7832775e29aa
question_box(md"""
1. Download another image from the internet. We'll call it `img2`.
2. Use the following function to resize it, so it has the same size as `img`. 

	imresize(img2, (img |> size))
3. Write a few sentences descring what happens if you **add** the two images together. IE `img + img2`.

""")


# ╔═╡ 8007218a-7612-4698-ba64-3bbf47f1bdb9
question_box(md"""
1. Make an array of colours that looks like the French flag (i.e. vertical stripes)
2. Make an array of colours that looks like the Dutch flag (i.e. horizontal stripes)
3. Make functions `red()`, `white()`, and `blue()` that emit the relevant colours. Redo the last two questions using these functions.
""")

# ╔═╡ 9129e79a-5aeb-4441-8a9e-0ac3e74d93ec
RGBA(1.,0.,0.,1.) # This is not yet the french flag

# ╔═╡ f87c9a42-6f83-4366-ae62-a3235f9a7dd2
B = [2;6;;5;3]

# ╔═╡ 6339e219-9e85-4967-9e83-1cec60840da1
md"""
#### How do we classify objects into types?
"""

# ╔═╡ 6a0bec2b-3b8a-4795-9b61-e1b8e4db60c6
blockquote("A rose by any other name would smell as sweet"
) |> aside


# ╔═╡ 5d265ddf-5fec-4246-acab-5464ef54e5be
md"""
# Vector spaces

We are now going to move on to the concept of a vector space. This is a way of **grouping mathematical objects** based on the way they **interact** with each other. We can have a vector space of many different types of object though. Videos, mathematical functions, matrices...

## 1. Defining them
First recall the definition of a **number system** from week 1. For practice, answer:
"""

# ╔═╡ b498bad7-5948-4c14-ba67-3654a69ae806
question_box(md"""
Which of the following are number systems? $\mathbb{N}, \mathbb{Z}, \mathbb{Q}, \mathbb{R}, \mathbb{C}$
""")

# ╔═╡ 83622612-6465-4168-a742-b15239996975
question_box(md"""
Would the set of $400 \times 400$ images form a number system?
""")

# ╔═╡ 60853e74-bae4-4561-9c53-6ddc056a0b76
md"""

- Number systems are called **fields** if $0 \neq 1$. The most common (pretty much only?) fields we encounter outside of pure mathematics are $\mathbb{R}$ and $\mathbb{C}$. 

A vector space is a set of array-like objects (which we will call vectors but see tip below) that crops up everywhere in mathematics. A vector spaces **lives on a field**, in the sense that vectors in the vector space can be **multiplied** by elements of the field. Elements of the field will be called **scalars**.

- Just like we multiplied images (vectors in a vector space of images) by a real number, e.g. $2$!

- Note that we will denote the product of a vector $v \in V$ and a scalar $a \in K$ as $av$ (i.e. we omit a $\times$ symbol).

!!! info "Definition"
	A vector space $V$ on a field $K$ is a set of elements such that:
	#### Addition
	(just like a number system)
	
	**A1** (commutativity):    
	
	$\quad \quad a + b = b + a \in V \quad \forall a,b \in V$

	**A2** (associativity): 

	$\quad \quad a + (b + c) = (a + b) + c \quad \forall a,b,c \in V$

	**A3** (zero):

	 $\quad \quad \ \exists 0 \in V:  \quad a + 0 = a, \quad \forall a \in V$

	**A4** (additive inverse):  

	$\quad \quad \forall a \in V, \ \ \ \exists -a \in V: a + -a = -a + a = 0$

	#### Relation to field $K$:
	
	**K1** (expanding brackets):    
	
	$\quad \quad a(u + v) = au + av \quad \forall a \in K, \ u, v \in V$

	**K2**  (expanding brackets):  
	
	$\quad \quad (a + b)v = av + bv \quad \forall a,b \in K, \ v \in V$

	**A1** (transitivity):    
	
	$(ab)v = a(bv) \ \forall a, b \in K, \ v \in V$

	**A1** (commutativity):    
	
	$1v= v \ \text{ where } 1 \in K$


Phew! That was a long definition! No need to memorise. But useful to go through each axiom and check it makes sense in the context of a vector space such as images of a fixed size.
"""

# ╔═╡ 48f1be0c-7c7a-4a4d-ba0c-b567198b04db
tip(md"""
Most of these axioms are pretty natural: you use them subconsciously when multiplying and adding numbers. Two important points:

1. Multiplication **between** vectors (as opposed to scalar $\times$ vector ) is not defined. We do not need a concept of multiplication to have a vector space.

2. **Existence of a "one" (multiplicative identity)**. Number systems have the concept of "one": an element which, if you multiply it with any other element $v$, doesn't change $v$. Without a concept of multiplication between vectors, there is no need for this.
""")

# ╔═╡ e55061d0-e10f-4afa-819e-26f7f7d27252
tip(md"""
**Potential confusion**

We've previously referred to 1-tensors as  vectors. But we will also call elements of a vector space: 'vectors'. These two definitions of vectors **do not correspond!!!**. 

Sorry for the confusion. Apparently mathematicians aren't always clear.
""")

# ╔═╡ 50c3716f-aa78-4bed-8955-c6e19c6d2fcd
md"""
## 2. Building them

Clocks are a nice example of a vector space. I've built a simple type for clocks below. Make sure you understand the code. 
"""

# ╔═╡ db54ba6e-b419-4455-b0a8-79b65648ca19
struct Clock
	hours::Int64
	mins::Int64
	Clock(x,y) = new(mod(x,12), mod(y,60)) # This is an inner constructor, which you can google
end

# ╔═╡ a544ecb3-cfee-409f-9032-7942b16afb62
Clock(15, 70)

# ╔═╡ 01186de0-cc28-48c6-b54b-29a40469a8fd
md"""
I've also added functionality to draw a clock. The code is below. It uses Luxor.jl for drawing simple pictures. You **don't** have to understand this code. But you're welcome to try...it's not too difficult!
"""

# ╔═╡ f527b0c5-d6b7-4b7e-a29d-72bf477a5ff9
question_box(md"""
Fill in the code block below to build addition and multiplication functions that endow the clock with properties of a vector space.
""")

# ╔═╡ aa0eedd9-10b2-4c81-8fe1-e98d5032cbfa
begin
import Base.+
import Base.*
+(c1::Clock, c2::Clock) = missing

function *(c1::Clock, k)
	missing
end
	
end

# ╔═╡ 66e96c23-33d2-4337-9c30-0b3170288ed2
_A = 2.4*I(3)

# ╔═╡ 1a01e5d6-753f-491a-bcb5-5c893ab1f48f
my_func(i::Integer) = 2i

# ╔═╡ 71efcc52-a2cb-44e5-9573-f95053f0da5f
my_func.(an_array)

# ╔═╡ 3b88831c-9b10-4409-8699-60f456c6fdb3
md"""

- The two images you played with above were different. Nevertheless they could **interact** with each other in certain ways. For instance, we could **add** the images together. You couldn't do that with an image and a string!
- They could also interact with a certain type of scalar (real numbers $\mathbb{R}$). You could **multiply** an image by a scalar. 

In mathematics and programming, you will **often** encounter objects that are related to each other in how they interact, if not in what they contain. 

For instance, here is a matrix:
 
 $A =$ $(latexify_md(A))

We could classify $A$ into many sets: 
- the set of things which possess $4$ and $7$ as an element. 
- the set of things whose `[1,1]` element is $1$. 
- etc etc.
These are sets based on the **information** that $A$ possesses. 

Here's a different type of grouping:

 $A+$ $(latexify_md(A)) = $(latexify_md(A+B))

-  $A$ is in the set of things that can be added to matrices of numbers of size $(2,2)$, such as $B$! 

   $4*A$ = $(latexify_md(4*A))

-  $A$ is in the set of objects that can be multiplied by a scalar (i.e. zero-tensor) number. 

These last two properties hold **regardless** of the information actually contained in $A$. They are based on the way $A$ **interacts** with other mathematical objects.



"""

# ╔═╡ 516ce3d3-f82b-4e83-a581-59b9d65862aa
function clock_render(c::Clock)
	
	# draw numbers
	for i = 1:12 
		text("$i", rotatepoint(Point(0,-120), Point(0,0), i*π/6))
	end

	# draw hours
	rotate(c.hours*π/6)
	arrow(Point(0,0), Point(0,-80), linewidth=4, arrowheadlength=20)
	rotate(-c.hours*π/6)

	#draw mins
	rotate(c.mins*π/30)
	arrow(Point(0,0), Point(0,-90), linewidth=2, arrowheadlength=10)
	circle(Point(0,0),100) 
end

# ╔═╡ 567d9a70-3f4d-46e9-bc24-0bb1b9831ca3
draw_clock(c::Clock) = @drawsvg begin
	background("pink")
	sethue("blue")
	clock_render(c)
	strokepath()
end 260 260

# ╔═╡ 1ee64a42-66d9-43db-ad0d-98fa392d0cd9
Clock(11, 35) |> draw_clock

# ╔═╡ a7f97394-db89-4a9a-9571-41e549b98a96
tip(md"""

We are **overloading** existing functions (`+` and `-`). They already have methods (*how many? Find out by typing `methods(+)`*). So we have to import the functions from their module ([Base](https://docs.julialang.org/en/v1/base/base/)) before we can add new methods.

""")

# ╔═╡ ecd7e9e0-ceea-4642-a1dc-9d9037e6bd8d
question_box(md"""
**Subspaces**

Let $V$ be the set of clocks. You have already shown $V$ is a vector space.


1. Find a **strict subset** $S \subset V$ such that $S$ is a vector space. 
2. Build a function that checks if a given clock is a member of your defined subspace

""")

# ╔═╡ d764fb38-a546-4a54-b3eb-0ee61cd71a12
question_box(md"""
Let $K$ be a field. Let $x$ be a variable. Let

$K[x] = \{a_0 + a_1 x + a_2 x^2 + a_3x^3 + \dots a_n x^n \ \ | \quad n \geq 0, \ \  a_i \in K \}$

1. Is $K[x]$  a vector space? 

$K[x]$ is often referred to as the set of **polynomials** over a field $K$. If $K = \mathbb{R}$ and $x \in \mathbb{R}$, this corresponds to the standard polynomials you see in school. 

The **degree** of a polynomial is the highest $n$ for which $a_n \neq 0$. 

2. Let $K[x]_{\leq N}$ be the set of polynomials of degree **at most N**. Is this a vector space?

3.  Let $K[x]_{N}$ be the set of polynomials of degree **exactly N**. Is this a vector space?

4. Write down the sets $K[x]_{\leq N}$ and $K[x]_{N}$ in mathematical notation, like I did for $K[x]$.



""")

# ╔═╡ 42062f71-0160-4c4f-9b47-281fa7e752a1
md"""
## 3. Understanding them

!!! info "Notation"
	- Consider a matrix with $m$ rows and $n$ columns, whose elements are real numbers. We refer to it as being in the set $\mathbb{R}^{m \times n}$.
	- More generally, we would write a $d$-tensor as $\mathbb{R}^{n_1 \times n_2 \times \dots n_d}$, where $n_i$ is the length of the $i^{th}$ dimension.


"""

# ╔═╡ 34983789-9500-4cbf-baba-73a22fc20c2e
question_box(md"""
What is mathematical notation for the set of 4-tensors, where the first dimension takes integer values, and the next 3 dimensions take real values?

The sizes of the $4$ dimensions are $(3,2,1,6)$.
""")

# ╔═╡ 33336904-11c9-4cf9-9fc3-3e1b3cab0484
question_box(md"""

- Conventionally, one would regard $[3,2,1,6]$ as a $1$-tensor. What set does it belong to?

- One could also consider it as a $2$-tensor (i.e. matrix) with one row. What set does it belong to then?

- Can you write this object in Julia code both ways (i.e. as a $1$-tensor and as a $2$-tensor)? Use `typeof` to write down the respective types of the two objects. Are you allowed to add them together?
""")

# ╔═╡ f3c19cb8-db80-4293-9e61-243c0842f888
tip(md"""
Read [this](https://docs.julialang.org/en/v1/manual/arrays/#man-array-literals) and focus on the section on building arrays using semicolons
""")

# ╔═╡ 5b1dec02-1815-4476-861a-f4307ab1645e
question_box(md"""
Is $\mathbb{R}^{m \times n}$ a vector space? What is the zero element if so?
""")

# ╔═╡ fdf82350-af89-4e9a-8cca-ce7bedf9fbf1
md"""
### ...geometrically


- Start by watching the video below. 



"""

# ╔═╡ 2150e64a-f3d7-4df3-a2a1-1b63a908b54e
html"""
<iframe width="560" height="315" src="https://www.youtube.com/embed/fNk_zzaMoSs?si=HKoGw_vJVt6FNd0w" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
"""

# ╔═╡ 74e1b914-1b4a-42e5-a564-58fb80aca0b2
md"""
- The video introduced vectors as a geometrically representable quantity. This is easiest when they have size $2$, as they can be represented in a two-dimensional space (the [Cartesian plane](https://en.wikipedia.org/wiki/Cartesian_coordinate_system)).

- In school, you may have learnt about representing size-2 vectors as below:
"""

# ╔═╡ 4c6d87b9-6696-4761-8659-82624126a9a3
begin
cartesian_url = "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/Cartesian-coordinate-system.svg/1920px-Cartesian-coordinate-system.svg.png"
md"""
$(Resource(cartesian_url, :width=>400))
"""
end

# ╔═╡ 892d3508-5a08-456a-915e-d4e76461c3ae
md"""- We want you to think about vectors **differently!...**"""

# ╔═╡ 870ffdde-28ae-4376-a565-c9644e4979f0
md"""
!!! info "Definition" 
	#### The **span** of a set of vectors

	Consider a vector space $V$, with associated field $K$ (usually $K = \mathbb{R}$). Pick two elements $e_1, e_2 \in V$. Consider the set
	
	$$S = \{ v \in V : v = \alpha_1 e_1 + \alpha_2 e_2, \ \text{ where } \ \alpha_1, \alpha_2 \in K \}$$ 

	1.  $S$ is known as the **span** of the vectors $e_1$ and $e_2$. 
	
	Pick an element $s \in S$. By definition $s = \alpha_1 e_1 + \alpha_2 e_2$, for some $\alpha_1, \alpha_2 \in K$. 
	
	2. We say that $s$ has **co-ordinates** $[\alpha_1, \alpha_2]$.
"""

# ╔═╡ 7f6ed4d9-14b9-43ce-8515-da0e89c48a0f
question_box(md"""
1. Prove that $S$, as defined in the previous definition, is a vector space itself.
""")

# ╔═╡ 1804bf55-a684-45d5-a7fe-d1e45b3ec0a5
md"""
- Play with the sliders for a₁ and a₂ below. The black arrow with a circular arrowhead denotes the vector $v = a_1 e_1 + a_2 e_2$. As you change the sliders, you should be able to range over vectors $v$ in the **span** of $e_1$ and $e_2$.
- In reality, $a_1$ and $a_2$ are allowed to take any real value. I've restricted them to be between $-10$ and $10$ since the graph has a limited size.
"""

# ╔═╡ 194deaf5-a8dc-49e3-81ae-2f918763e2da
begin
	e₁ = [80, 10]
	e₂ = [-40, 50]
	e₁, e₂
end

# ╔═╡ 7aad6ffd-e504-472a-a9d5-0bf962e94d88
@bind a₁ Slider(-10:0.1:10; show_value=true, default=1.0)

# ╔═╡ a41047ab-b195-4719-b48a-2da84fa70454
@bind a₂ Slider(-10:0.1:10; show_value=true,default=1.0)

# ╔═╡ 65aeec1f-b13d-4c03-b681-d5ac34b2f8fa
@drawsvg begin
	background("white")
	sethue("black")
	fontsize(30)
	sethue("blue")
	label("v = $(a₁)e₁", :NW, Point(-100, -250))
	sethue("red")
	label(" + $(a₂)e₂", :NE, Point(-100, -250))
	sethue("black")
	fontsize(20)
	label("xy - coordinates: = $(a₁.*e₁ .+ a₂.*e₂)", :NW, Point(50, 100))
	label("e₁e₂ - coordinates: = $([a₁ , a₂])", :SW, Point(50, 100))
	
	rotate(π)
	transform([-1 0 0 1 0 0])	

	sethue("blue")
	arrow(Point(0,0), Point(e₁...), linewidth=6, arrowheadlength=20)
	sethue("red")
	arrow(Point(0,0), Point(e₂...), linewidth=6, arrowheadlength=20)
	sethue("black")
	circle(Point((a₁.*e₁ .+ a₂.*e₂)...), 4; action =:fill)
	arrow(Point(0,0), Point((a₁.*e₁ .+ a₂.*e₂)...), arrowheadlength=0)
	rulers()
	
end

# ╔═╡ 82edcf27-fb11-441b-8daa-d5a7240ac400
md"""### Why are we doing this?

- I want to emphasise that **the same vector** $v \in V$, can have **multiple representations**. The exact representation depends upon the **co-ordinate system**. This in turn depends upon the choice of $e_1$ and $e_2$.


- In school, you use a particular choice of $e_1$ and $e_2$ (*which choice? see question below*) to represent vectors. But it's not the only choice!

- Linear algebra is all about transforming co-ordinate systems.

"""

# ╔═╡ 7b6be34b-1c3f-4dbd-a741-b1318b09aecb
question_box(md"""
1. Tinker with the values of $e_1$ and $e_2$. For what values do the xy-co-ordinates correspond to the $e_1e_2$-coordinates?
2. What relationship has to hold between $e_1$ and $e_2$ for the statement: $S = \mathbb{R}^2$ to be true? *(i.e. when can you get the circular arrow to move anywhere?)*
3. When is $S \subset V$? In what situation is one of the spanning vectors ($e_1$ or $e_2$) **redundant**?
""")

# ╔═╡ 32ec7f07-e107-4515-8f5b-a85111a815d2
md"""
- You should have seen from the above exercise that *sometimes* one of the spanning vectors can be **pruned**, without altering the span $S$. 


"""

# ╔═╡ c691600e-a5c0-450a-a457-9409172377e3
md"""
!!! info "Definition"
	#### Linear combinations and linear dependence
	An object $v$ is a **linear combination** of  $\{v_1, \dots v_n\}$ if there exists scalars $\alpha_1 \dots \alpha_n$ from a field $K$ such that 

	$v = \sum_{i=1}^n \alpha_i v_i$

	In this case, we say that $v$ is **linearly dependent** on $\{v_1, \dots v_n\}$
"""

# ╔═╡ aaa9f939-188e-4c75-b58e-2eb5e88b37f8
question_box(md"""
1. If you're allowed to use the definition for linear combinations, what's an easier definition for the set spanned by a set of vectors $\{e_1, \dots e_n\}$?

2. In the interactive graph above, what happends if $e_2$ is a linear combination of $e_1$?
""")

# ╔═╡ 523a2309-862e-45af-81c2-9124c260a5f8
md"""
!!! info "Definition"
	#### **Dimension** of a vector space

	1. A set $\{e_i\}_{i=1}^n$ **spans** $V$ if 
	$v \in V \Rightarrow v = \sum_i \alpha_i e_i \ \ \text{ for some } \{\alpha_i\}_{i=1}^n: \alpha_i \in K$
	(*i.e. any vector is a linear combination of the spanning set*)

	The **dimension** is $n \in \mathbb{N}$ if there exists a **minimal-length** spanning set of length $n$ (i.e. no spanning sets of length $n-1$ or less exist).

	#### **Basis**
	If a set $\{e_i\}_{i=1}^n$ of vectors spans $V$ and is minimal (removing any set element stops it spanning $V$), then the set is known as a **basis** for $V$.

"""

# ╔═╡ 6a9d87fc-90c7-4b93-a513-24f14bf3bffe
md"""
!!! info "Definition"

	#### The basis theorem
	Suppose that $v_1, \dots, v_m$ and $w_1, \dots , w_n$ are both bases of the vector space $V$ . Then $m = n$. In other words, all finite bases of V contain the same number of vectors. 
*tricky to prove so we'll skip!*

!!! info "Notation"
	The **canonical** basis in $\mathbb{R}^n$ consists of the vectors:
	
	$$e_1 = [1,0,0, \dots, 0]$$
	$$e_2 = [0,1,0, \dots, 0]$$
	$$\vdots$$
	$$e_n = [0, 0, \dots, 0, 1]$$

This is the basis we usually use to represent vectors. For instance:

$$[3,4] = 3e_1 + 4e_2$$
"""

# ╔═╡ e4fdd0bb-11e1-4e42-8c3b-5f29a70cd7a6
tip(md"""
- Recall the interactive graph earlier, where we could change a circle-headed vector by sliding two knobs. 

- The dimension of a vector space is the **minimum number** of knobs you would need to have be able to move the circle-headed vector along the entirety of the vector space.

- For instance, a line intersecting the origin $(0,0)$ is a 1d vector space. If you point $e_1$ in the correct direction, you only need to change $a_1$ to traverse the line.

- For instance, it's intuitively obvious that in a three-dimensional graph (instead of the 2d one shown), we would need three basis elements and three knobs to get the vector to go in every possible direction. 
""")

# ╔═╡ daba127c-bfa1-4d81-b3d3-e3011e0f4a60
html"""
<iframe width="560" height="315" src="https://www.youtube.com/embed/k7RM-ot2NWY?si=YZfzb5DImjrC6xnb" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
"""

# ╔═╡ d6f811a8-5cb7-44ed-af1c-e05fe61e32ff
question_box(md"""
1. Does $S = \{[2,1], [3,2], [5,3]\}$ span $\mathbb{R}^2$?
2. Is $S$ a basis for $\mathbb{R}^2$?
3. Suppose $S = \{e_i\}_{i=1}^m$ is a spanning set for a vector space $V$. Suppose a particular set element $e_k$ is a linear combination of the other set elements. Let's remove $e_k$ from $S$, leaving us with $\{e_i\}_{i=1, i \neq k}^m$. Does the remaining set also span $S$?
""")

# ╔═╡ e4cc355b-85e7-4d1a-9401-60be5bcb0880
md"""
### Quick note on affine spaces
"""

# ╔═╡ fb36491e-6df0-4772-8066-f29cf00d04af
blockquote(md"""
An affine space is nothing more than a vector space whose origin we try to forget about, by adding translations to the linear maps"

*Marcel Berger*
""") |> aside

# ╔═╡ 9a4f3052-70db-4b4c-84cd-2192e2b397a5
md"""
!!! info "Definition"
	- An affine space $A$ is a set of the form $v + V$, where $V$ is a vector space and $v \in V$. 

	- For instance, a line intersecting an origin is a vector space. A line not intersecting the origin is an affine space. $v$ is the offset from the origin

	- Notions of spanning set, basis, dimension, etc are all as for $V$


"""

# ╔═╡ 818df519-8154-4deb-97d2-8e70d7d6483f
@drawsvg begin
	sethue("red")
	fontsize(18)
	label("Vector space", :NE, Point(50, -100))
	sethue("blue")
	label("Affine space", :NE, Point(50, -130))
	rotate(π)
	transform([-1 0 0 1 0 0])	
	sethue("black")
	for x in [-150, 150]
		arrow(Point(0,0), Point(x, 0))
		arrow(Point(0,0), Point(0, x))
	end
	sethue("red")
	rotate(pi/3)
	arrow(Point(-100,0), Point(100,0), linewidth=6, arrowheadlength=20)
	sethue("blue")
	arrow(Point(-100, 40), Point(140, 40), linewidth=6, arrowheadlength=20)
end 400 300

# ╔═╡ 5a0cad16-fb5a-4b96-a9b7-7947f61d1388
md"""
- Let $V$ be the vector space of $382 \times 600$ pixel images
- Let $v_1$ and $v_2$ be the images of the seagull boyband, and the vertically flipped seagull boyband, respectively.
"""

# ╔═╡ b836c572-285b-4e2b-b3dd-df3de2a33ca5
question_box(md"""
Let $V$ be the vector space of $382 \times 680$ images. Let $v_1, v_2 \in V$ refer to the original and flipped images. 
1. Mathematically characterise the set of images obtained as you move the slider for $\alpha$.
2. If $\alpha$ could go between $-\infty$ and $\infty$, would this set be a vector space, an affine space, or neither? Why?
3. What is the dimension of this space?
4. The slider traverses only a small subset of the space of possible $382 \times 600$ images consisting of RGB pixels. How many sliders would you need to traverse all such images? What would be a better choice of basis set for these sliders (no offence to the seagulls)
5. What is the dimension of the vector space of such images?
6. Suppose each pixel takes up [8 bits](https://en.wikipedia.org/wiki/8-bit_color) of space (= 1 byte). How large would the image file be?
""")

# ╔═╡ b991029b-491c-47c1-8d43-61eb8e1f10b4
upside_down_img = reverse(img; dims=1);

# ╔═╡ 001d874d-af90-44c0-8043-71c7c957ae9c
@bind α Slider(0:0.1:1)

# ╔═╡ a02d9d10-4f64-4f6f-86f3-14a298e91ba6
tot_img = α*img + (1-α)*upside_down_img

# ╔═╡ 91c2449f-be04-4485-b9fb-21909eeb7d2b
tot_img |> size

# ╔═╡ 027dc77b-5596-486c-994d-82293f9eaa2d
tip(
	md"""
- The size of a photo is often much **smaller** than the number of pixels would suggest.
- Natural images are quite a small subset of the set of all possible images. 
- Lossy compression schemes such as jpegs represent images in a lower-dimensional basis that **doesn't span the entire vector space of images**. Hence 'lossy'. 
- However, the basis elements are chosen such that natural images fit very well onto this lower-dimensional vector space, without much loss of image quality.
	"""
)

# ╔═╡ 642373b7-441f-4d17-8f23-41c09302f07c
md"""
# All about matrices: the sequel
## What are they good for?
## 3. Transforming data
(i.e. vectors)

We can think of a matrix $A \in \mathbb{R}^{m \times n}$ as a function that transforms data:

$$f(v) = Av$$

Here, $Av$ means *A (on the left) multiplied by v (on the right)*
"""

# ╔═╡ e839ca44-a651-4911-a43f-09859262dbbb
html"""
<iframe width="560" height="315" src="https://www.youtube.com/embed/kYB8IZa5AuE?si=oGVLjahjW6J6-N_3" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
"""

# ╔═╡ ab9c4f2e-943b-43c5-9954-6d3e10a67d9f
html"""
<iframe width="560" height="315" src="https://www.youtube.com/embed/XkY2DOUCWMU?si=NJTaZjtR-gJxsUEC" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
"""

# ╔═╡ e2c3e757-e038-4748-940d-c60045a034e3
tip(md"""
We're not going to add to the mess on the internet by including yet another manual for multiplying matrices. [See e.g. here](https://www.khanacademy.org/math/precalculus/x9e81a4f98389efdf:matrices/x9e81a4f98389efdf:multiplying-matrices-by-matrices/a/multiplying-matrices) if you need to recap/learn it. **But the ability to multiply matrices on pen and paper is extremely important**
""")

# ╔═╡ c6f8cf20-0c11-4252-8d74-c12a2979b6fa
tip(md"""
Always keep track of the input and output sizes/dimensions of your functions! It's useful to figure these out **before** you work out the transformation, e.g. for the questions below.
""")

# ╔═╡ 6cbf295b-a8e5-4494-ba03-94afcb98ee61
begin
m1 = [3;2;;4;5;;6;8]
v1 = [2;4]
v2 = [2;4;6]
end;

# ╔═╡ 7d8f8160-91d7-46f3-aa44-c881774074e0
md"""
Do the following matrix multiplications **by hand**. (you can check correctness after on the computer)

*not all the multiplications are allowable!*

 $(latexify_md(v1')) $(latexify_md(m1))

---
 $(latexify_md(v2')) $(latexify_md(m1))

---

 $(latexify_md(v2')) $(latexify_md(v2))

---

 $(latexify_md(v2)) $(latexify_md(v2'))

---
 $(latexify_md(m1)) $(latexify_md(m1'))

---

 $(latexify_md(m1')) $(latexify_md(m1))

---
 $(latexify_md(m1')) $(latexify_md(m1'))
""" |> question_box

# ╔═╡ 3614bee2-86cb-46a0-ac36-dbe1c6eecac7
question_box(md"""
1. Suppose we multiply two matrices $A$ and $B$. For $AB$ (i.e. $A$ multiplied by $B$ to be a valid operation, what relationship must hold between the sizes of $A$ and $B$? Write a sentence or two.

2. If $AB$ is valid, does that mean that $BA$ is valid? If not, find a counterexample. 

3. If $AB$ and $BA$ are valid, does $AB=BA$ hold, like for scalar numbers? If not, find a counterexample (the previous question might help!)
""")

# ╔═╡ 46f0fbc9-84ba-41ec-98a7-51688d80a7b7
md"""
### Example: linear image transformations

- As explained in the video above, we can think of matrices as objects that transform vectors.
- Instead of drawing all the vectors as arrows, this is easier to visualise if one only draws the tips of the arrows as e.g. circles. 
- Another way of visualising and gaining intuition is taking an image of $m \times n$ pixels. Each pixel on the image has a position, relative to the centre co-ordinate of zero (see Transformation co-ordinates below). Thus it corresponds to a vector. We can transform this vector by a matrix, and see how the image changes!
"""

# ╔═╡ a8c54fe3-a116-4980-9459-56988a401442
md"""
#### Step 1

- We need to build a function that goes from the transformation co-ordinates on which we do linear algebra, to the array co-ordinates (i.e. rows and columns) on which the pixels are organised in the image matrix. 

- After all, we are thinking of each pixel as a vector emanating from the $(0,0)$ point corresponding to the centre of the image.
- Look at the function `trygetpixel` below, which does this. Make sure you understand it!
"""

# ╔═╡ 1528e80e-e9f2-4417-a938-4c95dbb603c7
@drawsvg begin

	sethue("black")
	fontsize(16)
	label("Array Co-ordinates", :E, Point(-200, -120))
	fontsize(12)
	label("(1, 1)", :W, Point(-150, -50))
	label("(1,m)", :E, Point(-50, -50))
	label("(n,m)", :E, Point(-50, 50))
	label("(n,1)", :W, Point(-150, 50))
	Rectangle(Turtle(-100,0),  70., 70.)

	sethue("red")
	arrow(Point(0, 0), Point(60, 0))
	arrow(Point(60, 10), Point(0, 10))
	sethue("black")
	
	fontsize(16)
	label("Transformation Co-ordinates", :E, Point(30, -120))
	fontsize(12)
	label("(-1, 1)", :W, Point(100, -50))
	label("(1,1)", :E, Point(200, -50))
	label("(-1,1)", :E, Point(200, 50))
	label("(-1,-1)", :W, Point(100, 50))
	Rectangle(Turtle(150,0), 70, 70)
	arrow(Point(150, 100), Point(150, -100))
	arrow(Point(80, 0), Point(250, 0))
	label("x", :SW, Point(250,10))
	label("y", :SE, Point(150,-90))
end 500 300 


# ╔═╡ fc25b76d-3168-4c98-b862-2342e8671f2d
begin
	_white(c::RGB) = RGB(1,1,1)
	_white(c::RGBA) = RGBA(1,1,1,0.75)
end

# ╔═╡ 96dd6c1c-1a3e-48a5-9c00-8280d404a8e3
"""
1. Go from transformation co-ordinates to array co-ordinates. 
2. Extract appropriate pixel from image in array co-ordinates
*Adapted from the MIT Intro to computational thinking course*
"""
function trygetpixel(img::AbstractMatrix, x::Float64, y::Float64)
	rows, cols = size(img)
	
	"The linear map that squeezes [-1,1] into [0,1]"
	f = t -> (t - -1.0)/(1.0 - -1.0)
	
	i = floor(Int, rows *  f(-y))
	j = floor(Int, cols *  f(x * (rows / cols)) )
 
	if 1 < i ≤ rows && 1 < j ≤ cols
		img[i,j]
	else
		_white(img[1,1])

	end
end

# ╔═╡ 6380b622-8dd8-4bbb-a31d-32694b44a802
md"""
#### Step 2
- Just for clearer imagery, let's add gridlines to the image.
- Reading the code for `with_gridlines` helps your understanding of array operations and selecting subsets of arrays using array slicing
"""

# ╔═╡ 5b9dadd8-3062-4289-b880-da976eb13a62
"""
takes image. adds gridlines. keyword argument: `n=16` can be modified to determine the number of gridlines
"""
function with_gridlines(img::Array{<:Any,2}; n=16)
	
	sep_i = size(img, 1) ÷ n #rows/n . sep = separation
	sep_j = size(img, 2) ÷ n #cols/n
	
	result = copy(img)
	# stroke = zero(eltype(img))#RGBA(RGB(1,1,1), 0.75)
	
	stroke = RGBA(1, 1, 1, 0.75)
	
	result[1:sep_i:end, :] .= stroke
	result[:, 1:sep_j:end] .= stroke

	# a second time, to create a line 2 pixels wide
	result[2:sep_i:end, :] .= stroke
	result[:, 2:sep_j:end] .= stroke
	
	 result[  sep_i * (n ÷2) .+ [1,2]    , :] .= RGBA(0,1,0,1)
	result[ : ,  sep_j * (n ÷2) .+ [1,2]    ,] .= RGBA(1,0,0,1)
	return result
end

# ╔═╡ 133c0979-608b-4bff-bff3-91ccb783600d
md"""
#### Step 3
Build the $2 \times 2$ matrix by which you transform each vector (pixel)
"""

# ╔═╡ fe55f4d2-170e-40c3-8232-9de2fc363bf8
let

range = -1.5:.1:1.5
md"""
This is a "scrubbable matrix" -- click on the number and drag to change.	
	
``(``	
 $(@bind a Scrubbable( range; default=1.0))
 $(@bind b Scrubbable( range; default=0.0))
``)``

``(``
$(@bind c Scrubbable(range; default=0.0 ))
$(@bind d Scrubbable(range; default=1.0))
``)``
	
	**Re-run this cell to reset to identity transformation: open the code and then 'shift+enter'**
"""
end

# ╔═╡ b5618248-bcb0-4987-8ce6-e93f2c40d5ed
M = [a;c;;b;d]

# ╔═╡ 17ae157e-42ee-4853-a647-1ff1269bd37c
gridded_img = with_gridlines(img; n =12);

# ╔═╡ 98e5556c-9b65-4cec-a725-6429a2c94100
transformed_img = [ # This is a list comprehension. 
	if det(M) == 0
		RGB(1.0, 1.0, 1.0)
	else
		in_x, in_y =  M*([out_x, out_y]) #transform by matrix
		trygetpixel(gridded_img, in_x, in_y) 
	end
	
	for out_y in LinRange(1.0, -1.0, 500),
		out_x in LinRange(-1.0, 1.0, 500)
];

# ╔═╡ 1389c62b-5f18-4ccf-9881-2cffef2a7237
eigenvectors = @drawsvg begin
	for i in 1:2
		ei = eigen(M).vectors[:,i]
		λ = eigen(M).values[i]
		if  (ei |> eltype<:Real) && (norm(λ) > 0.01) && (norm(ei) > 0.01)
		 	arrow(Point(0,0), 50*λ*Point(ei...))
		end
	end
end 250 250;

# ╔═╡ 9d449bfb-b3bc-497c-b2e4-b634c93552f4
TwoColumn(md"$(transformed_img)", md"$(eigenvectors)")

# ╔═╡ bed2e6ff-5045-4cf1-b85c-5853aa89619b
md"""
#### Step 4:

Draw the new image! 

Note the use of a **list comprehension**. This is a powerful programming trick in many languages. 
"""

# ╔═╡ 28597ac9-3b8e-46c9-be47-1037c5cb7d62
hint(md"""
A transformation of $\begin{bmatrix} 2 & 0 \\ 0 & 2 \end{bmatrix}$ **doubles** the length of every vector, while preserving its shape. 

This means that it **halves** the size of the image. The pixel previously corresponding to the vector $(x,y)$ is now going to be corresponding to the vector $(2x, 2y)$. You hit the borders of the image twice as fast...
""")

# ╔═╡ bda85f37-da24-4d7e-9f4c-40e3f5974461
question_box(md"""
Can you give an intuitive explanation of
1. Why increasing `M[1,2]` [shears](https://en.wikipedia.org/wiki/Shear_mapping) the image along the $x$-axis?
2. Why increasing `M[2,1]` [shears](https://en.wikipedia.org/wiki/Shear_mapping) the image along the $y$-axis?

It may help to think of how these altered matrices transform the vectors $[1,0]$ and $[0,1]$. Don't use google!
""")

# ╔═╡ 5f4d78a2-7ed7-48e6-a814-8fb424ed9cb8
question_box(md"""
#### Bonus

Add sliders that allow you to zoom the image in or out. 

1. (easier) modify the list comprehension to zoom towards the centre.
2. (harder) modify the `trygetpixel` function to zoom towards the top left
""")

# ╔═╡ 59d95845-23c4-4548-99cf-4d9fcf91d537
tip(md"""
- As you move the image, it's difficult but possible to notice that there is a line of pixels (a vector emanating from the centre) that expands or contracts, but doesn't change angle. 

- To make it easier to visualise, the graphic has black arrows on the right representing these directions.

- These directions are called the **eigenvectors** of the transformation. We will think a lot about eigenvectors in future notebooks. For now, this is just a teaser!
""")

# ╔═╡ 3010bc81-7d54-4897-b0c1-12f88451695f
html"""
<iframe width="560" height="315" src="https://www.youtube.com/embed/rHLEWRxRGiM?si=xVx_kBqINsQs2tHs" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
"""

# ╔═╡ 76b75272-9f9d-4310-b4fd-dad49ea62c33
md"""
### Linear vs nonlinear transformations

- You have probably dealt with SISO (single input single output) functions $f: \mathbb{R} \to \mathbb{R}$ in school. You can draw a **graph** of these functions on Cartesian axes, as below. At each point on the $x$-axis, one draws $y=f(x)$ on the $y$-axis. 

- You may have disambiguated the concepts of **linear** and **nonlinear** functions in this context. Which is easy! Nonlinear functions are curvy, linear functions are straight. So if you know the values of a linear function at two points, you can **extrapolate** to know its values everywhere!
"""

# ╔═╡ 8f830e79-fd4c-46f2-9a02-67a99e439f41
@drawsvg begin
	sethue("red")
	label("nonlinear", :N, Point(-70,0))
	sethue("black")
	arrow(Point(-100,50), Point(-100,-100))
	arrow(Point(-100, 50), Point(70, 50))
	sethue("red")
	curve(Point(-100,0), Point(20,80), Point(50,-50))
	strokepath()
	sethue("black")
	label("linear", :NW, Point(60, -60))
	line(Point(-100,50), Point(60, -60))
	strokepath()
	label("x", :SW, Point(-0, 55))
	label("y", :NW, Point(-100, 0))

	circle(Point(200,-30), 5, action=:fill)
	circle(Point(140, 30), 5, action=:fill)
	label("Unique line through points", :N, Point(150, 10))
end 420 200

# ╔═╡ b1393e21-0338-4e01-8855-e9b52f671c2a
md"""
...but more generally, we can define functions with **any** domain and range as non/linear!

!!! info "Definition"
	- Let $U$ and $V$ be vector spaces on a field $K$.
	- Consider a function $T: U \to V$. $T$ is linear if it satisfies:
	$$1. \quad f(v + w) = f(v) + f(w) \quad \forall v, w \in U$$
	$$2. \quad f(av) = af(v) \quad \forall a \in K; \quad v \in U$$
"""

# ╔═╡ ce8d095d-5e66-452a-b81c-913f03c794c4
question_box(md"""
1. Turn the two necessary conditions on linearity into a single condition that subsumes them both.
2. Is translation a linear function?
3. Verify that the scalar function $f(x) = mx + c$, where $m, c \in \mathbb{R}$, satisfies linearity.
""")

# ╔═╡ aa7d28b0-a5a4-4a01-92c9-eca2aeeeaa93
tip(md"""
**Any** linear transformation can be realised by a matrix. What do we mean? 

If $T:U \to V$ is a linear transformation, then $T(u) = Au$ for some matrix $A$. We won't prove this, but you can try/look up the proof if you're keen.
""")

# ╔═╡ 2959662f-869e-4cd0-8030-cc9b652e03d8
question_box(md"""
These questions assume vector spaces $U$ (with an $n$ dimensional basis set $e_1, \dots e_n$) and $V$ (with an $m$ dimensional basis set $f_1, \dots, f_m$), over a field $K = \mathbb{R}$.

We will consider a linear function (often called a linear **map**) $T: U \to V$. Remember that we can represent any vector as $v = \sum_{i=1}^n \alpha_i e_i$.

1. Use linearity to express a linear transformation $T(u)$ as a weighted sum of the transformations $\{T(e_i)\}_{i=1}^n$.

2. **Extrapolation**: Is it possible to completely specify a linear map $T$ (i.e. know $T(u)$ for any vector $u \in U$, given knowledge only of the set $\{T(e_i)\}_{i=1}^n$?

3. Suppose we multiply a matrix $A$ with the $k^{th}$ **canonical** basis element: $e_k$. Describe the output in terms of the rows and columns of $A$.

4. We know that $T(e_i)$ will give a vector $v \in V$. Therefore, we can represent 

$$T(e_i) = \sum_{j=1}^m \beta_{ji} f_j$$ for some scalars $\beta_{ij} \in K$.

Suppose that $v = \sum_{i=1}^n \alpha_i e_i$. Write $T(v)$ in terms of $\{\alpha_i\}$, $\beta_{ji}$, and $T(e_i)$.

Now use matrix multiplication to calculate:

$$\begin{bmatrix}
\beta_{11} & \beta_{12} \\
\beta_{21} & \beta_{22}
\end{bmatrix}
\begin{bmatrix}
\alpha_1 \\ \alpha_2
\end{bmatrix}$$

... is there a correspondence between the matrix filled with $\beta_{\bullet}$ elements, and the linear map $T$?
""")

# ╔═╡ b21d472a-c22a-4f7e-a0f6-4ff9906666ad
tip(md"""
The point of the previous questions was to show that
- Knowing how a linear map transforms a basis is enough to fully specify a linear map
- A matrix is essentially a list containing the requisite information on how to transform the different canonical basis elements in a vector space
- Therefore, a matrix is a convenient way of describing a linear map.
""")

# ╔═╡ dd2e7573-9cd9-4b5d-84f8-b7864d412770
md"""

##### Lines in 1d become gridlines in 2d: 

- Go back to the seagull that is transformed by a matrix. 
- Notice that whatever the transformations, the gridlines of the transformed image remain **straight**.
- A 2d linear transformation is **guaranteed** to have straight gridlines, in the same way that a 1d linear transformation yields a straight line.

""" |> tip

# ╔═╡ c9a67ff1-57cf-4c3f-98c3-00e933f88cef
question_box(md"""
1. Use google to find the expression for a matrix $R(\theta)$ that **rotates** vectors by an angle $\theta$. 
2. Use your own judgement to find an expression for a matrix $S(\lambda)$ that scales all vectors by a factor $\lambda$ without altering their direction. 
3. Use matrix multiplication to find a composite matrix that rotates and then scales 

Recall the function composition operator `∘` from notebook 1 (or the live docs). 

4. Make two functions (e.g. $f$ and $g$) that separately apply matrices $A$ and $B$ to an input vector $v$. Make a single function $h$ that applies the matrix product of $A$ and $B$ to an input vector $v$. Verify that exactly one of the following statements is true:
`f ∘ g = h`

`g ∘ f = h`
""")

# ╔═╡ 2e49b926-af41-4d23-9a57-776b247f5a01
f(v) = A*B*v

# ╔═╡ ddb5b572-1f14-448d-88ad-839deadd7fca
f([2, 1])

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
ColorVectorSpace = "c3611d14-8923-5661-9e6a-0046d554d3a4"
Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
Images = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Luxor = "ae8d54c2-7ccd-5906-9d76-62fc9837b5bc"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
ColorVectorSpace = "~0.10.0"
Colors = "~0.12.10"
Images = "~0.26.0"
Luxor = "~3.7.0"
PlutoTeachingTools = "~0.2.11"
PlutoUI = "~0.7.51"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.0"
manifest_format = "2.0"
project_hash = "172f03cfabdd41b8f1a8e131eb22e3563ec585d3"

[[deps.AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "d92ad398961a3ed262d8bf04a1a2b8340f915fef"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.5.0"
weakdeps = ["ChainRulesCore", "Test"]

    [deps.AbstractFFTs.extensions]
    AbstractFFTsChainRulesCoreExt = "ChainRulesCore"
    AbstractFFTsTestExt = "Test"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "91bd53c39b9cbfb5ef4b015e8b582d344532bd0a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.0"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "76289dc51920fdc6e0013c872ba9551d54961c24"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.6.2"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "62e51b39331de8911e4a7ff6f5aaf38a5f4cc0ae"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.2.0"

[[deps.ArrayInterface]]
deps = ["Adapt", "LinearAlgebra", "Requires", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "f83ec24f76d4c8f525099b2ac475fc098138ec31"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "7.4.11"

    [deps.ArrayInterface.extensions]
    ArrayInterfaceBandedMatricesExt = "BandedMatrices"
    ArrayInterfaceBlockBandedMatricesExt = "BlockBandedMatrices"
    ArrayInterfaceCUDAExt = "CUDA"
    ArrayInterfaceGPUArraysCoreExt = "GPUArraysCore"
    ArrayInterfaceStaticArraysCoreExt = "StaticArraysCore"
    ArrayInterfaceTrackerExt = "Tracker"

    [deps.ArrayInterface.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    StaticArraysCore = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.ArrayInterfaceCore]]
deps = ["LinearAlgebra", "SnoopPrecompile", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "e5f08b5689b1aad068e01751889f2f615c7db36d"
uuid = "30b0a656-2188-435a-8636-2ec0e6a096e2"
version = "0.1.29"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "66771c8d21c8ff5e3a93379480a2307ac36863f7"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.0.1"

[[deps.AxisArrays]]
deps = ["Dates", "IntervalSets", "IterTools", "RangeArrays"]
git-tree-sha1 = "16351be62963a67ac4083f748fdb3cca58bfd52f"
uuid = "39de3d68-74b9-583c-8d2d-e117c070f3a9"
version = "0.4.7"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitTwiddlingConvenienceFunctions]]
deps = ["Static"]
git-tree-sha1 = "0c5f81f47bbbcf4aea7b2959135713459170798b"
uuid = "62783981-4cbd-42fc-bca8-16325de8dc4b"
version = "0.1.5"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[deps.CPUSummary]]
deps = ["CpuId", "IfElse", "PrecompileTools", "Static"]
git-tree-sha1 = "89e0654ed8c7aebad6d5ad235d6242c2d737a928"
uuid = "2a0fbf3d-bb9c-48f3-b0a9-814d99fd7ab9"
version = "0.2.3"

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

[[deps.CatIndices]]
deps = ["CustomUnitRanges", "OffsetArrays"]
git-tree-sha1 = "a0f80a09780eed9b1d106a1bf62041c2efc995bc"
uuid = "aafaddc9-749c-510e-ac4f-586e18779b91"
version = "0.2.2"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "e30f2f4e20f7f186dc36529910beaedc60cfa644"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.16.0"

[[deps.CloseOpenIntervals]]
deps = ["Static", "StaticArrayInterface"]
git-tree-sha1 = "70232f82ffaab9dc52585e0dd043b5e0c6b714f1"
uuid = "fb6a15b2-703c-40df-9091-08a04967cfa9"
version = "0.1.12"

[[deps.Clustering]]
deps = ["Distances", "LinearAlgebra", "NearestNeighbors", "Printf", "Random", "SparseArrays", "Statistics", "StatsBase"]
git-tree-sha1 = "b86ac2c5543660d238957dbde5ac04520ae977a7"
uuid = "aaaa29a8-35af-508c-8bc3-b662a17a0fe5"
version = "0.15.4"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "a1296f0fe01a4c3f9bf0dc2934efbf4416f5db31"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.4"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "d9a8f86737b665e15a9641ecbac64deef9ce6724"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.23.0"

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

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.ColorVectorSpace.weakdeps]
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

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

[[deps.ComputationalResources]]
git-tree-sha1 = "52cb3ec90e8a8bea0e62e275ba577ad0f74821f7"
uuid = "ed09eef8-17a6-5b46-8889-db040fac31e3"
version = "0.3.2"

[[deps.CoordinateTransformations]]
deps = ["LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "f9d7112bfff8a19a3a4ea4e03a8e6a91fe8456bf"
uuid = "150eb455-5306-5404-9cee-2592286d6298"
version = "0.6.3"

[[deps.CpuId]]
deps = ["Markdown"]
git-tree-sha1 = "fcbb72b032692610bfbdb15018ac16a36cf2e406"
uuid = "adafc99b-e345-5852-983c-f28acb93d879"
version = "0.3.1"

[[deps.CustomUnitRanges]]
git-tree-sha1 = "1a3f97f907e6dd8983b744d2642651bb162a3f7a"
uuid = "dc8bdbbb-1ca9-579f-8c36-e416f6a65cce"
version = "1.0.2"

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

[[deps.Distances]]
deps = ["LinearAlgebra", "Statistics", "StatsAPI"]
git-tree-sha1 = "b6def76ffad15143924a2199f72a5cd883a2e8a9"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.9"
weakdeps = ["SparseArrays"]

    [deps.Distances.extensions]
    DistancesSparseArraysExt = "SparseArrays"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

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

[[deps.FFTViews]]
deps = ["CustomUnitRanges", "FFTW"]
git-tree-sha1 = "cbdf14d1e8c7c8aacbe8b19862e0179fd08321c2"
uuid = "4f61f5a4-77b1-5117-aa51-3ab5ef4ef0cd"
version = "0.3.2"

[[deps.FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "b4fbdd20c889804969571cc589900803edda16b7"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.7.1"

[[deps.FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "299dc33549f68299137e51e6d49a13b5b1da9673"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.1"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

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

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "1cf1d7dcb4bc32d7b4a5add4232db3750c27ecb4"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.8.0"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.HistogramThresholding]]
deps = ["ImageBase", "LinearAlgebra", "MappedArrays"]
git-tree-sha1 = "7194dfbb2f8d945abdaf68fa9480a965d6661e69"
uuid = "2c695a8d-9458-5d45-9878-1b8a99cf7853"
version = "0.3.1"

[[deps.HostCPUFeatures]]
deps = ["BitTwiddlingConvenienceFunctions", "IfElse", "Libdl", "Static"]
git-tree-sha1 = "eb8fed28f4994600e29beef49744639d985a04b2"
uuid = "3e5b6fbb-0976-4d2c-9146-d79de83f2fb0"
version = "0.1.16"

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

[[deps.IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[deps.ImageAxes]]
deps = ["AxisArrays", "ImageBase", "ImageCore", "Reexport", "SimpleTraits"]
git-tree-sha1 = "2e4520d67b0cef90865b3ef727594d2a58e0e1f8"
uuid = "2803e5a7-5153-5ecf-9a86-9b4c37f5f5ac"
version = "0.6.11"

[[deps.ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "eb49b82c172811fd2c86759fa0553a2221feb909"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.7"

[[deps.ImageBinarization]]
deps = ["HistogramThresholding", "ImageCore", "LinearAlgebra", "Polynomials", "Reexport", "Statistics"]
git-tree-sha1 = "f5356e7203c4a9954962e3757c08033f2efe578a"
uuid = "cbc4b850-ae4b-5111-9e64-df94c024a13d"
version = "0.3.0"

[[deps.ImageContrastAdjustment]]
deps = ["ImageBase", "ImageCore", "ImageTransformations", "Parameters"]
git-tree-sha1 = "eb3d4365a10e3f3ecb3b115e9d12db131d28a386"
uuid = "f332f351-ec65-5f6a-b3d1-319c6670881a"
version = "0.3.12"

[[deps.ImageCore]]
deps = ["AbstractFFTs", "ColorVectorSpace", "Colors", "FixedPointNumbers", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "PrecompileTools", "Reexport"]
git-tree-sha1 = "fc5d1d3443a124fde6e92d0260cd9e064eba69f8"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.10.1"

[[deps.ImageCorners]]
deps = ["ImageCore", "ImageFiltering", "PrecompileTools", "StaticArrays", "StatsBase"]
git-tree-sha1 = "24c52de051293745a9bad7d73497708954562b79"
uuid = "89d5987c-236e-4e32-acd0-25bd6bd87b70"
version = "0.1.3"

[[deps.ImageDistances]]
deps = ["Distances", "ImageCore", "ImageMorphology", "LinearAlgebra", "Statistics"]
git-tree-sha1 = "08b0e6354b21ef5dd5e49026028e41831401aca8"
uuid = "51556ac3-7006-55f5-8cb3-34580c88182d"
version = "0.2.17"

[[deps.ImageFiltering]]
deps = ["CatIndices", "ComputationalResources", "DataStructures", "FFTViews", "FFTW", "ImageBase", "ImageCore", "LinearAlgebra", "OffsetArrays", "PrecompileTools", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "TiledIteration"]
git-tree-sha1 = "432ae2b430a18c58eb7eca9ef8d0f2db90bc749c"
uuid = "6a3955dd-da59-5b1f-98d4-e7296123deb5"
version = "0.7.8"

[[deps.ImageIO]]
deps = ["FileIO", "IndirectArrays", "JpegTurbo", "LazyModules", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs"]
git-tree-sha1 = "bca20b2f5d00c4fbc192c3212da8fa79f4688009"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.7"

[[deps.ImageMagick]]
deps = ["FileIO", "ImageCore", "ImageMagick_jll", "InteractiveUtils"]
git-tree-sha1 = "b0b765ff0b4c3ee20ce6740d843be8dfce48487c"
uuid = "6218d12a-5da1-5696-b52f-db25d2ecc6d1"
version = "1.3.0"

[[deps.ImageMagick_jll]]
deps = ["JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pkg", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "1c0a2295cca535fabaf2029062912591e9b61987"
uuid = "c73af94c-d91f-53ed-93a7-00f77d67a9d7"
version = "6.9.10-12+3"

[[deps.ImageMetadata]]
deps = ["AxisArrays", "ImageAxes", "ImageBase", "ImageCore"]
git-tree-sha1 = "355e2b974f2e3212a75dfb60519de21361ad3cb7"
uuid = "bc367c6b-8a6b-528e-b4bd-a4b897500b49"
version = "0.9.9"

[[deps.ImageMorphology]]
deps = ["DataStructures", "ImageCore", "LinearAlgebra", "LoopVectorization", "OffsetArrays", "Requires", "TiledIteration"]
git-tree-sha1 = "6f0a801136cb9c229aebea0df296cdcd471dbcd1"
uuid = "787d08f9-d448-5407-9aad-5290dd7ab264"
version = "0.4.5"

[[deps.ImageQualityIndexes]]
deps = ["ImageContrastAdjustment", "ImageCore", "ImageDistances", "ImageFiltering", "LazyModules", "OffsetArrays", "PrecompileTools", "Statistics"]
git-tree-sha1 = "783b70725ed326340adf225be4889906c96b8fd1"
uuid = "2996bd0c-7a13-11e9-2da2-2f5ce47296a9"
version = "0.3.7"

[[deps.ImageSegmentation]]
deps = ["Clustering", "DataStructures", "Distances", "Graphs", "ImageCore", "ImageFiltering", "ImageMorphology", "LinearAlgebra", "MetaGraphs", "RegionTrees", "SimpleWeightedGraphs", "StaticArrays", "Statistics"]
git-tree-sha1 = "3ff0ca203501c3eedde3c6fa7fd76b703c336b5f"
uuid = "80713f31-8817-5129-9cf8-209ff8fb23e1"
version = "1.8.2"

[[deps.ImageShow]]
deps = ["Base64", "ColorSchemes", "FileIO", "ImageBase", "ImageCore", "OffsetArrays", "StackViews"]
git-tree-sha1 = "3b5344bcdbdc11ad58f3b1956709b5b9345355de"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.8"

[[deps.ImageTransformations]]
deps = ["AxisAlgorithms", "CoordinateTransformations", "ImageBase", "ImageCore", "Interpolations", "OffsetArrays", "Rotations", "StaticArrays"]
git-tree-sha1 = "7ec124670cbce8f9f0267ba703396960337e54b5"
uuid = "02fcd773-0e25-5acc-982a-7f6622650795"
version = "0.10.0"

[[deps.Images]]
deps = ["Base64", "FileIO", "Graphics", "ImageAxes", "ImageBase", "ImageBinarization", "ImageContrastAdjustment", "ImageCore", "ImageCorners", "ImageDistances", "ImageFiltering", "ImageIO", "ImageMagick", "ImageMetadata", "ImageMorphology", "ImageQualityIndexes", "ImageSegmentation", "ImageShow", "ImageTransformations", "IndirectArrays", "IntegralArrays", "Random", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "StatsBase", "TiledIteration"]
git-tree-sha1 = "d438268ed7a665f8322572be0dabda83634d5f45"
uuid = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
version = "0.26.0"

[[deps.Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "3d09a9f60edf77f8a4d99f9e015e8fbf9989605d"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.7+0"

[[deps.IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[deps.Inflate]]
git-tree-sha1 = "5cd07aab533df5170988219191dfad0519391428"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.3"

[[deps.IntegralArrays]]
deps = ["ColorTypes", "FixedPointNumbers", "IntervalSets"]
git-tree-sha1 = "be8e690c3973443bec584db3346ddc904d4884eb"
uuid = "1d092043-8f09-5a30-832f-7509e371ab51"
version = "0.1.5"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ad37c091f7d7daf900963171600d7c1c5c3ede32"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2023.2.0+0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Interpolations]]
deps = ["Adapt", "AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "721ec2cf720536ad005cb38f50dbba7b02419a15"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.14.7"

[[deps.IntervalSets]]
deps = ["Dates", "Random"]
git-tree-sha1 = "8e59ea773deee525c99a8018409f64f19fb719e6"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.7"
weakdeps = ["Statistics"]

    [deps.IntervalSets.extensions]
    IntervalSetsStatisticsExt = "Statistics"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[deps.JLD2]]
deps = ["FileIO", "MacroTools", "Mmap", "OrderedCollections", "Pkg", "Printf", "Reexport", "Requires", "TranscodingStreams", "UUIDs"]
git-tree-sha1 = "aa6ffef1fd85657f4999030c52eaeec22a279738"
uuid = "033835bb-8acc-5ee8-8aae-3f567f8a3819"
version = "0.4.33"

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

[[deps.JpegTurbo]]
deps = ["CEnum", "FileIO", "ImageCore", "JpegTurbo_jll", "TOML"]
git-tree-sha1 = "327713faef2a3e5c80f96bf38d1fa26f7a6ae29e"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.3"

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

[[deps.LayoutPointers]]
deps = ["ArrayInterface", "LinearAlgebra", "ManualMemory", "SIMDTypes", "Static", "StaticArrayInterface"]
git-tree-sha1 = "88b8f66b604da079a627b6fb2860d3704a6729a1"
uuid = "10f19ff3-798f-405d-979b-55457f8fc047"
version = "0.1.14"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LazyModules]]
git-tree-sha1 = "a560dd966b386ac9ae60bdd3a3d3a326062d3c3e"
uuid = "8cdb02fc-e678-4876-92c5-9defec4f444e"
version = "0.3.1"

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

[[deps.LoopVectorization]]
deps = ["ArrayInterface", "ArrayInterfaceCore", "CPUSummary", "CloseOpenIntervals", "DocStringExtensions", "HostCPUFeatures", "IfElse", "LayoutPointers", "LinearAlgebra", "OffsetArrays", "PolyesterWeave", "PrecompileTools", "SIMDTypes", "SLEEFPirates", "Static", "StaticArrayInterface", "ThreadingUtilities", "UnPack", "VectorizationBase"]
git-tree-sha1 = "c88a4afe1703d731b1c4fdf4e3c7e77e3b176ea2"
uuid = "bdcacae8-1622-11e9-2a5c-532679323890"
version = "0.12.165"

    [deps.LoopVectorization.extensions]
    ForwardDiffExt = ["ChainRulesCore", "ForwardDiff"]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.LoopVectorization.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.LoweredCodeUtils]]
deps = ["JuliaInterpreter"]
git-tree-sha1 = "60168780555f3e663c536500aa790b6368adc02a"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "2.3.0"

[[deps.Luxor]]
deps = ["Base64", "Cairo", "Colors", "Dates", "FFMPEG", "FileIO", "Juno", "LaTeXStrings", "Random", "Requires", "Rsvg", "SnoopPrecompile"]
git-tree-sha1 = "909a67c53fddd216d5e986d804b26b1e3c82d66d"
uuid = "ae8d54c2-7ccd-5906-9d76-62fc9837b5bc"
version = "3.7.0"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "eb006abbd7041c28e0d16260e50a24f8f9104913"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2023.2.0+0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9ee1618cbf5240e6d4e0371d6f24065083f60c48"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.11"

[[deps.ManualMemory]]
git-tree-sha1 = "bcaef4fc7a0cfe2cba636d84cda54b5e4e4ca3cd"
uuid = "d125e4d3-2237-4719-b19c-fa641b8a4667"
version = "0.1.8"

[[deps.MappedArrays]]
git-tree-sha1 = "2dab0221fe2b0f2cb6754eaa743cc266339f527e"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.2"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Media]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "75a54abd10709c01f1b86b84ec225d26e840ed58"
uuid = "e89f7d12-3494-54d1-8411-f7d8b9ae1f27"
version = "0.5.0"

[[deps.MetaGraphs]]
deps = ["Graphs", "JLD2", "Random"]
git-tree-sha1 = "1130dbe1d5276cb656f6e1094ce97466ed700e5a"
uuid = "626554b9-1ddb-594c-aa3c-2596fe9399a5"
version = "0.7.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "7b86a5d4d70a9f5cdf2dacb3cbe6d251d1a61dbe"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.4"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NearestNeighbors]]
deps = ["Distances", "StaticArrays"]
git-tree-sha1 = "2c3726ceb3388917602169bed973dbc97f1b51a8"
uuid = "b8a86587-4115-5ab1-83bc-aa920d37bbce"
version = "0.4.13"

[[deps.Netpbm]]
deps = ["FileIO", "ImageCore", "ImageMetadata"]
git-tree-sha1 = "d92b107dbb887293622df7697a2223f9f8176fcd"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.1.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "2ac17d29c523ce1cd38e27785a7d23024853a4bb"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.12.10"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "327f53360fdb54df7ecd01e96ef1983536d1e633"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.2"

[[deps.OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "a4ca623df1ae99d09bc9868b008262d0c0ac1e4f"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.1.4+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e78db7bd5c26fc5a6911b50a47ee302219157ea8"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.10+0"

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

[[deps.PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "9b02b27ac477cad98114584ff964e3052f656a0f"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.4.0"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "0fac6313486baae819364c52b4f483450a9d793f"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.12"

[[deps.Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "4745216e94f71cb768d58330b059c9b76f32cb66"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.50.14+0"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "716e24b21538abc91f6205fd1d8363f39b442851"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.2"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "64779bc4c9784fee475689a1752ef4d5747c5e87"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.42.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.0"

[[deps.PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "f9501cc0430a26bc3d156ae1b5b0c1b47af4d6da"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.3.3"

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

[[deps.PolyesterWeave]]
deps = ["BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "Static", "ThreadingUtilities"]
git-tree-sha1 = "240d7170f5ffdb285f9427b92333c3463bf65bf6"
uuid = "1d0040c9-8b98-4ee7-8388-3f51789ca0ad"
version = "0.2.1"

[[deps.Polynomials]]
deps = ["LinearAlgebra", "RecipesBase"]
git-tree-sha1 = "3aa2bb4982e575acd7583f01531f241af077b163"
uuid = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
version = "3.2.13"

    [deps.Polynomials.extensions]
    PolynomialsChainRulesCoreExt = "ChainRulesCore"
    PolynomialsMakieCoreExt = "MakieCore"
    PolynomialsMutableArithmeticsExt = "MutableArithmetics"

    [deps.Polynomials.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    MakieCore = "20f20a25-4f0e-4fdf-b5d1-57303727442b"
    MutableArithmetics = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "7eb1686b4f04b82f96ed7a4ea5890a4f0c7a09f1"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "ae36206463b2395804f2787ffe172f44452b538d"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.8.0"

[[deps.QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "18e8f4d1426e965c7b532ddd260599e1510d26ce"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.0"

[[deps.Quaternions]]
deps = ["LinearAlgebra", "Random", "RealDot"]
git-tree-sha1 = "da095158bdc8eaccb7890f9884048555ab771019"
uuid = "94ee1d12-ae83-5a48-8b1c-48b8ff168ae0"
version = "0.7.4"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RangeArrays]]
git-tree-sha1 = "b9039e93773ddcfc828f12aadf7115b4b4d225f5"
uuid = "b3c3ace0-ae52-54e7-9d0b-2c1406fd6b9d"
version = "0.3.2"

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "1342a47bf3260ee108163042310d26f2be5ec90b"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.5"
weakdeps = ["FixedPointNumbers"]

    [deps.Ratios.extensions]
    RatiosFixedPointNumbersExt = "FixedPointNumbers"

[[deps.RealDot]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "9f0a1b71baaf7650f4fa8a1d168c7fb6ee41f0c9"
uuid = "c1ae055f-0cd5-4b69-90a6-9a35b1a98df9"
version = "0.1.0"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RegionTrees]]
deps = ["IterTools", "LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "4618ed0da7a251c7f92e869ae1a19c74a7d2a7f9"
uuid = "dee08c22-ab7f-5625-9660-a9af2021b33f"
version = "0.3.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Revise]]
deps = ["CodeTracking", "Distributed", "FileWatching", "JuliaInterpreter", "LibGit2", "LoweredCodeUtils", "OrderedCollections", "Pkg", "REPL", "Requires", "UUIDs", "Unicode"]
git-tree-sha1 = "1e597b93700fa4045d7189afa7c004e0584ea548"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.5.3"

[[deps.Rotations]]
deps = ["LinearAlgebra", "Quaternions", "Random", "StaticArrays"]
git-tree-sha1 = "54ccb4dbab4b1f69beb255a2c0ca5f65a9c82f08"
uuid = "6038ab10-8711-5258-84ad-4b1120ba62dc"
version = "1.5.1"

[[deps.Rsvg]]
deps = ["Cairo", "Glib_jll", "Librsvg_jll"]
git-tree-sha1 = "3d3dc66eb46568fb3a5259034bfc752a0eb0c686"
uuid = "c4c386cf-5103-5370-be45-f3a111cca3b8"
version = "1.0.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SIMDTypes]]
git-tree-sha1 = "330289636fb8107c5f32088d2741e9fd7a061a5c"
uuid = "94e857df-77ce-4151-89e5-788b33177be4"
version = "0.1.0"

[[deps.SLEEFPirates]]
deps = ["IfElse", "Static", "VectorizationBase"]
git-tree-sha1 = "4b8586aece42bee682399c4c4aee95446aa5cd19"
uuid = "476501e8-09a2-5ece-8869-fb82de89a1fa"
version = "0.6.39"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.SimpleWeightedGraphs]]
deps = ["Graphs", "LinearAlgebra", "Markdown", "SparseArrays"]
git-tree-sha1 = "4b33e0e081a825dbfaf314decf58fa47e53d6acb"
uuid = "47aef6b3-ad0c-573a-a1e2-d07658019622"
version = "1.4.0"

[[deps.Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "2da10356e31327c7096832eb9cd86307a50b1eb6"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.3"

[[deps.SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

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

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[deps.Static]]
deps = ["IfElse"]
git-tree-sha1 = "f295e0a1da4ca425659c57441bcb59abb035a4bc"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.8.8"

[[deps.StaticArrayInterface]]
deps = ["ArrayInterface", "Compat", "IfElse", "LinearAlgebra", "PrecompileTools", "Requires", "SparseArrays", "Static", "SuiteSparse"]
git-tree-sha1 = "03fec6800a986d191f64f5c0996b59ed526eda25"
uuid = "0d7ed370-da01-4f52-bd93-41d350b8b718"
version = "1.4.1"
weakdeps = ["OffsetArrays", "StaticArrays"]

    [deps.StaticArrayInterface.extensions]
    StaticArrayInterfaceOffsetArraysExt = "OffsetArrays"
    StaticArrayInterfaceStaticArraysExt = "StaticArrays"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore"]
git-tree-sha1 = "51621cca8651d9e334a659443a74ce50a3b6dfab"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.6.3"
weakdeps = ["Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

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

[[deps.ThreadingUtilities]]
deps = ["ManualMemory"]
git-tree-sha1 = "eda08f7e9818eb53661b3deb74e3159460dfbc27"
uuid = "8290d209-cae3-49c0-8002-c8c24d57dab5"
version = "0.5.2"

[[deps.TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "Mmap", "OffsetArrays", "PkgVersion", "ProgressMeter", "UUIDs"]
git-tree-sha1 = "8621f5c499a8aa4aa970b1ae381aae0ef1576966"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.6.4"

[[deps.TiledIteration]]
deps = ["OffsetArrays", "StaticArrayInterface"]
git-tree-sha1 = "1176cc31e867217b06928e2f140c90bd1bc88283"
uuid = "06e1c1a7-607b-532d-9fad-de7d9aa2abac"
version = "0.5.0"

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

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.VectorizationBase]]
deps = ["ArrayInterface", "CPUSummary", "HostCPUFeatures", "IfElse", "LayoutPointers", "Libdl", "LinearAlgebra", "SIMDTypes", "Static", "StaticArrayInterface"]
git-tree-sha1 = "b182207d4af54ac64cbc71797765068fdeff475d"
uuid = "3d5dd08c-fd9d-11e8-17fa-ed2836048c2f"
version = "0.21.64"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "de67fa59e33ad156a590055375a30b23c40299d3"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "0.5.5"

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

[[deps.libsixel_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "libpng_jll"]
git-tree-sha1 = "d4f63314c8aa1e48cd22aa0c17ed76cd1ae48c3c"
uuid = "075b6546-f08a-558a-be8f-8157d0f608a5"
version = "1.10.3+0"

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
"""

# ╔═╡ Cell order:
# ╟─ccf5ef1b-6341-43fb-9cb7-5743b034fbd5
# ╠═227137e6-21c4-11ee-0fe8-0fa474726fab
# ╟─2ec75628-1d65-4f38-ac5c-53168286b3f0
# ╟─aa5a077d-552e-4922-a5ac-cf8607f0781d
# ╟─82850d96-02f9-4825-bcf0-84af3a039f89
# ╠═7bcd2490-3543-4e6a-9e53-df37783b52ea
# ╠═66e96c23-33d2-4337-9c30-0b3170288ed2
# ╟─1bc03f27-fbc6-442f-9132-367680897a21
# ╟─11f93907-9037-4d15-ac6e-d2b00dbe039e
# ╠═b385d533-0775-4693-b2d2-eaddcaba22b7
# ╠═1837a32f-378a-4e47-a8bb-5229a074d2b8
# ╟─1c848b46-6ea8-44a3-84d4-2619f724375e
# ╟─aa8d4c23-7a89-40d7-a4ba-1ce53079ba2e
# ╟─d08d299c-71bd-4620-86f0-ececd359ef11
# ╟─ea4e38c4-b8fc-44f4-bdd3-4dc9d64960d3
# ╟─3b9dd93c-10d9-4471-aaeb-111384678b80
# ╟─3245a69d-0b94-4291-ae1a-fac2d66325eb
# ╟─d4c4f68a-2b3e-4452-ac78-a3455da6f5f2
# ╟─e1614adb-8978-488f-828b-f6326c523713
# ╟─a538110d-6e14-4589-8301-2e9b08814c88
# ╟─47fb2828-a963-41ec-a891-37c613c70b18
# ╠═adc48d6d-debf-4cc7-95e3-e35a62f7d17a
# ╟─6ce59510-287e-4059-9efe-82133e7a0da7
# ╠═11952fe0-8cff-43f1-8011-45df9bba84fe
# ╠═1a01e5d6-753f-491a-bcb5-5c893ab1f48f
# ╠═71efcc52-a2cb-44e5-9573-f95053f0da5f
# ╠═d3bd74de-726f-42d7-9c07-df76deb81f2d
# ╟─1d1f3bac-c85c-4d48-9cb5-acac79870608
# ╟─125e0886-2844-4748-831d-cff7656e206d
# ╠═253e8cb6-39ae-468c-bc86-e138bea8110e
# ╟─3df387bb-87a5-46ee-8052-9c932f510f72
# ╟─ca0eb491-384b-4a1e-8178-fd1a0ce77e33
# ╟─a9f934f2-3758-4abf-af7f-7832775e29aa
# ╟─8007218a-7612-4698-ba64-3bbf47f1bdb9
# ╠═9129e79a-5aeb-4441-8a9e-0ac3e74d93ec
# ╠═f87c9a42-6f83-4366-ae62-a3235f9a7dd2
# ╟─6339e219-9e85-4967-9e83-1cec60840da1
# ╟─6a0bec2b-3b8a-4795-9b61-e1b8e4db60c6
# ╟─3b88831c-9b10-4409-8699-60f456c6fdb3
# ╟─5d265ddf-5fec-4246-acab-5464ef54e5be
# ╟─b498bad7-5948-4c14-ba67-3654a69ae806
# ╟─83622612-6465-4168-a742-b15239996975
# ╟─60853e74-bae4-4561-9c53-6ddc056a0b76
# ╟─48f1be0c-7c7a-4a4d-ba0c-b567198b04db
# ╟─e55061d0-e10f-4afa-819e-26f7f7d27252
# ╟─50c3716f-aa78-4bed-8955-c6e19c6d2fcd
# ╠═db54ba6e-b419-4455-b0a8-79b65648ca19
# ╠═a544ecb3-cfee-409f-9032-7942b16afb62
# ╟─01186de0-cc28-48c6-b54b-29a40469a8fd
# ╠═567d9a70-3f4d-46e9-bc24-0bb1b9831ca3
# ╠═516ce3d3-f82b-4e83-a581-59b9d65862aa
# ╠═1ee64a42-66d9-43db-ad0d-98fa392d0cd9
# ╟─f527b0c5-d6b7-4b7e-a29d-72bf477a5ff9
# ╠═aa0eedd9-10b2-4c81-8fe1-e98d5032cbfa
# ╟─a7f97394-db89-4a9a-9571-41e549b98a96
# ╟─ecd7e9e0-ceea-4642-a1dc-9d9037e6bd8d
# ╟─d764fb38-a546-4a54-b3eb-0ee61cd71a12
# ╟─42062f71-0160-4c4f-9b47-281fa7e752a1
# ╟─34983789-9500-4cbf-baba-73a22fc20c2e
# ╟─33336904-11c9-4cf9-9fc3-3e1b3cab0484
# ╟─f3c19cb8-db80-4293-9e61-243c0842f888
# ╟─5b1dec02-1815-4476-861a-f4307ab1645e
# ╟─fdf82350-af89-4e9a-8cca-ce7bedf9fbf1
# ╟─2150e64a-f3d7-4df3-a2a1-1b63a908b54e
# ╟─74e1b914-1b4a-42e5-a564-58fb80aca0b2
# ╟─4c6d87b9-6696-4761-8659-82624126a9a3
# ╟─892d3508-5a08-456a-915e-d4e76461c3ae
# ╟─870ffdde-28ae-4376-a565-c9644e4979f0
# ╟─7f6ed4d9-14b9-43ce-8515-da0e89c48a0f
# ╟─1804bf55-a684-45d5-a7fe-d1e45b3ec0a5
# ╠═194deaf5-a8dc-49e3-81ae-2f918763e2da
# ╠═7aad6ffd-e504-472a-a9d5-0bf962e94d88
# ╠═a41047ab-b195-4719-b48a-2da84fa70454
# ╟─65aeec1f-b13d-4c03-b681-d5ac34b2f8fa
# ╟─82edcf27-fb11-441b-8daa-d5a7240ac400
# ╟─7b6be34b-1c3f-4dbd-a741-b1318b09aecb
# ╟─32ec7f07-e107-4515-8f5b-a85111a815d2
# ╟─c691600e-a5c0-450a-a457-9409172377e3
# ╟─aaa9f939-188e-4c75-b58e-2eb5e88b37f8
# ╟─523a2309-862e-45af-81c2-9124c260a5f8
# ╟─6a9d87fc-90c7-4b93-a513-24f14bf3bffe
# ╟─e4fdd0bb-11e1-4e42-8c3b-5f29a70cd7a6
# ╟─daba127c-bfa1-4d81-b3d3-e3011e0f4a60
# ╟─d6f811a8-5cb7-44ed-af1c-e05fe61e32ff
# ╟─e4cc355b-85e7-4d1a-9401-60be5bcb0880
# ╟─fb36491e-6df0-4772-8066-f29cf00d04af
# ╟─9a4f3052-70db-4b4c-84cd-2192e2b397a5
# ╟─818df519-8154-4deb-97d2-8e70d7d6483f
# ╟─5a0cad16-fb5a-4b96-a9b7-7947f61d1388
# ╟─b836c572-285b-4e2b-b3dd-df3de2a33ca5
# ╠═b991029b-491c-47c1-8d43-61eb8e1f10b4
# ╠═001d874d-af90-44c0-8043-71c7c957ae9c
# ╠═a02d9d10-4f64-4f6f-86f3-14a298e91ba6
# ╠═91c2449f-be04-4485-b9fb-21909eeb7d2b
# ╟─027dc77b-5596-486c-994d-82293f9eaa2d
# ╟─642373b7-441f-4d17-8f23-41c09302f07c
# ╟─e839ca44-a651-4911-a43f-09859262dbbb
# ╟─ab9c4f2e-943b-43c5-9954-6d3e10a67d9f
# ╟─e2c3e757-e038-4748-940d-c60045a034e3
# ╟─c6f8cf20-0c11-4252-8d74-c12a2979b6fa
# ╟─6cbf295b-a8e5-4494-ba03-94afcb98ee61
# ╟─7d8f8160-91d7-46f3-aa44-c881774074e0
# ╟─3614bee2-86cb-46a0-ac36-dbe1c6eecac7
# ╟─46f0fbc9-84ba-41ec-98a7-51688d80a7b7
# ╟─a8c54fe3-a116-4980-9459-56988a401442
# ╟─1528e80e-e9f2-4417-a938-4c95dbb603c7
# ╟─fc25b76d-3168-4c98-b862-2342e8671f2d
# ╟─96dd6c1c-1a3e-48a5-9c00-8280d404a8e3
# ╟─6380b622-8dd8-4bbb-a31d-32694b44a802
# ╟─5b9dadd8-3062-4289-b880-da976eb13a62
# ╟─133c0979-608b-4bff-bff3-91ccb783600d
# ╟─fe55f4d2-170e-40c3-8232-9de2fc363bf8
# ╠═b5618248-bcb0-4987-8ce6-e93f2c40d5ed
# ╠═17ae157e-42ee-4853-a647-1ff1269bd37c
# ╟─98e5556c-9b65-4cec-a725-6429a2c94100
# ╟─9d449bfb-b3bc-497c-b2e4-b634c93552f4
# ╠═1389c62b-5f18-4ccf-9881-2cffef2a7237
# ╟─bed2e6ff-5045-4cf1-b85c-5853aa89619b
# ╟─28597ac9-3b8e-46c9-be47-1037c5cb7d62
# ╟─bda85f37-da24-4d7e-9f4c-40e3f5974461
# ╟─5f4d78a2-7ed7-48e6-a814-8fb424ed9cb8
# ╟─59d95845-23c4-4548-99cf-4d9fcf91d537
# ╟─3010bc81-7d54-4897-b0c1-12f88451695f
# ╟─76b75272-9f9d-4310-b4fd-dad49ea62c33
# ╟─8f830e79-fd4c-46f2-9a02-67a99e439f41
# ╟─b1393e21-0338-4e01-8855-e9b52f671c2a
# ╟─ce8d095d-5e66-452a-b81c-913f03c794c4
# ╟─aa7d28b0-a5a4-4a01-92c9-eca2aeeeaa93
# ╟─2959662f-869e-4cd0-8030-cc9b652e03d8
# ╟─b21d472a-c22a-4f7e-a0f6-4ff9906666ad
# ╟─dd2e7573-9cd9-4b5d-84f8-b7864d412770
# ╟─c9a67ff1-57cf-4c3f-98c3-00e933f88cef
# ╠═2e49b926-af41-4d23-9a57-776b247f5a01
# ╠═ddb5b572-1f14-448d-88ad-839deadd7fca
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
