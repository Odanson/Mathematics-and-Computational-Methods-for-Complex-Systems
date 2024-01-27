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

# ╔═╡ e3fe5097-dd80-4c1a-910f-76ed479ac67c
using PlutoUI, PlutoTeachingTools

# ╔═╡ 7b83c2d0-603e-4921-8f78-40586a40bcaa


# ╔═╡ 949d1634-84c7-4cdc-af17-5ea6798bc46a
ChooseDisplayMode()

# ╔═╡ 5ccb8fcf-c4e8-4b24-9667-99e82dec4a86
PlutoUI.TableOfContents(aside=true)

# ╔═╡ 2b15453e-0c4a-11ee-1cc3-198e7e2c6452
md"""
# **Welcome to MCMCS!!**
# Week 1: Assignment, logic, and functions


## Goals of this worksheet

- Introduction to basic Julia 
- Introduction to mathematical syntax and its' manipulation
- Mathematical sets and set operations
- Introduction to the type system in Julia
- Introduction to functions: injectivity, surjectivity and bijectivity



!!! info "First make sure you can..."
	- add your own code boxes by clicking the `+` sign on the left hand side of the screen. 
	- enable and hide visibility of the code box by clicking the eye on the top left corner of each code box.
	- convert a code box to text: type `md` followed by three quotation marks at the beginning of the box. add three quotation marks at the end of the box. EG see this box for an examplte

	**Try it**
	- use the *live docs* (bottom right) to help you see the definition of the code you are writing
	- modify and save the worksheet
	- Write maths using dollar signs and LaTeX syntax, e.g. by modifying the equation below. Notice the dollar signs have to be touching the maths...no spaces! Learning LaTeX syntax will be an ongoing exercise, **necessary for the exam**, over the next few weeks.
	$$x^2 + y^2 = \frac{a}{b} + \int_1^3 \gamma(t) \ dt$$
	- [detexify](https://detexify.kirelabs.org/classify.html) and [cheatsheet](https://quickref.me/latex.html) are your friends.
	- note that **comments** can be made in code blocks using the comment icon #. Comments don't affect the code. You will see commented code below.

## What to do:

- Go through the worksheet. Make sure you understand and can manipulate **every code block**. Read the comments in the code as well as the textboxes.
- Do the questions. 
- Add your own comments, explanations and code to the worksheet. Save it. It's yours now!
"""

# ╔═╡ 3f27caa1-adb2-4eb9-8a5e-bbd389acfe94
tip(md"""This is your notebook now! Make lots of comments and modifications that you can refer to during exam revision.""")

# ╔═╡ b940e524-301e-45e5-b3a7-bf5626f2daee
md"""
# Assignment

Think of the concept of a **noun** in English (or any other human language). It binds a word to a concept. For instance, when you read *Dhruva* (a proper noun), you might conceptualise me. When you read *person*, you might conceptualise the more abstract concept of an arbitrary human being.

When programming, we create our own nouns (others are already provided by the programming language). These are known as **variables**. They link an expressible, readable name (e.g. `x`) to a julia object (e.g. the `Float64` number: `1.0`). 
"""


# ╔═╡ 8648720b-9b06-449e-831a-2e89c6e1a22d
x = 1 ## assigning variable name x to 1. = means assignment

# ╔═╡ b84e8be0-cb67-45de-b64e-c8efa6aaac09
_my_variable = 3 ## name variables however you like as long as they don't start with numbers or special characters

# ╔═╡ 83cefa74-091d-4cb2-8538-a382486e4aff
md"""
 - We can use any ASCII symbol as a variable. For **letters**:
	-In your code box, type \ , then tab, then scroll down your list of options.
- For **pictographic symbols** (like an owl):
	- In your code box, type \ , then tab, then scroll down your list of options.
EG change the owl below to a cow by typing "\:", then pressing tab, then typing c-o-w and viewing the list of options.
"""

# ╔═╡ d0935c40-49c6-40c2-95fa-54290e78a4a9
🦉 = 3.4

# ╔═╡ 53c366d6-e986-46fd-8ee1-035623023a09
md"""

!!! info "To do"

	- Copy the syntax below to make variables that you can change with your mouse. 
	- (Optional) Go through the PlutoUI.jl tutorial on the Pluto homepage to see how you can make checkboxes, scrubbables, and all sorts of other interactive variables.
"""

# ╔═╡ 29daa38c-eb61-465c-9fe2-87500bc1a420
@bind slide Slider(1:10)

# ╔═╡ e0bced5e-fbd2-4d02-83bd-2d7ecf116875
slide

# ╔═╡ 6aea3218-3655-40f5-bdae-7e878d8cb22a


# ╔═╡ 8bfeb7bb-e713-4e8a-8d2a-542d00544baf
md"""
### Important points about Pluto notebooks

- **There is no top-to-bottom order in the code**. If you define ```y=5``` at the bottom of the notebook, you can use y at the top of the notebook. EG ...
	- try changing y below and see what happens. 
	- Try adding a new code block assigning y to a different value and see what happens.
"""

# ╔═╡ efe36c0b-7ffa-47d5-8b7d-07fbab22c5e5
y = 4

# ╔═╡ b61c093a-7961-45be-9cd1-367c6b1e08ec
x + y 

# ╔═╡ 7764d0ba-df04-4776-b27d-3032ecb82692
md"""
### [Basic arithmetic operators](https://docs.julialang.org/en/v1/manual/mathematical-operations/)

- Try them all out!

| Expression | Name           | Description                             |
|:---------- |:-------------- |:----------------------------------------|
| `+x`       | unary plus     | the identity operation                  |
| `-x`       | unary minus    | maps values to their additive inverses  |
| `x + y`    | binary plus    | performs addition                       |
| `x - y`    | binary minus   | performs subtraction                    |
| `x * y`    | times          | performs multiplication                 |
| `x / y`    | divide         | performs division                       |
| `x ÷ y`    | integer divide | x / y, truncated to an integer          |
| `x \ y`    | inverse divide | equivalent to `y / x`                   |
| `x ^ y`    | power          | raises `x` to the `y`th power           |
| `x % y`    | remainder      | equivalent to `rem(x,y)`                |

"""

# ╔═╡ a5d65532-f1ea-46e3-a7a1-9baf5bd41a9f
tip(md"""use `begin ... end` blocks as below to enclose multiple lines of code in one cell. what happens if you put the two lines of code below into separate blocks, and why?""")

# ╔═╡ db65a793-33bb-4ffb-b4fa-486e94ed3a01
md"""

"""

# ╔═╡ a97f5d6f-5cca-4dbc-a17b-37c53d689f95
begin
	z = 3
	z = z + y
end

# ╔═╡ d5c1013d-a63f-4d7a-9ed9-9b913638223a
md"""## Logic
### In programming
- Logical operators (see below) return a Boolean value: `true` or `false`
- see what happens to the code blocks in this section when you change x from 1 to another number (e.g. 3)
- See [here](https://docs.julialang.org/en/v1/manual/control-flow/) for a more detailed introduction.

| Operator  | Name                     |
|:--------- |:------------------------ |
| `==`      | equality                 |
| `!=`, `≠` | inequality               |
| `<`       | less than                |
| `<=`, `≤` | less than or equal to    |
| `>`       | greater than             |
| `>=`, `≥` | greater than or equal to |
| `!x`       | negation             |
| `x && y`   | short-circuiting `and` |
| `x \|\| y` | short-circuiting `or`  |

- use the live docs to help understand any of these terms 

### In mathematics

- In mathematics we write expressions involving logical operators as well. For instance. [Here](https://en.wikipedia.org/wiki/Glossary_of_mathematical_symbols) is a comprehensive glossary.

> **$x > 1$ implies that $x > 2$**

Some important ones are:

| **Symbol**  | **Explanation**  |
|---|---|
| $$a \Rightarrow b$$  | a implies b   |
| $$a \Leftarrow b$$  | a is implied by b   |
| $$a \Leftrightarrow b$$  | a is equivalent to b   |
| $$a^c$$  | The negation (opposite) of a  |
| $$\therefore$$  | Therefore  |
| $a \land b$  | a and b  |
| $a \lor b$  | a or b  |
| $\forall$  | for all or for each  |
| $:$  | such that  |
| $\exists$ | there exists  |
| $\in$ | is a member of, e.g. $3 \in \mathbb{N}$  |
| $!$ | unique, e.g. $\exists! x \in \mathbb{N}: x > 3 \land x < 5$  |


!!! info "Question"
	1. Write the following out in English:
	$$\exists! x \in \mathbb{N}: x > 3 \land x < 5$$
	2. Write the following in Maths:
	> For each integer $n$, there is a rational number $r$ such that $n \times r = 1$. 
	3. Is the above statement true?

!!! info "Answer"
	1. There exists a unique Natural number $x$ such that $x$ that is greater than 3 and less than 5.

	2. $\forall n \in \mathbb{Z}, \exists r \in \mathbb{Q} : n \times r = 1$

	3. The above statement is FALSE: It does not hold for $0 \in \mathbb{Z}$.

!!! info "Question"
	If $$a \Rightarrow b$$ then what is the relationship between $a^c$ and $b^c$?




"""

