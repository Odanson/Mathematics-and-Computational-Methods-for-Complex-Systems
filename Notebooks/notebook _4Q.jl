### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 8a5e3701-4d2d-4709-a7d3-a561cca1e1aa
using PlutoTeachingTools, PlutoUI, LinearAlgebra, Random

# ╔═╡ 910c0712-821b-4a82-b35d-d64516039d58
PlutoUI.TableOfContents()

# ╔═╡ e4786b86-cf37-47cb-a18b-a48e23fe6f8d
PlutoTeachingTools.ChooseDisplayMode()

# ╔═╡ 7d4f575e-e942-4730-a788-6e1fae369c28
md"""
# Warm-up questions

"""

# ╔═╡ 949525b7-ba63-49c2-b4ff-25e6d635f302
question_box(md"""

Let $A \in \mathbb{R}^{m \times n}$ and $B \in \mathbb{R}^{k \times p}$ be two matrices.

What relationship should hold between the $k,m,n,p \in \mathbb{N}$ for the matrix multiplication $AB$ to be allowable?
""")

# ╔═╡ ee12f122-7752-4a4d-95da-6349dbde5afb
question_box(md"""

1. Fill in the missing function `matrix_multipy(A,B)` below. It should multiply the matrices $A$ and $B$

2. *(Optional)*: Build a **non-allocating function** `matrix_multiply!(C,A,B)`. It should multiply the matrices $A$ and $B$, and then write the output to $C$. Test it by building large random matrices (e.g. `rand(1000,1000)`), and using the `@time` macro to measure allocations EG 
`@time matrix_multiply!(zeros(1000,1000), rand(1000,1000), rand(1000,1000))`

""")

# ╔═╡ c2f1f129-1faf-4890-b6de-d4c32efaef90
function matrix_multiply(A,B)
	return A 
end

# ╔═╡ 2bc831d4-b0c3-40df-b3da-0de07849ad60
function matrix_multiply!(C,A,B)

end

# ╔═╡ d533fad2-dc2d-4ecd-b569-e610377dc3e3
begin
	A,B = randn(10,10), randn(10,10)
	correct_matmul = (matrix_multiply(A,B) ≈ A*B)
	correct_matmul ? correct() : keep_working();
end

# ╔═╡ 8ddfd786-d481-4029-89be-3676ebfbf390
	correct_matmul && confetti()

# ╔═╡ d2f72333-3a64-42b6-b1e1-5794cb8f338d
md"""
## Useful videos

(Of course, the entire linear algebra series of these youtube videos is great if you really want to understand the concepts. We don't have time to cover everything in MCMCS)
"""

# ╔═╡ 9b12aed7-5fe2-4162-8823-f94d04fd6011
html"""
<iframe width="560" height="315" src="https://www.youtube.com/embed/Ip3X9LOh2dk?si=Fag8JsyQnG6dOfVG" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
"""

# ╔═╡ 92c3d25f-ba36-429b-8515-f962d2eff8e8
html"""
<iframe width="560" height="315" src="https://www.youtube.com/embed/PFDu9oVAE-g?si=abUKzLl7jTr1yMg5" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
"""

# ╔═╡ b08edae5-1b12-4a78-90f0-da17a6637cfa
md"""
# Solving systems of linear equations

Let's start with a [rhetorical](https://en.wikipedia.org/wiki/Rhetorical_question) maths question.

!!! info "Rhetorical question"
	- I go to the market with a rucksack that can carry $5kg$ of fruit. I want to fill it. 
	- I have £12 of cash 
	- Apples are £3/kg. Bananas are £2/kg.
	How many kg of apples and bananas should I buy to use my money and fill my rucksack?

Maths questions are just wordy ways of **embedding constraints** (e.g. the constraint of having £12). To solve a question, the first step is to list the constraints mathematically:

$£3 \times 🍎 + £2 \times 🍌 = £12$
$🍎 + 🍌 = 5kg$

(where 🍌 and 🍎 represent the desired weight of each fruit, in kg)

In a more condensed form, this is:

$$\begin{align}
3&🍎 + 2🍌 &= 12 \\
1&🍎 + 1🍌 &= 5
\end{align}$$

We can write this as a matrix equation!... 

"""