# ╔═╡ be21a94e-875f-4789-93f9-a6f4bdad58bb
hint(md"""Suppose $a$ is the set of people over 25, and $b$ is the set of people who can legally drink alcohcol""")

# ╔═╡ cb733e61-62fe-4977-a066-66c180140919
md"""
!!! info "Answer"
	If $a \implies b$, then $a^c \implies b^c$.
"""

# ╔═╡ 413aee18-7a45-4c0b-b80f-0f0f5037a9f6
x == 1 ## == is a test for equality. DIFFERENT from =. This is a LOGICAL OPERATOR (returns true or false)

# ╔═╡ c19142d2-8c2c-42d6-b5b0-184e01b53966
x == 2

# ╔═╡ b5241062-1d2b-4a85-8815-5521f2694d72
x !== 1 #prefacing logical opterators with ! negates them. 

# ╔═╡ 4eec63f3-1bbb-4f59-9aa7-551b4e36bcec
x ≠ 2

# ╔═╡ fcb4f6aa-e0f3-4197-bafe-31740c39cafd
(x == 1) || (x == 2)  # The OR operator

# ╔═╡ 53bdb12b-0803-48e9-8970-7b06ae611079
(x == 1) && (x == 2) # The AND operator

# ╔═╡ 2cabaae1-3539-478c-8d6d-ef2ce7cbc40c
md"""
(Optional): The **ternary** logical operator below works as follows:

` a ? b : c`

means:
	
>if a evaluates to `true`, then run `b`. else run `c`

"""

# ╔═╡ 7cf1c5f0-e2d6-4150-8c8a-6f48f9ddc430
x == 1 ? print("x is 1") : print("x is not 1. It is $x") 

# ╔═╡ 6cd79c82-6817-4a4d-8a08-70fa57df3a77
tip(md"""Note the use of a single dollar sign above to access a julia variable inside text. This is known as [string interpolation](https://docs.julialang.org/en/v1/manual/strings/#string-interpolation) """)

# ╔═╡ 834cc48d-067d-42e5-89a5-67b078738475
md"""
!!! info "Question"
	Modify the code below from (x==2) to (x==1). What happens? Why? If you're confused, refer to [the julia docs](https://docs.julialang.org/en/v1/manual/control-flow/#Short-Circuit-Evaluation)
"""

# ╔═╡ 21991df6-74e8-49a3-bf58-ab76f0d6024f
(x == 2) && (print("hi"))

# ╔═╡ e17ae741-e9b0-4ca1-8fe4-3f839571ca3c
==(x, 1) == (x == 1) # make sure you understand this code

# ╔═╡ e7482d85-ffa7-4d64-8b76-fd12d57c0314
md"""
!!! info "Answer"
	After modification, the cell's output changes from ```false``` to ```hi```.  This is because the ```&&``` operator has the short-circuit evaluation property.  Given a chain of ```&&```'s, julia will stop evaluation at the first ```false``` it encounters, without evaluating the other arguments.  Thus, ```x==2``` is originally false, and so it does not continue evaluating the expression.  However, when we change this to ```x==1```, julia evaluates the next argument, which in this case is a function all.  Hence, the output changes.
"""

# ╔═╡ 9665d674-5c3c-4a48-8677-42e44e68ac89
md"""
### If statements

```julia
if a 
	b
elseif c
	d
else e
end
```
- `a` and `c` must be booleans, i.e. they evaluate to `true` or `false`. 
- b gets evaluated if a is true
- you can add as many elseif blocks as you like.

!!! info "Question"

	What combination of booleans causes `d` to be run? Hint: it's not `c == true`

!!! info "Answer"

	We must have ```c == true``` AND ```a == false```.  If ```a == true```, we will simply output ```b``` and skip to end.

#### An example:
"""

# ╔═╡ f3a1cbdb-bdfc-44d1-b1ba-260d9277502a
tip(md"add as many `elseif` statements as you like, but only one `else`. Can you see why?")

# ╔═╡ 74cd42cf-db7c-4afc-918e-aa08ff545e9e
if (x == 1)
	println("x == 1")
else # having an 'else' is optional
	println("x !== 1. Actually, x == $x")
end

# ╔═╡ 86c63bd0-7c11-4ead-bb22-9d251496a8fe
md"""
!!! info "Question"
	Replicate the `if-else-end` statement in the above code using ONLY the *and* operator, i.e. `&&`. You will need to use the latter **twice**.
"""

# ╔═╡ 0a945305-4699-4ea8-abed-0e412f325afa
begin # do the above question here
	(x == 1) && println("x == 1")
	(x != 1) && println("x !== 1. Actually, x == $x")
end

# ╔═╡ b05cc073-0021-42a8-8629-b441136e4194
md"""
- you can also add any number of elseif statements to your `if-elseif-else-end` block
"""

# ╔═╡ d3e6ca9e-f408-4399-81d4-4de5eadd544c
if (x == 1)
	println("x == 1")
elseif (x==2) # you can also add as many elseif blocks as you like
	println("x == 2")
else # having an 'else' is optional
	println("x !== 1. Actually, x == $x")
end

# ╔═╡ 63dc8b2e-ca87-4c1a-9fde-275c48e5429f
md"""
# Functions

- This is a basic introduction. For the more ambitious, read [this](https://docs.julialang.org/en/v1/manual/functions/).

## Calling functions

- Some variables are known as **functions**. Some functions come pre-installed. Others, you will assign yourself.
- Functions **transform** variables. They have **inputs** and **outputs** which both consist of single/multiple variables.

```julia

function some_function(input1,input2) 
	# function body: write code here
	return output1, output2, output3
```
- Writing a function, as above, **does not run the code in the function body**. We first need to **call** the function... 
```julia
a = 1; b = 2
o1, o2, o3 = some_function(a,b) # inside the function body, a/b will be referred to as input1/input2 respectively
```
- As seen above, we append inputs in round brackets to the name of the function to call the function. This runs the function body code, with `input1=a` and `input2=b`.
- In the example above, the same julia objects ($1$ and $2$) are referred to as `a` and `b` in **global** scope (i.e. outside the function), and as `input1` and `input2` in **local scope** (inside the function body)

- The previously listed [operators](https://docs.julialang.org/en/v1/manual/mathematical-operations/) are all functions. However, they are called in a special shorthand notation, for convenience. For instance, instead of writing:
```julia
+(x,y)
```
to add two numbers, we can write 
```julia 
x+y
```
...but you can use either notation!

"""

# ╔═╡ e268620b-847d-4088-9de5-9b9a7751c497
println("hello, x = $x") #println is a function that writes its input to standard output in the terminal.

# ╔═╡ dcde66b8-f880-41ff-9c92-016cd0720789
+(3,4,5) # + is a function that adds all its inputs. If there are two inputs, you can also write the natural shorthand '3 + 4' instead of +(3,4). 