# ╔═╡ ce124fbc-96f8-4159-b402-d8a42b477671
question_box(md"""
Find 🍎, 🍌 *such that:
	
 $$\begin{bmatrix} 
	3 & 2 \\ 1 & 1 
	\end{bmatrix}
	\begin{bmatrix}
	🍎 \\ 🍌
	\end{bmatrix} = 
	\begin{bmatrix}
	12 \\ 5
	\end{bmatrix}$$
""")

# ╔═╡ 58b49cd9-ea4a-43de-a843-466bf5a3e4f0
md"""
#### Important points:
1. **The question above is known as a matrix equation. Or a system of linear equations**. The general form of a matrix equation is:

!!! info "General matrix equation"
	Find $x$ such that $Ax = b$, where
	-  $A$ is a **known** matrix
	-  $b$ is a **known** vector 
	-  $x$ is an **unknown** vector
	Solving the equation consists of finding $x$.

2. Most computational mathematics problems in the world boil down to solving matrix equations. **It's a really important class of problem**. 
- Interestingly, **there is no computational method that can solve really big matrix equations efficiently**. If you have a vector $x$ of length $n$, you need **more than** $n^2$ computations to solve the problem (somewhere between $n^2$ and $n^3$). If $n = 1000,000$, well.... a million squared is a large number, and a million cubed even more so!
- There's an entire field of maths devoted to slightly speeding up solutions to this problem, e.g. see [here](https://www.quantamagazine.org/new-algorithm-breaks-speed-limit-for-solving-linear-equations-20210308/) for a fun news article on the topic.

"""

# ╔═╡ c8e8b656-bad8-44d5-96da-b687327ccd74
md"""
## Solving by hand 
(is something you **never** need to do)

**Nevertheless**, understanding how matrix algebra works is important, so let's go through how you might do it:


### 1. What would make it an **easier** matrix problem?

- What's the easiest type of matrix equation to solve? Something like this?

$$\begin{bmatrix} 
	3 & 0 \\ 0 & 2 
	\end{bmatrix}\begin{bmatrix}
	🍎 \\ 🍌
	\end{bmatrix} = 
	\begin{bmatrix}
	\bullet \\ \bullet
	\end{bmatrix}$$

This is a **diagonal** matrix equation. If the matrix is diagonal, the unknowns have been decoupled, so you can solve them separately! You'd get: $🍎 = \frac{\bullet}{3}$, for instance (whatever $\bullet$ is). See below for how to write a diagonal matrix in julia (using LinearAlgebra.Diagonal):

"""

# ╔═╡ 91961a5b-3150-4168-8172-e50fc28820a1
Diagonal([3,4,5])

# ╔═╡ 95e9e315-2304-4d69-b716-a2fac785113c
tip(md"""
- In the markdown box above, look how I used the function a julia function: `latexify_md` inside my markdown.
- You can run any julia code in a markdown box by enclosing the julia code in <dollar sign>(code). 
- `PlutoTeachingTools.latexify_md` is a useful function: it writes out julia objects like matrices (e.g. `upperT` defined below) in latex!
- If you right-click on the $\LaTeX$ (i.e. the big matrix), you have the option to copy paste the $\LaTeX$ code. Neat!
""")

# ╔═╡ 8fa1cb00-1913-4080-bbc6-e68421dac9dc
upperT = [i<=j ? i+ j : 0 for i in 1:4, j in 1:4]

# ╔═╡ 3bf3d380-0997-4c92-81b2-7f1b35db4d82
md"""
- What's the next easiest type of matrix equation to solve? Something like this?

$$\begin{bmatrix} 
	3 & 1 \\ 0 & 2 
	\end{bmatrix}\begin{bmatrix}
	🍎 \\ 🍌
	\end{bmatrix} = 
	\begin{bmatrix}
	\bullet \\ \bullet
	\end{bmatrix}$$

This is an **upper triangular matrix**: Any entry below the diagonal is zero. Here is a larger example of an upper triangular matrix: $(latexify_md(upperT)).
"""

# ╔═╡ c2e432de-dd3b-4d83-b704-c9e6d55d83f0
md"""
Why are upper triangular matrix problems easy to solve?

- Well, the bottom row is solved immediately, as it only involves the bottom unknown. In the example above, $🍌 = \frac{\bullet}{2}$.
- If we have solved the bottom row, then the second-bottom row is solved immediately. We know the numerical value of 🍌 (i.e. `x[end]`) from the equation of the bottom row. We can substitute this in. Then the equation for the `[end-1]` row only has one remaining unknown: x[end - 1].
- ...and so on, iteratively, until we get to the top!

"""

# ╔═╡ a9e14425-c839-4d01-835e-361d992d1aa6
md"""
### 2. How can we **turn it into** an easier matrix problem?

- We already know that
$$\begin{align}
3&🍎 + 2🍌 &= 12 \\
1&🍎 + 1🍌 &= 5
\end{align}.$$

We can **add or subtract** one equation from the other, and it won't change the solution! For instance

$$\begin{align}
2&🍎 + 1🍌 &= 7
\end{align}.$$

(by subtracting the bottom equation from the top).

The golden rule of equations is that **you can do anything to the equation, as long as you do it to both sides of the equation**. As such, we can also multiply equations by any nonzero scalar. For instance

$$\begin{align}
3*(2&🍎 + 1🍌) &= 3*7
\end{align}.$$
so

$$\begin{align}
6&🍎 + 3🍌 &= 21
\end{align}.$$

**Matrix interpretation**: We are solving * an equivalent problem with the same answer* if we perform the following **row operations**:
- add or subtract rows from each other
- **swap** rows
- Multiply rows by a nonzero scalar.



So can you see why 
 $$\begin{bmatrix} 
	2 & 2 \\ 2 & 1 
	\end{bmatrix}
	\begin{bmatrix}
	🍎 \\ 🍌
	\end{bmatrix} = 
	\begin{bmatrix}
	10 \\ 7
	\end{bmatrix}$$
is the same problem?


"""

# ╔═╡ fe4f3da6-5613-4f6a-aa78-c385c7cb2ae2
question_box(md"""
Go back to the original problem armed with these tools:

$$\begin{bmatrix} 
	3 & 2 \\ 1 & 1 
	\end{bmatrix}
	\begin{bmatrix}
	🍎 \\ 🍌
	\end{bmatrix} = 
	\begin{bmatrix}
	12 \\ 5
	\end{bmatrix}$$

What sequence of row operations do you need to turn this into the answer?

$$\begin{bmatrix} 
	1 & 0 \\ 0 & 1 
	\end{bmatrix}
	\begin{bmatrix}
	🍎 \\ 🍌
	\end{bmatrix} = 
	\begin{bmatrix}
	2 \\ 3
	\end{bmatrix}$$

""")

# ╔═╡ f4aa4b49-1900-4377-a01c-b7e722d0ecb4
keyconcept("Gaussian elimination", md"""

We won't cover this in the course. However, **it's a good technique to understand if you want to do further work**. There are so many resources on the internet about Gaussian elimination, that I won't talk about it here.

It's basically a principled way of doing row operations, as we did above, to solve a matrix equation. And it works, no matter how big the matrix (although it is inefficient and slow).
""")

# ╔═╡ ab41918e-1af7-4f7b-a652-6e674aacd72c
question_box(md"""

1. Build a function `CheckUpperTriangular(A)` that takes any matrix $A$, and checks if it is upper triangular.

2. Complete the function called `UpperTriangularSolve(A,b)`, that takes any upper triangular matrix $A$, and solves $Ax=b$ using your own algorithm. The easiest way is to start by solving the bottom row, and then work your way up, as described above. 




""")

# ╔═╡ 884a829e-655e-4f6b-abcf-15cb2599fcd8
hint(md"""
If you're stuck, start with the following code. Only one missing line to fill in!
```julia
function UpperTriangularSolve(A,b)
	num_cols = size(A,2)
	x = zeros(num_cols) 
	x[end] = b[end]/A[end,end]
	for i in num_cols-1:-1:1
		x[i] = ???
	end
	return x
end
```
""")

# ╔═╡ bff486b1-30ff-4254-a5ed-7f72ae64c143
function CheckUpperTriangular(A)
end