# ╔═╡ b58bc78c-2461-48c7-a2ce-0a85a41f8762
^(3, 4) == 3^4 # other common mathematical functions have a similar shorthand.

# ╔═╡ bb652a0f-d8fd-499b-9ac5-dfcbc418ed9d
sin(4.0) # another standard function. 

# ╔═╡ c640307a-5f25-4285-a90d-ecbb9c6f350d
md"""
## Building functions

- Now we will write our own function, which takes the square of its input, multiple times and in different ways...
"""

# ╔═╡ b0b026e5-27c5-458b-acea-8d7f1f937a1f
function square(x) # the x here has NOTHING TO DO with the x above. 
	println("lots of complicated code")
	println("by the way, x is $x at the moment in this scope. The x living in global scope has been overwritten within this function and we don't have access to it. It hasn't been overwritten outside this function, though!")
	return x^2 # the output of the function is prefaced by 'return'
end

# ╔═╡ 99914305-de78-4805-b31e-a985663a227a
square(4) # x = 4 inside the scope of the function square when this code is run

# ╔═╡ c9fd719a-e68f-4343-b481-4d99e0569fd5
md"""
#### Observations:
- the 'x' in square x has **nothing to do with** the x we assigned previously. It is defined in **local scope**, as the input to `square`. 
- Defining a variable in local scope **overwrites** any assigned value in a higher scope. If a global scope variable isn't overwritten, it can be accessed!
- Play around with `scope_fun` below to get the hang of it:
"""

# ╔═╡ e55ccd35-7dad-4b5d-96f5-3c83e6032f26
function scope_fun(a,b)
	println("x = $x from global scope in scope_fun" )
	function nested_fun(x,y)
		println("x = $x inside the nested_fun")
		return x + y
	end
	return x + nested_fun(a,b)
end

# ╔═╡ 35c1f0e0-3b25-4438-afc6-09981107f39d
scope_fun(4,2)

# ╔═╡ 2bc8b055-e14b-4ebb-9789-0af8bbeaa672
md"""
### Shorthand syntactic conventions for building functions

- The multiline 
```julia 
function some_function(...)
	return ...
end
```
syntax is annoyingly verbose for short one-line functions. Here are easier alternatives:
"""

# ╔═╡ d6fce804-4383-4fbc-bbfb-e52c81717650
square2(💿) = 💿^2  # best way to write short single-line functions

# ╔═╡ 8c2db912-07b0-4cfc-a1f3-5a7463685002
square3 = 🐂 -> 🐂^2 #another way 

# ╔═╡ 89ead102-3792-4a4d-9809-bdb4bc54320b
add(x,y) = x + y #functions can have multiple inputs

# ╔═╡ 5de02ff4-0f10-4cf7-a555-ea96bc8b5464
function useless_function(x) # functions can have multiple outputs
	return ("I do nothing 🤷", x)
end

# ╔═╡ f93dab8d-7afd-40dd-ae68-0fac5f193edd
a, b = useless_function(40)

# ╔═╡ 689079c5-f63d-4a67-a5f5-727516fd4720
a

# ╔═╡ 61e8cc92-95b7-4db5-9cd8-9bd70d603e12
b

# ╔═╡ 9efda440-5d47-48b8-af2f-04c9854c1215
md"""
!!! info "Question"
	**Functions that return a function**

	Fill in the ```pow``` function below. ```pow(n)``` should return a function ```x -> x^n```. So ```pow(4)(3) = 3^4``` and ```pow(10)(2) = 2^10```
"""

# ╔═╡ 378c2153-ae44-4725-a53a-3b01e603c518


# ╔═╡ 46c53268-bce5-4707-8999-cf5f33032de3
function pow(n)
	inner_pow(x) = x^n
end

# ╔═╡ fc72a5d0-3520-468a-af38-533768e331dc
if !(typeof(pow(4)) <: Function) 

	md"""$(keep_working(md"pow is not returning a function"))"""


elseif (pow(3)(7) == 7^3)
	
	md"""$(correct(md"Well done!"))"""
else
	md"""$(almost(md"pow is returning a function...but it's the wrong function!"))"""

end

# ╔═╡ 027ec3b8-a637-4c56-8663-738fe468a7e4
md"""
# Sets and Types

## Sets

- A set is a collection of **things** (anything!). By default a set is **unordered**: there is no `first`, `second`, or `last` element of the set. 

In mathematics, some common sets (**which you should google now**) are:
-  $\mathbb{N}$: the natural numbers.
-  $\mathbb{Z}$: the integers. 
-  $\mathbb{Q}$: the rational numbers 
-  $\mathbb{R}$: the real numbers 
-  $\mathbb{C}$: the complex numbers 

!!! info "Notation" 
	-  $\subset$ means: "is a subset of"
	-  $\subseteq$ means "is a subset of, and may be the entire set"
	-  $\in$ means: is a member of
	-  $A\cup B$ means: the union of sets $A$ and $B$.
	-  $A \cap B$ means: the intersection of sets $A$ and $B$. 	
	-  $A^c$ means: the complement of $A$. IE the set of things **not** in $A$.
	Make sure you can write the LaTeX for all introduced notation!

Of course, we can and will make our own custom sets of numbers. Sets **are denoted with curly braces**. For instance, let's make a set:

$$S = \{1, 2\}$$

- Contrary to appearances, there is **no first/last element in this set**. Remember, sets are **unordered**. 

Let's make some more sets 

$$S_2 = \{x : x^2 > 10 \}.$$

This means: $S_2$ is the set of $x$ such that every property to the right of the colon ":" is satisfied.

$$S_3 = \{(x,y) : x = y\}$$
What does this mean?

"""

# ╔═╡ 4176f474-dc69-43a6-a3b3-99e1a7817eb5
md"""
!!! info "Question" 
	- What are $S \cap \mathbb{N}$ and $S \cup \mathbb{N}$?
	- Is $S \subset \mathbb{N}$?
	- Verbally translate the following set. Rephrase it in mathematics as the intersection of two sets.
	$$S = \{x : \mod(x, 3) == 1; \quad x^2 > 15\}$$
	- Write, in maths, the set of **pairs** of elements for which the second element in the pair is twice the first element in the pair

!!! info "Answer" 
	- Intersection: $S \cap \mathbb{N} = S$, union: $S \cup \mathbb{N} = \{x \in \mathbb{N} : x > 2\}$
	- Yes: every element in $S$ is also an element of $\mathbb{N}$.
	- The set $S$ is the set of all numbers whose square is bigger than 15 AND who have 1 as a remainder when divided by 3.  Let $T = \{x : x\, \mathrm{mod}\,3 = 1\}$ and $U = \{x : x^2 > 15\}$.  Then $S = T \cap U$.
	- Let $\mathbb{F}$ denote the set we draw elements from.  The requested set of pairs can be written as $S = \{(x,y) : x,y \in \mathbb{F};\; y = 2x\}$

!!! info "Question"
	Note the graphical similarity between the following operators: 
		$$\cup \approx \lor, $$ 
		$$\cap \approx \land$$. 
	Is there a relationship between them?

!!! info "Answer" 
	Yes: both $\cap,\cup$ and $\lor, \land$ correspond to Boolean algebras over sets, and logical expressions, respectively. What does this mean? $A \cup B$ is the set of things that are in $A$ OR in B. $A \cap B$ is the set of things in $A$ AND $B$.  

Let's do some set operations in Julia. 
- Recall that all of the operators are functions. We are using the shorthand notation, e.g. `S ∪ T`. We could instead use the full notation `∪(S,T)`.
"""

# ╔═╡ 045e7d2f-09a0-422e-889d-d4d36ccdfa3d
md"""
!!! info "Question: Russell's Paradox"
	Let $A$ be the set of sets that do not contain themselves. 
	1. Write $A$ out in mathematical notation
	2. Is $A \in A$? 

"""