# ╔═╡ eee94bf3-4455-434d-8047-b6f7408da991
function UpperTriangularSolve(A,b)
	return b
end

# ╔═╡ 569016b5-3420-48fe-ab18-32131e527573
if UpperTriangularSolve(upperT, [1;2;3;4]) ≈ upperT \ [1;2;3;4]
	correct()
else
	keep_working()
end

# ╔═╡ b9611135-5e61-4e44-9204-af4e2acba332
if UpperTriangularSolve(upperT, [1;2;3;4]) ≈ upperT \ [1;2;3;4]
	confetti()
end

# ╔═╡ 73eef9da-9e06-42a6-80c2-a43bf2841e71
if UpperTriangularSolve(upperT, [1;2;3;4]) ≈ upperT \ [1;2;3;4]
	confetti()
end

# ╔═╡ d63b2c66-4b0e-11ee-31ec-654efe7d8a86
md"""
# Matrix inverses

We've talked previously about **solutions** to matrix problems. Actually, there can be an entire **set** of solutions (the solution set). In maths notation:

$$S = \{ x \in \mathbb{R}^m : Ax = b \}$$, where $A \in \mathbb{R}^{m \times n}, \ b \in \mathbb{R}^n$.
"""

# ╔═╡ 0357880a-7fbf-4c4c-a7d7-76d6cf56afa6
question_box(md"""

Let's take:

$$A = \begin{bmatrix}
0 & 0 \\
0 & 1
\end{bmatrix}, \quad 
B = \begin{bmatrix}
2 & 0 \\
0 & 3
\end{bmatrix}
$$

Comment on the solution set for the following problems:

1.
$$Ax = \begin{bmatrix}
3 \\ 4
\end{bmatrix}$$

2.
$$Ax= \begin{bmatrix}
0 \\ 4
\end{bmatrix}$$

3. 

$$Bx = z  \text{ where } z \in \mathbb{R}^2$$

""")

# ╔═╡ f32369e3-5c4b-4bc1-a2c8-49d268f6c17e
question_box(md"""
1. Find a matrix $M \in \mathbb{R}^{2 \times 3}$ and a vector $b \in \mathbb{R}^2$ such that $$Mx=b$$ expresses the following constraints:

$$x_1 + x_2 + x_3 = 0$$
$$x_1 = -x_2$$

2. Consider a general matrix problem $Ax = b$:
- What aspect of the size of $A$ tells you the number of constraints in the matrix equation?
- What aspect of the size of $A$ tells you about the number of free variables? 
3. Is the solution set of $Ax = 0$ a vector space? 
4. Consider $S= \{x \in \mathbb{R}^2: Ax \neq 0 \}$. Is this a vector space? 
""")

# ╔═╡ ef4ef6b3-64c4-4825-aeb1-c7eea23fef26
md"""
!!! info "Notation"
	- For any matrix $A$, $$\{x : Ax = 0 \}$$ is known as the **kernel** of $A$. It is denoted $$\ker(A)$$.
	- If $$\ker(A) = \{0\}$$, then $$A$$ is called a **nonsingular matrix**. 
	- If $$\ker(A)$$ has nonzero elements, then $$A$$ is **singular**. 

	Meanwhile, the **range** of $A$ is defined as $\{b : \exists x : Ax = b \}$. In other words, the set of $b$ with a nonempty solution set for $Ax=b$. 
"""

# ╔═╡ 5725faee-55f4-48d5-b644-dc92a9ad76c0
tip(md"""
Remember that $0$ refers to the $0$ vector in a vector space, i.e. the additive identity. Not the literal number zero!
""")

# ╔═╡ 74c55f79-1d72-41b9-b011-6ffb426bf183
question_box(md"""

These questions assume a square matrix $$A \in \mathbb{R}^{n \times n}$$. They are a bit harder in terms of reading and writing abstract mathematics. It's fine to skip to the answers if you're struggling.


1. Suppose $$Ax = b$$. Note that we can consider the columns of $A$ as a set of vectors in $\mathbb{R}^n$. 
- Let's denote the $i^{th}$ column as $A_{\bullet, i}$. Can you write $b$ mathematically as a weighted sum of the columns? 

2. Is $b$ in the span of the columns of $A$? 

3. Suppose $A$ has a nonempty kernel. Can you show that the columns of $A$ are not linearly independent? 


4. What can you say about the span of the columns of $A$ if $\ker(A) \neq \{0\}$?
""")

# ╔═╡ eba8acd8-2de6-4afa-be71-cde392f89514
md"""



OK. So we've seen last week how a matrix can be viewed a *transformation*. It takes in an input vector $u$, and spits out an output vector $v$. It's a function!:

$$f(u) = Au$$.

Remember from week 1: functions (sometimes) have inverses!

!!! info " Week 1 Recap"
	- What's another name for an invertible function?
	- We are talking about a *full* inverse. What are the two types of *partial* inverses? What are the names of functions that have these partial inverses?





"""

# ╔═╡ 7f624e97-7f0d-4f05-8b28-4f43f8d84f06
question_box(md"""
What constraint on the size of a matrix $M$ must hold for it to have both a left and right inverse? Think about the sizes of the inputs and outputs to $f(u)$. 
""")

# ╔═╡ 5e318189-fdfc-44a1-bc69-16c98e01e80e
question_box(md"""
Build a matrix $M$ that collapses any vector onto the $x$-axis. In other words, a vector $(x,y)$ goes to $(x,0)$. Can $M$ be invertible? If not, why not? 

*It may help to recall the definition of a function from the first notebook*
""")

# ╔═╡ 4592dae2-392f-44fe-bce2-f0bb470a603f
md"""

Now we are going to cover eigenvalues and eigenvectors. These are a really important concept!

!!! info "Definition: eigenvalues and eigenvectors"
	Consider a square matrix $A \in \mathbb{R}^{n \ times n}$. $v \in \mathbb{R}^n$ is an **eigenvector** of $A$ if $\exists \lambda \in \mathbb{R}$ such that $$Av = \lambda v$$. Here, $\lambda$ is known as the **eigenvalue** associated with $v$  We call $(\lambda, v)$ the eigenvalue-eigenvector pair.

Intuition: $v$ is an eigenvector if **it doesn't change direction when transformed by $A$**. In other words, applying $A$ just scales it. See 3blue1brown video at the top of the notebook.

"""

# ╔═╡ 1a53cf60-bbcd-44ca-af9d-3d7e619d879b
question_box(md"""
Suppose an invertible matrix $A$ has a set of eigenvalue-eigenvector pairs: $\{(\lambda_i, v_i)\}_{i=1}^n$.

- What are the eigenvalues of $A^{-1}$?
- If $A$ is a rotation matrix that only rotates vectors, what are the eigenvalues of $A$? What property does $A^TA$ satisfy and why? *Tip, look back at lecture 4!*

""")

# ╔═╡ 1581baac-9f0a-494f-9f2c-153a97421d17
md"""
# Matrix factorisations
(also known as matrix decompositions)

Take a matrix $M$. If we can rewrite it as the **product** of two (or more matrices), then we have **factorized** $M$. 

So for instance $M = ABC$ is a decomposition of $M$. Just like $3*4*2$ is a factorisation of $24$!

There are many matrix decompositions with long names! Cholesky, LU, QR, SVD. In fact matrix factorizations are an **abstract type** in the LinearAlgebra package. So you can see all the factorisations supported in LinearAlgebra with the code below:

"""

# ╔═╡ 84f9dbcd-4a8e-4f11-8a83-3dc288d36475
subtypes(Factorization)