# ╔═╡ 96ea52f1-627d-4c76-85d1-8b3c2cb89201
md"""
!!! info "Answer"
	1. $A = \{X : X \notin X \}$
	2. 
	-  $A \in A \Rightarrow A \notin A$ 
	- But $A \notin A \Rightarrow A \in A$ from 1. 
	- So $A \in A \Leftrightarrow A \notin A$.

	The construction of the set leads to logical contradictions, so that this question cannot be answered.  Formal set theory restricts the types of sets you can construct precisely to avoid these kinds of problems.  If you're keen, lookup the Axiom of Comprehension!
"""

# ╔═╡ da3586b0-4066-4c45-a9ea-9b04cbed0225
S = Set((1,2))

# ╔═╡ 449c4bb1-ad79-4bb7-a24f-616b7fbf9b20
_sets_are_unordered = Set(1:10) #a:b is a 'range' that returns all integers between a and b

# ╔═╡ 6688fc7a-efa8-4919-947d-95de534498b4
T = Set((3, "three"))

# ╔═╡ f1a592e6-65a9-4cca-ad79-7bf3fbe499ee
S ∪ T

# ╔═╡ 6b9caa54-2088-4a7b-855b-b655ed151e1c
S ∩ T

# ╔═╡ 2507ef8a-01ae-45b7-af41-6b9416b94ca8
setdiff(S, T)

# ╔═╡ be2bc4aa-5b1f-432c-b8d6-d8b5fea6b485
setdiff(T,S)

# ╔═╡ 81c9d9fb-bfaf-4a4a-8c14-04dc9a16b460
S ⊆ T # subseteq is a **logical operator** in julia.

# ╔═╡ a753088d-45b7-4906-be12-725fab875a91
md"""
## Types 

- We've referred previously, and implicitly, to different types of Julia objects. Clearly, functions are not the same as integers, for instance. 

- There is an explicit classification scheme for different julia objects. This is known as the **type system**. 

- A good analogy is phylogenetic trees in Biology. Just as:

> Homo sapiens <- Homo <- Hominidae <- Primates <- Mammalia <- Chordata <- Animalia

we have 

> `Int64 <: Signed <: Integer <: Real <: Number <: Any`

> `Function <: Any`

Note the notation `<:` to denote: *is a subtype of*

- **Every** julia object belongs in a typetree. 
- **Every** julia object is a subtype of `Any`. 

### Concrete vs abstract types

- Notice that one can have an explicit instantation of *Homo sapiens*. For instance, me. *Homo sapiens* is a species. 
- One **can't** have an explicit instantiation of e.g. Mammalia, that is not also something more specific. There is no creature that is just a mammal, and not a concrete species as well.

- All julia objects belong to a **concrete** type (also called a struct). You can build explicit instantiations of concrete types. They are like species.

- Other julia objects are called **abstract types**. You can't have an explicit instantation of an abstract type. In the same way that you can't have an animal that is just a mammal, and not also a member of a more specific species. But concrete types (e.g. Homo sapiens) can be subtypes of abstract types (e.g. mammal).

- Types themselves have a type: `DataType`. Explore for yourself!
"""

# ╔═╡ 36a0261f-f72a-46d8-9517-098ead54307c
typeof(1)

# ╔═╡ 870cdb15-ea28-46d4-912b-8b4c14341110
supertype(typeof(1))

# ╔═╡ 7a3ed315-a39d-4f7e-8283-8db9b18c7f9b
isconcretetype(Signed)

# ╔═╡ 7af16be4-f539-49a6-bd18-a1c6f7cc8b5b
isconcretetype(Int32)

# ╔═╡ 3aee4d24-421a-4909-960b-0d1fa902aa70
supertype(supertype(typeof(1)))

# ╔═╡ dbb9daa2-bb0a-4ba2-b63a-5acf4ccd02f2
typeof(typeof)

# ╔═╡ ddef6d2b-8b83-4946-8bfb-dc7d9ad83e83
md"""
- Even code itself has a type!
"""

# ╔═╡ 57747b7f-21d8-4933-ab46-5ce8d1c95bdc
some_code = :(x=1; y = x + 2; return y)

# ╔═╡ 67716938-279e-48c0-8c07-0c6244fe3769
typeof(some_code)

# ╔═╡ 1b72ba6e-f1ee-4c09-8c08-f4ad249f73fc
eval(some_code)

# ╔═╡ 5ad9cb4b-bce2-4243-9083-d9b2b0cbc677
md"""
##### Alternative notation:

Look up the infix operator, |> on the Live Docs. It's also called the piping operator.
"""

# ╔═╡ ab3f7bd5-e989-4acb-bb4e-3f46f92abacd
# alternative notation with infix operator
typeof(1) |> supertype |> supertype |> supertype

# ╔═╡ 451c9502-4bd7-4d5d-be4a-bf8ba9ad45a0
md"""
Explore the types of these objects:
"""

# ╔═╡ 69a5924e-6005-4728-a4e3-c43f433de800
ones = Set(("1", 1f0, 1.0, 1, Int8(1), :one, 1:1, (1,), [1], [1;;]))

# ╔═╡ 7fdd6846-1eef-413a-8614-e4adeb3dfcf3
md"""
### Type assertion

The notation `x::T` ensures that the variable `x` is of type `T`.

- Change the type assertion below from `Number` to `String`. What happens? What about if we change it to `Int64`?
"""

# ╔═╡ 8d58b868-3444-4867-93cc-e0f203453683
1::Number

# ╔═╡ 5d86058f-586f-47cb-bb81-92d87a2293b8
md"""
## Make your own types
"""

# ╔═╡ e11d53a2-5401-45b4-8ae8-ff4758d3faea
abstract type Organism end #we cannot make an explicit instance of an organism, as it is abstract

# ╔═╡ d08d181d-484f-4113-937b-2e87a78bdfa0
abstract type Animal <: Organism end #we cannot make an explicit instance of an animal, as it is abstract

# ╔═╡ abc7cae7-eb5f-4b14-86c5-e61443fda5fb
struct Elephant <: Animal # Elephants are concrete types. We can make explicit elephants
	name::String # ensures that name is of type String. Errors otherwise
	weight::Number 
end

# ╔═╡ 51404142-836a-4469-8141-028243503c8d
abstract type Fungus <: Organism end 

# ╔═╡ 0ece90dd-1218-43f2-94c8-13eab4d2320e
struct Shitaake <: Fungus
	weight::Number
end

# ╔═╡ 84a6e004-061b-45a5-a76e-52610b80ec46
nellie = Elephant("nellie", 2300)

# ╔═╡ 9c7ad6f3-3338-4ab6-819d-317b508e6322
elmer = Elephant("elmer", 2500)

# ╔═╡ cca208ce-dad7-4a6b-a2f8-e53f0706d9e8
tasty = Shitaake(0.3)

# ╔═╡ 32144885-befa-4de0-a90a-18e725436411
md"""
## Methods: specialising functions to types

- Previously, we made functions that took in code objects (e.g. numbers), and also outputted code objects. 
- We can make functions that do **different things** based on the type of the input. See below
"""

# ╔═╡ 4d78f6da-da62-47d8-ace0-fd408a610647
function double(x::Integer) 
	println("I'm an integer!")
	return x+x
end

# ╔═╡ 7ff2a4f1-c815-4e42-9d59-eb11ee43a896
function double(x::String)
	println("And I'm a string!")
	return x*x
end

# ╔═╡ 8eaa5b10-48f8-42a8-b270-ab0a00efe840
md"""
## Abstraction through types
#### What did we just do??
- We've made a **single** function called `double`, that has **two methods**. If `typeof(x) <: Integer` (written as `x::Integer`), then one method is called. If 
`x::String`, then another method is called. 

- This is an example of **abstraction**. We have an **abstract concept** of doubling that makes sense in the context of both strings and numbers. By type-specialising our functions, we've built a way of expressing our abstract notion of doubling that extends to both numbers and strings.

!!! info "Question"
	- Try to make another method for double that operates on Sets. Does it work as intended? If not, why?
	- In Python, 'doubling' a string corresponds to adding it with itself (i.e. `x + x`) instead of multiplying it as in Julia. Why do you think the Julia language creators made this design decision? Hint: googling *commutativity* might help you.
"""