# ╔═╡ e911b502-961b-4baf-beda-068bd32d9d48
md"""

What's the point of all these factorisations? Are they useful to know about or understand?

- Mostly, exotic factorisations are used to solve specific types of matrix equation (i.e. where the matrix has specific properties) more efficiently. Sometimes, they help when doing tricky matrix algebra (e.g. the Schur factorization). 

- Therefore they are **not that important** to end-users such as yourself, who are going to write ```A \ B``` to solve a matrix equation, and leave the details to the programming language. 

- It's however important to know they exist and what they amount to (i.e. what I wrote above) so that they don't sound intimidating if you do come across them!


**Also!**... 

When we are testing hypotheses in complex systems / data science research, sometimes we want to generate 'random' matrices to test our hypotheses on. Sometimes we want these random matrices to have specific properties. 

!!! info "Example"
	You've built a processing pipeline for some data represented in a matrix. EG people's exam grades for different modules. You hypothesise that there are hidden correlations, e.g. people that did well in English also do well in French. You build a customised pipeline, e.g. using something like [PCA](https://en.wikipedia.org/wiki/Principal_component_analysis) to see if this is true. 

	Does your pipeline work? Are there bugs? To check, you want to test your pipeline on different pieces of *fake, pseudo-data*, to make sure it doesn't do anything crazy. So you might want to generate 'random' matrices with fixed eigenvalues (representing correlations in the data). How?



One decomposition is often useful for situations like this, when you want to construct `random' matrices with particular properties...

### The QR factorisation

"""

# ╔═╡ 356559cf-2e9a-44fe-ac57-5c001793cc36
md"""

!!! info "The QR factorisation"

	The QR factorisation of a matrix $M$ yields two matrices $Q$ and $R$, such that $M = QR$. Moreover
	1.  $Q$ is a rotation matrix, i.e. $Q^TQ = QQ^T  = \mathbb{I}$. 
	2.  $R$ is upper triangular

	In code: `Q, R = qr(M)`	

"""

# ╔═╡ 7569c12f-a1e5-4260-8c19-76e9e776627b
question_box(md"""

- Let $Q$ be a rotation matrix: $Q^TQ = \mathbb{I}$
- Let $Q_{\bullet, i}$ denote the $i^{th}$ column of $Q$.

What is the dot product of $Q_{\bullet, i}$ and $Q_{\bullet, j}$ where $i \neq j$? What about when $i = j$?

- Suppose $Q$ is a square matrix. What is the **range** of $Q$. *(Recalling that $Q$ is a rotation might help you answer this question more easily)*. What does this tell you about the span of the columns of $Q$?

- **Harder, optional**: Do the columns for $Q \in \mathbb{R}^{n \times n}$ form a basis for the vector space $\mathbb{R}^n$?  
""")

# ╔═╡ ba8ec944-5a8a-4898-b3b7-eb8b7ac0d8ac
md"""
- The code below provides a method for generating a **symmetric** matrix consisting of random numbers, where the matrix has pre-specified eigenvalues:

- play with the input eigenvalues, and note that the output will be random, but will always have the right eigenvalues.
"""

# ╔═╡ 9cd94990-c73f-415a-9434-bff383ce947b
function generate_random_matrix(eigenvalues)
	n = length(eigenvalues)
	M = rand(n,n)
	Q,R = qr(M)
	D = Diagonal(eigenvalues)
	return Q'*D*Q
end

# ╔═╡ 14ec8285-13d4-4cf6-b75b-d42ef9395189
some_random_mat = generate_random_matrix(2:2:10)

# ╔═╡ feab02c5-58ad-4ab5-970e-3667aff8b4d3
srm_evecs = eigen(some_random_mat)

# ╔═╡ b033c067-d73a-4ec0-bc27-b1e427115f9b
question_box(md"""
Inspect the `generate_random_matrix` function.

- Why is the output always symmetric? (IE transpose equals itself)

- Is there a mathematical relationship between the eigenvectors of $Q^TDQ$ and the columns of $Q$? *Hint: think about vectors of the form $Q^T e_i$, where $e_i$ is the $i^{th}$ canonical basis element. If you want to inspect $Q$ to help do the above question, you will have to add an extra output to the function*.

- Explain why the function works, i.e. why the eigenvalues of the output matrix correspond to those we inputted.
""")

# ╔═╡ 5d1b7684-b844-4ebf-83c9-62d4395198be
question_box(md"""

#### Challenge: making your own matrix equation solver

1. You've already made an equation solver for upper triangular matrices 
2. You are allowed to use the qr decomposition.
3. Put the qr decomposition and your previous upper-triangular solution together to make a function that can solve all matrix equations!


""")

# ╔═╡ f0898ce4-5199-4c1d-9123-7877705200f1
function matrix_solve(A,b)
	return b # this should return x such that Ax = b