# ╔═╡ ef91b505-ecc5-4bcd-9e25-9c6fe54bbbec
md"""
!!! info "Answer"
	- See below.  Because each item in a set is unique, doubling a set is not like doubling a string: only one copy of each item is retained.  Thus, doubling a set naively returns the original set!! This is the answer

    **Extension**: instead, below we create a `double-like` function that returns the 	cartesian product (set of ordered pairs) of a set with itself.  This highlights 	another property of a set: because sets are unordered, we have to consider all 		combinations of pairs.
	- **Doubling a string**: This is because the order of concatenation matters: ```"hello " + "world"``` is not the same as ```"world" + "hello "```.  Thus, concatenation is not commutative.  The ```+``` symbol is usually reserved for commutative operations.
"""

# ╔═╡ 291ad71d-db9f-4d8b-ba84-8bdcba9e1600
cartesian_product(S::Set) = Set((i,j) for i in S, j in S)

# ╔═╡ 3af92217-0239-4a16-a6e9-2cb5927474e7
cartesian_product(S)

# ╔═╡ d354417c-91a1-40d3-8489-395c489f89b1
double(S::Set) = S ∪ S

# ╔═╡ 6a039f8f-a3e3-4b1e-af95-95669036aa9e
md"""
!!! info "Question"
	- What happens if we input a type for which a method hasn't been defined? EG `double(tasty)`?
	- Can you build a `fallback` method which works for arbitrary types, and tells the user that `doubling has not been defined for type xxx`?
"""

# ╔═╡ e4cd1b22-afc2-4ec4-90aa-c5e7b8aa87bc
md"""
!!! info "Answer"

	- If you input a type for which a method hasn't been defined, a MethodError will be thrown.
	- You can build a function with the same name, but which accepts the ```Any``` type, and print the given string.  An example is below.
"""

# ╔═╡ 1fe65966-328a-4986-b02d-8d8cf889b915
function double(s::Any)
	println("Doubling has not been defined for type: ", typeof(s))
end

# ╔═╡ 3f422bc5-6f5b-40d9-8bb0-85fb44c3798c
double("hi")

# ╔═╡ bb17f741-95c6-4126-8b4d-4549332671c3
double(3)

# ╔═╡ c39dfe80-94ff-4a82-859b-e779d09761ba
double(S) # is just the same as S!

# ╔═╡ f2c8a628-beb6-4374-b8cd-800cbbeb44f9
double(tasty)

# ╔═╡ 8d62f275-f2d0-4817-972c-d346270c405d
md"""
### Order of type specialisation
"""

# ╔═╡ 40458048-7c42-46d9-8ccd-cb08ba95ead5
interaction(a::Animal, f::Fungus) = "yum"

# ╔═╡ c91be6d5-8c39-4b20-a56d-e7796245a4ab
interaction(::Animal, ::Animal) = "greet" #if we aren't using the objects in the function, we don't need to assign them variable names

# ╔═╡ 9b8c9d1f-f8c2-418f-89cc-2a16ce0a8778
interaction(::Elephant, ::Elephant) = "trumpet"

# ╔═╡ f6b17de8-84a7-40d3-8105-affedb3b4391
interaction(nellie, tasty)

# ╔═╡ 4cf3f17d-90c7-4150-b2f4-e538c3b6e027
interaction(nellie, elmer)

# ╔═╡ ac19a248-ccae-4156-889b-dd53e94df45a
md"""
- Note that there are **two** methods above that could refer to `interaction(elmer, nellie)`: `interaction(::animal, ::animal)` and `interaction(::elephant, ::elephant)`
- Julia chooses the most specialised method (i.e. the ones that are furthest down on the type tree). If it's ambiguous, you will get an error!
"""

# ╔═╡ caf25888-c000-43cc-949e-927705faa578
md"""
!!! info "Question"

	- Make a function `weight()` with a **single method** that will return the weight of any animal or fungus. 
	- Make a new abstract type: `Prokaryote`, and a concrete struct representing a prokaryotic species. Don't add a `weight` field to the struct.
	- Add a new method to `weight` such that the weight of any prokaryote returns `NaN`
"""

# ╔═╡ 7680c625-fc26-42e9-b442-0a4ec265a235
md"""
!!! info "Answers"
	See below
"""

# ╔═╡ 37340894-2114-4c70-a697-db1ebf37b695
function weight(o::Organism)
	o.weight
end

# ╔═╡ 1ba22a79-1527-43b5-a520-e8da8e6e6101
abstract type Prokaryote <: Organism end 

# ╔═╡ 90bb3802-e6cb-43b8-ac06-1e51771e6816
struct EColi <: Prokaryote 
	name::String 
end

# ╔═╡ 5041fdf4-a390-439d-ad37-05b4e25a9a12
colleen = EColi("colleen")

# ╔═╡ 5b4f0206-cd9d-4c3b-b377-484b438b2788
function weight(a::Prokaryote)
	NaN
end

# ╔═╡ 57f29534-e37a-4ffb-9a2a-6e24bc2e32bf
weight(nellie)

# ╔═╡ 50b57258-a22a-4863-bcb5-244266c02d30
weight(tasty)

# ╔═╡ fd7c7549-0504-4547-8e42-a59bcacd8a20
weight(colleen)

# ╔═╡ 22b74523-f971-461c-a3ce-a5e02f7d21dc
md"""
## Type conversion 
- Calling a type as a function will convert its inputs to that type, if allowable. See examples below
"""