end

# ╔═╡ 1f74b8f5-22ca-46a4-9423-bb7ea43a4d57
function checksolve()
 	A, b = randn(4,4), randn(4)
	if matrix_solve(A,b) ≈ A \ b
		correct()
		confetti()
	else
		keep_working()
	end

end

# ╔═╡ 37304bec-db5c-463e-a2d2-8fca6a5c120f
checksolve()

# ╔═╡ dd6d9058-3930-4dfc-a5ee-396433bc9fbf
md"""
# A teaser on probability

- You can make a random matrix of size $(m,n)$ with the command `rand(m,n)`
- Notice that computers can only generate **pseudorandom** numbers: true randomness is really difficult to replicate!

- All programming languages using random numbers have the concept of a **random seed**.

- Look at the code below. Rerun it multiple times. Notice that the random numbers never change! 

- Now change the seed (ie the number 123) to something else, like 345

- Now the numbers change!
"""

# ╔═╡ 246b3ecc-fd27-4b71-913d-c245d6bb8ac9
begin
	Random.seed!(123)
	rand(5)
end

# ╔═╡ 057b5b7d-871e-4a06-9239-36a0e08e65dd
md"""
Now look at the code below that **doesn't** have a random seed. Notice that each time you run it, the random numbers change. 
"""

# ╔═╡ 3754709c-86f5-4d09-a995-74a97be3f275
rand(5)

# ╔═╡ 8e529bcc-d89a-408e-aeef-6b0f2ac20374
md"""
**What's going on?**

Essentially, the computer chooses random numbers from a **deterministic** (i.e. non-random) sequence. 

- The seed tells it which element of the sequence to start from

- Otherwise, it will take the seed from something like the current time, so that pseudorandom numbers always come out different, like in the no-seed case.

"""

# ╔═╡ c41da523-d3a1-4fef-92c2-1375d626f7eb
question_box(md"""

1. What's are the outcome space, event space, and probability function for generating a (pseudo) random matrix with the command `rand(m,n)`? (where $m,n \in \mathbb{N}$)?


2. Can you use the `generate_random_matrix` function from before to generate a matrix with a nonempty kernel? If not, why not? 

3. What's the probability of `rand(m,n)` generating a singular matrix? Why? 
""")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[compat]
PlutoTeachingTools = "~0.2.13"
PlutoUI = "~0.7.52"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.0"
manifest_format = "2.0"
project_hash = "9dabda6d2688836f6a27f2e8d19716cc2530ae81"

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

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "a1296f0fe01a4c3f9bf0dc2934efbf4416f5db31"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.4"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.2+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

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

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "e8ab063deed72e14666f9d8af17bd5f9eab04392"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.24"

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

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

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

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OrderedCollections]]
git-tree-sha1 = "2e73fe17cac3c62ad1aebe70d44c963c3cfdc3e3"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.2"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "716e24b21538abc91f6205fd1d8363f39b442851"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.0"

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
git-tree-sha1 = "9673d39decc5feece56ef3940e5dafba15ba0f81"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.1.2"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "7eb1686b4f04b82f96ed7a4ea5890a4f0c7a09f1"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

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

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

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

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

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

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.7.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╠═8a5e3701-4d2d-4709-a7d3-a561cca1e1aa
# ╟─910c0712-821b-4a82-b35d-d64516039d58
# ╟─e4786b86-cf37-47cb-a18b-a48e23fe6f8d
# ╟─7d4f575e-e942-4730-a788-6e1fae369c28
# ╟─949525b7-ba63-49c2-b4ff-25e6d635f302
# ╟─ee12f122-7752-4a4d-95da-6349dbde5afb
# ╟─c2f1f129-1faf-4890-b6de-d4c32efaef90
# ╟─2bc831d4-b0c3-40df-b3da-0de07849ad60
# ╟─d533fad2-dc2d-4ecd-b569-e610377dc3e3
# ╟─8ddfd786-d481-4029-89be-3676ebfbf390
# ╟─d2f72333-3a64-42b6-b1e1-5794cb8f338d
# ╟─9b12aed7-5fe2-4162-8823-f94d04fd6011
# ╟─92c3d25f-ba36-429b-8515-f962d2eff8e8
# ╟─b08edae5-1b12-4a78-90f0-da17a6637cfa
# ╟─ce124fbc-96f8-4159-b402-d8a42b477671
# ╟─58b49cd9-ea4a-43de-a843-466bf5a3e4f0
# ╟─c8e8b656-bad8-44d5-96da-b687327ccd74
# ╠═91961a5b-3150-4168-8172-e50fc28820a1
# ╟─3bf3d380-0997-4c92-81b2-7f1b35db4d82
# ╟─95e9e315-2304-4d69-b716-a2fac785113c
# ╠═8fa1cb00-1913-4080-bbc6-e68421dac9dc
# ╟─c2e432de-dd3b-4d83-b704-c9e6d55d83f0
# ╟─a9e14425-c839-4d01-835e-361d992d1aa6
# ╟─fe4f3da6-5613-4f6a-aa78-c385c7cb2ae2
# ╟─f4aa4b49-1900-4377-a01c-b7e722d0ecb4
# ╟─ab41918e-1af7-4f7b-a652-6e674aacd72c
# ╟─884a829e-655e-4f6b-abcf-15cb2599fcd8
# ╠═bff486b1-30ff-4254-a5ed-7f72ae64c143
# ╠═eee94bf3-4455-434d-8047-b6f7408da991
# ╟─569016b5-3420-48fe-ab18-32131e527573
# ╟─b9611135-5e61-4e44-9204-af4e2acba332
# ╟─73eef9da-9e06-42a6-80c2-a43bf2841e71
# ╟─d63b2c66-4b0e-11ee-31ec-654efe7d8a86
# ╟─0357880a-7fbf-4c4c-a7d7-76d6cf56afa6
# ╟─f32369e3-5c4b-4bc1-a2c8-49d268f6c17e
# ╟─ef4ef6b3-64c4-4825-aeb1-c7eea23fef26
# ╟─5725faee-55f4-48d5-b644-dc92a9ad76c0
# ╠═74c55f79-1d72-41b9-b011-6ffb426bf183
# ╟─eba8acd8-2de6-4afa-be71-cde392f89514
# ╟─7f624e97-7f0d-4f05-8b28-4f43f8d84f06
# ╟─5e318189-fdfc-44a1-bc69-16c98e01e80e
# ╟─4592dae2-392f-44fe-bce2-f0bb470a603f
# ╟─1a53cf60-bbcd-44ca-af9d-3d7e619d879b
# ╟─1581baac-9f0a-494f-9f2c-153a97421d17
# ╠═84f9dbcd-4a8e-4f11-8a83-3dc288d36475
# ╟─e911b502-961b-4baf-beda-068bd32d9d48
# ╟─356559cf-2e9a-44fe-ac57-5c001793cc36
# ╟─7569c12f-a1e5-4260-8c19-76e9e776627b
# ╟─ba8ec944-5a8a-4898-b3b7-eb8b7ac0d8ac
# ╠═9cd94990-c73f-415a-9434-bff383ce947b
# ╠═14ec8285-13d4-4cf6-b75b-d42ef9395189
# ╠═feab02c5-58ad-4ab5-970e-3667aff8b4d3
# ╟─b033c067-d73a-4ec0-bc27-b1e427115f9b
# ╟─5d1b7684-b844-4ebf-83c9-62d4395198be
# ╠═f0898ce4-5199-4c1d-9123-7877705200f1
# ╟─1f74b8f5-22ca-46a4-9423-bb7ea43a4d57
# ╟─37304bec-db5c-463e-a2d2-8fca6a5c120f
# ╟─dd6d9058-3930-4dfc-a5ee-396433bc9fbf
# ╠═246b3ecc-fd27-4b71-913d-c245d6bb8ac9
# ╟─057b5b7d-871e-4a06-9239-36a0e08e65dd
# ╠═3754709c-86f5-4d09-a995-74a97be3f275
# ╟─8e529bcc-d89a-408e-aeef-6b0f2ac20374
# ╟─c41da523-d3a1-4fef-92c2-1375d626f7eb
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