# ╔═╡ 7ddc7fa6-fb07-48f4-9e2d-d45cab1dd104
Float64(1//2) ## // denotes divided by, if you want to keep the answer as a fraction

# ╔═╡ df1c16c0-a103-454f-ae0b-4ee0362bdfe7
Float64("one half")

# ╔═╡ fe324d86-0975-4936-b20a-783fbcbfc5a2
md"""
!!! info "Question"
	Make a function `denom`, that returns the denominator of the rational representation of a number. `denom` should have three methods, for Integers, Floats and Rational numbers respectively. No `if` statements allowed!
"""

# ╔═╡ 645b2293-297e-498f-9693-4288ce905e4e
denom(x::Integer) = 1

# ╔═╡ a68bc144-3176-4901-8d86-65ec6f9194ff
denom(x::Rational) = denominator(x)

# ╔═╡ fa42b229-43bd-45da-8b97-37b7f10b76e8
denom(x::AbstractFloat) = denominator(rationalize(x))

# ╔═╡ d6c2bc4c-289a-4111-a622-a602d3512ff4
denom(3//4)

# ╔═╡ 2da02e06-6789-44c1-bac1-4a8a51bd2e29
begin
	_a = isequal(denom(3),1)
	_b = isequal(denom(3//4),4)
	_c = isequal(denom(0.4),5)
	!_a && 	keep_working(md"`denom` isn't working for Integers")
	!_b && 	keep_working(md"`denom` isn't working for Rationals")
	!_c && 	keep_working(md"`denom` isn't working for Floats")
	all((_a,_b,_c)) && md"""$(correct(md"Well done!"))"""
	
end


# ╔═╡ 3bce8f64-6bd4-42e4-a000-dcef73a8bb87
md"""
# Mathematical functions

- Mathematical functions map elements of one set to elements of another set. The set of inputs is known as the **domain** and the set of outputs is known as the **range**. The latter is not to be confused with the abstract type `range` in Julia.

- A function **can never map one input into many outputs**. IE it can never be a 'one-to-many' mapping. 

For instance

$$f: \mathbb{R} \to \mathbb{R}^+; \quad f(x) = \sqrt{x}$$

means: $f$ is a function with domain $\mathbb{R}$ and range $\mathbb{R}^+$

!!! info "Question"
	- Why did we pick $\mathbb{R}^+$ and not $\mathbb{R}$?
	- Can we write a legitimate function that maps all reals (including negatives) to both of their square roots (positive and negative) without being one-to-many? The following sets might help you:
	$$S = \{(x,y) : S = x,y \in \mathbb{R}\}$$
	$$T = \mathbb{R}$$

!!! info "Answer"
	- The square root is a one-to-many operation, since $(-x)^2 = x^2$.  EG $9$ could map to $3$ or $-3$. By choosing the positive branch, we now have a one-to-one mapping, and thus, a function.
	- Create a set valued function that gives a single set containing both square roots. So $f(9) = \{3, -3\}$.

!!! info "Definition: Injectivity"
	- A function that maps every element of its domain to a unique element of the range is **injective**. In other words, no two elements in the domain map to the same element of the range. We can write this mathematically:

	Given a function $f:X \to Y$, f is injective if

	$$\forall x_1, x_2 \in X \text{ s.t. } x_1 \neq x_2 : f(x_1) \neq f(x_2)$$

	- **Translate this into English**. The symbols (which you should remember!) are:
	
	-  $\forall$ - for all
	-  $\text{ s.t. }$ - such that
	-  $\in$ - belonging to the set
	-  $\exists$ - there exists
	-  $!$ - whatever comes before is unique. So for instance $$\exists! x \in \mathbb{R} : x^3 = 9$$ means there exists a unique $x$ in the real numbers such that $x^3 = 9$.

	Note that "!" means one thing (*unique*) in maths, and another thing (*not*) in Julia!!!

	


!!! info "Question: Surjectivity"
	A surjective function maps something in the domain onto **every** element of the range.

	- Can you write this in mathematics, as we did for injectivity?

!!! info "Answer"
	Given a funciton $f:X \to Y$, f is surjective if

	$$\forall y \in Y, \exists x \in X : f(x) = y.$$

!!! info "Definition: Bijectivity"
	A function is bijective if it is both injective and surjective. 




!!! info "Questions"

	Injective, surjective, bijective, or none of the above? 

	1. $f:\mathbb{N} \to \mathbb{N};  \quad f(x) = x + 1$
	2. $f: \mathbb{Z} \to \mathbb{Z}; \quad f(x) = x + 1$
	3. $f: \mathbb{R} \to \mathbb{R}; \quad f(x) = 10x$
	4. $f: \mathbb{R} \to \mathbb{R}; \quad f(x) = x^2$
	5. $f: \mathbb{R} \to \mathbb{R};\quad f(x) = x^3$

!!! info "Answer"
	1. Injective, but nor surjective.  There is no $x\in\mathbb{N}$ such that $x + 1 = 1$.
	2. Injective and surjective.  Tip: if you can spot an inverse function, you immediately know a function is bijective.  Here the inverse function is $f^{-1}(x) = x-1$.
	3. Same as above.  The inverse is $f^{-1}(x) = x/10$.
	4. Neither.  $x^2$ is never negative, so it does not cover the range (hence, not surjective).  Also, $(-x)^2 = x^2$, so $f$ is not injective.
	5. Injective and surjective.  The inverse function is $f^{-1}(x) = x^{1/3}$.

!!! info "Definition: Inverses"
	A function $f: X \to Y$ has a **left** inverse $f^{-1}:Y \to X$ if for every $x \in X$, the following holds:

	$$f^{-1}\big( f(x)  \big) = x$$

	A function $f: X \to Y$ has a **right** inverse $f^{-1}:Y \to X$ if for every $y \in Y$, the following holds:

	$$f\big( f^{-1}(y)  \big) = y$$

	A function $f^{-1}$ is an inverse of $f$ if it is both a left inverse and a right inverse. 

!!! info "Questions"

	*Write the answers in mathematical notation to the best of your abilities! I want to see lots of $\exists$, $\forall$, $\in$ signs!*

	1. What's the definition for a function to **not** be injective?
	2. If a function is **not** injective, show that it can't have a left inverse (i.e. that the left inverse cannot be a function due to being one-to-many).
	4. If a function is **not** surjective, show it can't have a right inverse
	5. Given any bijective function $f: X \to Y$, constructively define a function $f^{-1}: Y \to X$ that is a full inverse to $f$. Show why it is a full inverse.
"""


# ╔═╡ eade2c67-b4ec-4d2d-abcb-a4380674e106
md"""
!!! info "Answer"
	1. $\exists x_1, x_2 : (x_1 \neq x_2) \land (f(x_1) = f(x_2))$
	2. Since $f : X \to Y$ is not injective, $\exists x_1,x_2 : (x_1 \neq x_2) \land (f(x_1) = f(x_2))$.  If a left-inverse existed, $f(x_1) = f(x_2) \implies f^{-1}(f(x_1)) = f^{-1}(f(x_2)) \implies x_1 = x_2$.  This is a contradiction, so no left-inverse can exist.
	3. Suppose the right inverse $f^{-1} : Y \to X$ exists.  Since $f : X \to Y$ is not surjective, $\exists y\in Y : \forall x \in X, f(x) \neq y$.  Thus, $Y$ cannot be the domain of $f^{-1}$, since $f^{-1}(y)$ is undefined.  This is a contradiction, and so the right-inverse cannot exist.
	4. Since $f$ is bijective, $\forall y,\, \exists!x : f(x) = y$.  Therefore we can construct a function $f^{-1} :Y \to X$ such that $\forall y, \exists!x : f^{-1}(y) = x$.  This function is not one-to-many due to objectivity. 
"""

# ╔═╡ bab4e011-f2a6-4793-93de-be1b953fa580
md"""
# Number systems, definitions, and axioms

Mathematics is black and white. Things are true or false ([*most of the time!*](https://en.wikipedia.org/wiki/Law_of_excluded_middle#In_mathematical_logic)).

Did you ever play the game as a kid when you ask: "why?" to everything? Something like this:

**Stage 1**

	Adult: *Interesting statement*
	Child: *Why?*

**Stage 2**

```
for i = 1:boredom
	Adult: *Answers the 'why'*
	Child: *why?*
end
```


When we prove a statement in mathematics, we have to start from some **axioms**: statements which we take to be self-evident, and require no evidence or proof. You have to start from somewhere! Anything you then prove mathematically, depends on its axioms.

!!! info "Example"
	If we decided that $x \div 0 = x$, instead of being undefined, then lots of mathematical proofs would break! They **require** this axiom.

As such, mathematics has the concept of an **axiomatic definition**. We will demonstrate by example below:

Let $S$ be a number system. Then the following axioms hold.

"""

# ╔═╡ 9c585825-0919-4b88-a5bc-daf41ee5980b
aside(md"""![](https://imgs.xkcd.com/comics/questions_2x.png)""")

# ╔═╡ 7691b66e-bd79-47f3-a199-85702cae2bff
md"""
!!! info "Definition"
	Let $S$ be a number system. Then the following axioms hold:

	#### Addition
	**A1** (commutativity):    
	
	$\quad \quad a + b = b + a \quad \forall a,b \in S$

	**A2** (transitivity): 

	$\quad \quad a + (b + c) = (a + b) + c \quad \forall a,b,c \in S$

	**A3** (zero):

	 $\quad \quad \exists 0 \in S:  \quad a + 0 = a, \quad \forall a \in S$

	**A4** (additive inverse):  

	$\quad \quad \forall a \in S, \ \ \ \exists -a \in S: a + -a = -a + a = 0$

	#### Multiplication
	**M1** (commutativity):    

	$\quad \quad a \times b = b \times a \quad \forall a,b \in S$

	**M2** (transitivity):    

	$\quad \quad (a \times b)\times c = a \times (b \times c) \quad \forall a,b,c \in S$

	**M3** (one):    

	 $\quad \quad \exists 1 \in S:  \quad a \times 1 = 1 \times a = a \quad \forall a \in S$

	**M4** (multiplicative inverse):

	$\quad \quad \forall a \in S, \ \ \ \exists a^{-1} \in S: a \times a^{-1} =  1$

	#### Addition and multiplication

	**D1** (expanding brackets):

	$\quad \quad (a + b) \times c = a \times b + c \times b \ \ \  \forall \ a,b,c \in S$

!!! info "Defition"
	A number system $S$ where $0 \in S \neq 1 \in S$ is known as a **field**
"""

# ╔═╡ 4b547e32-694f-4e44-9bdf-54ab6260deff
tip(md"""
Lots of things here! But most of them you use subconsciously. Note that we have defined $0$ and $1$ based on **how they interact** with other elements of the number system. Not **what they are**. You could potentially have a number system with more than one $0$/$1$, or where they are the same element!
""")

# ╔═╡ 022974ad-ea41-46fb-8b8d-773caab50631
question_box(md"""
Let $S$ be an arbitrary number system. Prove that 

$0 + a = a \quad \forall a \in S$
using only the axioms above
""")

# ╔═╡ 38ee915e-caf0-48b9-b457-64d5a4b247fe
md"""
!!! info "Answer"
	- By A1, because $a,0 \in S$, we have $0 + a = a + 0$.
	- By A3, we have $a + 0 = a$.
	- Therefore, $0 + a = a$.
"""

# ╔═╡ 09d3cec6-75e9-45a9-bdeb-09019418742d
question_box(md"""
Can you make your own notion of addition so that $S = \{0, 1\}$ is a field? 

How about:
2. $\{0,1,2,3,4\}$
3. $\{0,1,2,3,4,5,6\}$
""")

# ╔═╡ 172a5e25-9595-4b87-8a03-5c800cd33621
md"""
!!! info "Answer"
	
	We can use modular arithmetic to define fields over each of the sets above.  The fields in question correspond, respectively to the *finite fields* $\mathbb{F}_2, \mathbb{F}_5, \mathbb{F}_7$.
	
	For natural number $n\in \mathbb{N}$, we define modular addition as follows:
	
	```math
	\newcommand{\Mod}[1]{\ (\mathrm{mod}\ #1)}
	
	\begin{align}
	(a + b) \Mod n &= (a \Mod n + b \Mod n) \Mod n \\
	(a \times b) \Mod n &= (a \Mod n \times b \Mod n) \Mod n \\
	\end{align}
	```
	
	The following properties hold:
	
	- 0 and 1 are still the additive/multiplicative identity, respectively.
	- Commutativity can be demonstrated by noting the symmetry of the multiplication tables.
	- The additive inverse of $a$ is $n - a$.  For the multiplicative inverses, this can be demonstrated by either (1) forming multiplication tables for the non-zero elements of the sets, and seeing that there is a 1 is every row and column, or (2) using Euclid's algorithm.
	
	Note: the existence of multiplicative inverses relies on the fact that $n$ is prime!  For $n=4$, for instance, one can show that 2 has no inverse.
"""

# ╔═╡ 08d78ff5-0682-4797-ae41-29bbfb53407a
hint(md"""
$\mathbb{F}_p$ is the set consisting of $\{0, 1,2, 3, \dots, p-1\}$, where $p$ is a prime number. It is always a field, as long as $p$ is prime. If you'd like a challenge, prove that such sets are always field! (You'll need Euclid's algorithm, which you could also try and prove)
""")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoTeachingTools = "~0.2.13"
PlutoUI = "~0.7.52"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.0"
manifest_format = "2.0"
project_hash = "85be027b8d13a54f850f173bee146ad85f4c7b68"

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
git-tree-sha1 = "81dc6aefcbe7421bd62cb6ca0e700779330acff8"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.25"

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
git-tree-sha1 = "7364d5f608f3492a4352ab1d40b3916955dc6aec"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.5.5"

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
# ╠═7b83c2d0-603e-4921-8f78-40586a40bcaa
# ╠═e3fe5097-dd80-4c1a-910f-76ed479ac67c
# ╟─949d1634-84c7-4cdc-af17-5ea6798bc46a
# ╟─5ccb8fcf-c4e8-4b24-9667-99e82dec4a86
# ╟─2b15453e-0c4a-11ee-1cc3-198e7e2c6452
# ╟─3f27caa1-adb2-4eb9-8a5e-bbd389acfe94
# ╟─b940e524-301e-45e5-b3a7-bf5626f2daee
# ╠═8648720b-9b06-449e-831a-2e89c6e1a22d
# ╠═b84e8be0-cb67-45de-b64e-c8efa6aaac09
# ╟─83cefa74-091d-4cb2-8538-a382486e4aff
# ╠═d0935c40-49c6-40c2-95fa-54290e78a4a9
# ╟─53c366d6-e986-46fd-8ee1-035623023a09
# ╠═29daa38c-eb61-465c-9fe2-87500bc1a420
# ╠═e0bced5e-fbd2-4d02-83bd-2d7ecf116875
# ╠═6aea3218-3655-40f5-bdae-7e878d8cb22a
# ╟─8bfeb7bb-e713-4e8a-8d2a-542d00544baf
# ╠═b61c093a-7961-45be-9cd1-367c6b1e08ec
# ╠═efe36c0b-7ffa-47d5-8b7d-07fbab22c5e5
# ╟─7764d0ba-df04-4776-b27d-3032ecb82692
# ╟─a5d65532-f1ea-46e3-a7a1-9baf5bd41a9f
# ╠═db65a793-33bb-4ffb-b4fa-486e94ed3a01
# ╠═a97f5d6f-5cca-4dbc-a17b-37c53d689f95
# ╟─d5c1013d-a63f-4d7a-9ed9-9b913638223a
# ╟─be21a94e-875f-4789-93f9-a6f4bdad58bb
# ╟─cb733e61-62fe-4977-a066-66c180140919
# ╠═413aee18-7a45-4c0b-b80f-0f0f5037a9f6
# ╠═c19142d2-8c2c-42d6-b5b0-184e01b53966
# ╠═b5241062-1d2b-4a85-8815-5521f2694d72
# ╠═4eec63f3-1bbb-4f59-9aa7-551b4e36bcec
# ╠═fcb4f6aa-e0f3-4197-bafe-31740c39cafd
# ╠═53bdb12b-0803-48e9-8970-7b06ae611079
# ╟─2cabaae1-3539-478c-8d6d-ef2ce7cbc40c
# ╠═7cf1c5f0-e2d6-4150-8c8a-6f48f9ddc430
# ╟─6cd79c82-6817-4a4d-8a08-70fa57df3a77
# ╟─834cc48d-067d-42e5-89a5-67b078738475
# ╠═21991df6-74e8-49a3-bf58-ab76f0d6024f
# ╠═e17ae741-e9b0-4ca1-8fe4-3f839571ca3c
# ╟─e7482d85-ffa7-4d64-8b76-fd12d57c0314
# ╟─9665d674-5c3c-4a48-8677-42e44e68ac89
# ╟─f3a1cbdb-bdfc-44d1-b1ba-260d9277502a
# ╠═74cd42cf-db7c-4afc-918e-aa08ff545e9e
# ╟─86c63bd0-7c11-4ead-bb22-9d251496a8fe
# ╠═0a945305-4699-4ea8-abed-0e412f325afa
# ╟─b05cc073-0021-42a8-8629-b441136e4194
# ╠═d3e6ca9e-f408-4399-81d4-4de5eadd544c
# ╟─63dc8b2e-ca87-4c1a-9fde-275c48e5429f
# ╠═e268620b-847d-4088-9de5-9b9a7751c497
# ╠═dcde66b8-f880-41ff-9c92-016cd0720789
# ╠═b58bc78c-2461-48c7-a2ce-0a85a41f8762
# ╠═bb652a0f-d8fd-499b-9ac5-dfcbc418ed9d
# ╟─c640307a-5f25-4285-a90d-ecbb9c6f350d
# ╠═b0b026e5-27c5-458b-acea-8d7f1f937a1f
# ╠═99914305-de78-4805-b31e-a985663a227a
# ╟─c9fd719a-e68f-4343-b481-4d99e0569fd5
# ╠═e55ccd35-7dad-4b5d-96f5-3c83e6032f26
# ╠═35c1f0e0-3b25-4438-afc6-09981107f39d
# ╟─2bc8b055-e14b-4ebb-9789-0af8bbeaa672
# ╠═d6fce804-4383-4fbc-bbfb-e52c81717650
# ╠═8c2db912-07b0-4cfc-a1f3-5a7463685002
# ╠═89ead102-3792-4a4d-9809-bdb4bc54320b
# ╠═5de02ff4-0f10-4cf7-a555-ea96bc8b5464
# ╠═f93dab8d-7afd-40dd-ae68-0fac5f193edd
# ╠═689079c5-f63d-4a67-a5f5-727516fd4720
# ╠═61e8cc92-95b7-4db5-9cd8-9bd70d603e12
# ╟─9efda440-5d47-48b8-af2f-04c9854c1215
# ╠═378c2153-ae44-4725-a53a-3b01e603c518
# ╠═46c53268-bce5-4707-8999-cf5f33032de3
# ╟─fc72a5d0-3520-468a-af38-533768e331dc
# ╟─027ec3b8-a637-4c56-8663-738fe468a7e4
# ╠═4176f474-dc69-43a6-a3b3-99e1a7817eb5
# ╟─045e7d2f-09a0-422e-889d-d4d36ccdfa3d
# ╠═96ea52f1-627d-4c76-85d1-8b3c2cb89201
# ╠═da3586b0-4066-4c45-a9ea-9b04cbed0225
# ╠═449c4bb1-ad79-4bb7-a24f-616b7fbf9b20
# ╠═6688fc7a-efa8-4919-947d-95de534498b4
# ╠═f1a592e6-65a9-4cca-ad79-7bf3fbe499ee
# ╠═6b9caa54-2088-4a7b-855b-b655ed151e1c
# ╠═2507ef8a-01ae-45b7-af41-6b9416b94ca8
# ╠═be2bc4aa-5b1f-432c-b8d6-d8b5fea6b485
# ╠═81c9d9fb-bfaf-4a4a-8c14-04dc9a16b460
# ╟─a753088d-45b7-4906-be12-725fab875a91
# ╠═36a0261f-f72a-46d8-9517-098ead54307c
# ╠═870cdb15-ea28-46d4-912b-8b4c14341110
# ╠═7a3ed315-a39d-4f7e-8283-8db9b18c7f9b
# ╠═7af16be4-f539-49a6-bd18-a1c6f7cc8b5b
# ╠═3aee4d24-421a-4909-960b-0d1fa902aa70
# ╠═dbb9daa2-bb0a-4ba2-b63a-5acf4ccd02f2
# ╟─ddef6d2b-8b83-4946-8bfb-dc7d9ad83e83
# ╠═57747b7f-21d8-4933-ab46-5ce8d1c95bdc
# ╠═67716938-279e-48c0-8c07-0c6244fe3769
# ╠═1b72ba6e-f1ee-4c09-8c08-f4ad249f73fc
# ╟─5ad9cb4b-bce2-4243-9083-d9b2b0cbc677
# ╠═ab3f7bd5-e989-4acb-bb4e-3f46f92abacd
# ╟─451c9502-4bd7-4d5d-be4a-bf8ba9ad45a0
# ╠═69a5924e-6005-4728-a4e3-c43f433de800
# ╟─7fdd6846-1eef-413a-8614-e4adeb3dfcf3
# ╠═8d58b868-3444-4867-93cc-e0f203453683
# ╟─5d86058f-586f-47cb-bb81-92d87a2293b8
# ╠═e11d53a2-5401-45b4-8ae8-ff4758d3faea
# ╠═d08d181d-484f-4113-937b-2e87a78bdfa0
# ╠═abc7cae7-eb5f-4b14-86c5-e61443fda5fb
# ╠═51404142-836a-4469-8141-028243503c8d
# ╠═0ece90dd-1218-43f2-94c8-13eab4d2320e
# ╠═84a6e004-061b-45a5-a76e-52610b80ec46
# ╠═9c7ad6f3-3338-4ab6-819d-317b508e6322
# ╠═cca208ce-dad7-4a6b-a2f8-e53f0706d9e8
# ╟─32144885-befa-4de0-a90a-18e725436411
# ╠═4d78f6da-da62-47d8-ace0-fd408a610647
# ╠═7ff2a4f1-c815-4e42-9d59-eb11ee43a896
# ╠═3f422bc5-6f5b-40d9-8bb0-85fb44c3798c
# ╠═bb17f741-95c6-4126-8b4d-4549332671c3
# ╟─8eaa5b10-48f8-42a8-b270-ab0a00efe840
# ╠═ef91b505-ecc5-4bcd-9e25-9c6fe54bbbec
# ╠═291ad71d-db9f-4d8b-ba84-8bdcba9e1600
# ╠═3af92217-0239-4a16-a6e9-2cb5927474e7
# ╠═d354417c-91a1-40d3-8489-395c489f89b1
# ╠═c39dfe80-94ff-4a82-859b-e779d09761ba
# ╟─6a039f8f-a3e3-4b1e-af95-95669036aa9e
# ╟─e4cd1b22-afc2-4ec4-90aa-c5e7b8aa87bc
# ╠═1fe65966-328a-4986-b02d-8d8cf889b915
# ╠═f2c8a628-beb6-4374-b8cd-800cbbeb44f9
# ╟─8d62f275-f2d0-4817-972c-d346270c405d
# ╠═40458048-7c42-46d9-8ccd-cb08ba95ead5
# ╠═c91be6d5-8c39-4b20-a56d-e7796245a4ab
# ╠═9b8c9d1f-f8c2-418f-89cc-2a16ce0a8778
# ╠═f6b17de8-84a7-40d3-8105-affedb3b4391
# ╠═4cf3f17d-90c7-4150-b2f4-e538c3b6e027
# ╟─ac19a248-ccae-4156-889b-dd53e94df45a
# ╟─caf25888-c000-43cc-949e-927705faa578
# ╟─7680c625-fc26-42e9-b442-0a4ec265a235
# ╠═37340894-2114-4c70-a697-db1ebf37b695
# ╠═57f29534-e37a-4ffb-9a2a-6e24bc2e32bf
# ╠═50b57258-a22a-4863-bcb5-244266c02d30
# ╠═1ba22a79-1527-43b5-a520-e8da8e6e6101
# ╠═90bb3802-e6cb-43b8-ac06-1e51771e6816
# ╠═5041fdf4-a390-439d-ad37-05b4e25a9a12
# ╠═5b4f0206-cd9d-4c3b-b377-484b438b2788
# ╠═fd7c7549-0504-4547-8e42-a59bcacd8a20
# ╟─22b74523-f971-461c-a3ce-a5e02f7d21dc
# ╠═7ddc7fa6-fb07-48f4-9e2d-d45cab1dd104
# ╠═df1c16c0-a103-454f-ae0b-4ee0362bdfe7
# ╠═d6c2bc4c-289a-4111-a622-a602d3512ff4
# ╟─fe324d86-0975-4936-b20a-783fbcbfc5a2
# ╠═645b2293-297e-498f-9693-4288ce905e4e
# ╠═a68bc144-3176-4901-8d86-65ec6f9194ff
# ╠═fa42b229-43bd-45da-8b97-37b7f10b76e8
# ╟─2da02e06-6789-44c1-bac1-4a8a51bd2e29
# ╟─3bce8f64-6bd4-42e4-a000-dcef73a8bb87
# ╟─eade2c67-b4ec-4d2d-abcb-a4380674e106
# ╟─bab4e011-f2a6-4793-93de-be1b953fa580
# ╟─9c585825-0919-4b88-a5bc-daf41ee5980b
# ╟─7691b66e-bd79-47f3-a199-85702cae2bff
# ╟─4b547e32-694f-4e44-9bdf-54ab6260deff
# ╟─022974ad-ea41-46fb-8b8d-773caab50631
# ╟─38ee915e-caf0-48b9-b457-64d5a4b247fe
# ╟─09d3cec6-75e9-45a9-bdeb-09019418742d
# ╟─172a5e25-9595-4b87-8a03-5c800cd33621
# ╟─08d78ff5-0682-4797-ae41-29bbfb53407a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
