### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 4b9383af-8968-4af2-9298-c9ce114bb675
using PlutoUI, PlutoTeachingTools

# ╔═╡ ebc737da-ea35-48d9-94c6-ad21350d6e37
PlutoUI.TableOfContents()

# ╔═╡ f20a64ce-139a-11ee-275b-913605c7dd62
md"""
# Iterables, induction and recursion

## Goals

- Understand, create and manipulate iterable objects in Julia
- Understand the conceptual division of iterables into ordered and unordered collections
- Express (un/)ordered collections, and operations on them, mathematically.

- Understand and use the concepts of induction and recursion, both in programming and in proving/expressing mathematical concepts. 
"""

# ╔═╡ 262ef047-9366-46ea-b769-0a3257e0ac77
md"""
## Iteration
### Iterator objects
- We previously encountered sets: unordered collections of *things* (e.g. numbers, strings). Imagine sets as a bag. 

- What if we want to take out elements of the bag and do an operation to each of them in turn? This is known as an operation involving **iteration** over the set. For each element of the set, we **iteratively** do something. For this we require an **iterator**. This is a code object that does something **for every element** of a collection. See example below:
"""

# ╔═╡ 387e3e5f-cccf-4bc7-b10a-e6c7e78ab217
S = Set((1,2, 5))

# ╔═╡ 55f9c84e-0d2b-455e-8b19-61f14c83593e
iter = (x*x for x in S)

# ╔═╡ f3dda0bd-c32f-4931-a40f-da7dd45e7f05
md"""
- `iter` is an **Iterator**. It is [**lazy**](https://en.wikipedia.org/wiki/Lazy_evaluation), i.e. it's just an expression at the moment, that hasn't been evaluated. So the compute time would be the same even if `S` had millions of elements.

- However, if inputted to a function that accepts iterators, it will return x*x **for each** element of `S`:
"""

# ╔═╡ cfb60357-d978-461d-bcf1-7dbcb15e0679
sum(iter)

# ╔═╡ f014889d-08bb-439c-90ba-3e1a22c2cf4c
prod(iter)

# ╔═╡ 9f9de79a-3772-46ba-ac1a-77f0d1380838
Set(iter)

# ╔═╡ de3aa4d3-49eb-48a5-9ecd-c432ee44254f
md"""
!!! info "Questions"
	- Fill in `cardinality`  function below. It should return the number of elements in any set given as input. 
"""

# ╔═╡ ee8c5841-0250-486b-82c7-84087a47f3af
cardinality(S::Set) = missing

# ╔═╡ fad53069-5ffd-47c0-a3ac-ad0c4b18db7d
md"""
!!! info "Notation"
	In mathematics, we also have to formulate operations on collections of things. For instance:
	
	$$\sum_{x \in S} x^2$$
	
	is the mathematical expression equivalent to `sum(iter)`:
	- The $\sum$ symbol means `sum over`.
	- The subscript $x \in S$ denotes the elements to sum over. In this case, we iteratively take each element in $S$, call it $x$, and add $x^2$ to our running total. 
	
	- Similarly 

	$$\prod_{x \in S} x^2$$
	is the product of the elements in $S$, equivalent to `prod(iter)`.
	
	- Similarly, $$\{x^2: x \in S \}$$ or 

	$$\{x^2\}_{x \in S}$$ 
	is equivalent to `Set(iter)`. Remember that curly braces denote sets. 


!!! info "Notation"
	The **cardinality** of a set is the number of elements in the set. The notation for the cardinality of a set $S$ is  	$$|S|$$




"""

# ╔═╡ 9da1c569-8432-46f0-bc88-af52c0bd556d
md"""
### Conditional iterators
We can also add **conditions** to iterators. We only take the element from the set if the expression after `if` evaluates to true. 
- See the self-explanatory code below. 
- Note that by using `and` statements (`&&`), we can add any number of conditions


"""

# ╔═╡ 4610f922-745f-4a7e-806a-3a5409fcda8e
conditional_iter = (x*x for x in S if isodd(x))

# ╔═╡ c1b05bfc-c5d2-43ad-90d2-398bbeee5468
sum(conditional_iter)

# ╔═╡ 8b6ba0a5-75fd-4ab0-bef8-78428f346d99
md"""
!!! info "Question"
	Modify `conditional_iter` to only iterate over elements that are between `3` and `10`

"""

# ╔═╡ 37d0c4a8-7e0b-49cc-8c03-a3df6ebd8249
[1, "hi", 3.0]

# ╔═╡ e0e8f616-62d7-4249-92ab-d3d81f1e6f20
md"""
!!! info "Question"
	- build a function that outputs an iterator containing only the string-type elements of a set
	- build a function that takes in an iterator, and outputs an iterator equivalent to the input, but with strings converted to symbols. Note that `Symbol("hi")` turns the string `"hi"` into a symbol. 
	- Compose the functions using the `∘` operator (see live docs)

	- now use the `filter` function (see live docs) to do the same thing

!!! info "Notation"
	- The $\circ$ compose function is the same in both Julia and maths: $f \circ g(x) = f(g(x))$
	- If $f(x) = x^3$ and $g(x) = x^2 + 4$, what are the functions $f \circ g$ and $g \circ f$?

"""

# ╔═╡ 181ae32a-b6cf-42e0-b67b-6a5aefae165d
∘

# ╔═╡ 19928fb4-8dc3-4dce-8063-f54bbab889e7
md"""
### Nesting iterators

- We can chain iterators together 
- View the code below, which makes a separate function $y \to y^n$ for each element $n$ in $S$

"""

# ╔═╡ 0985a299-7d51-45cb-bbae-999fd60c81eb
pow_iter = (y -> y^n for n in S)

# ╔═╡ ea845072-e904-4688-9889-495671023f17
md"""
!!! info "Questions"

	- Write `pow_iter` out in mathematical notation
	- In one line of code, build a function `f(i::Number)` that returns an iterable. Each element of the iterable should correspond to an element of `pow_iter' evaluated at `i`. (Note that each element of pow_iter is a function)
	- Boom, you've nested iterators!
"""

# ╔═╡ 01d9ca23-0b60-4f2b-b513-19696ac4c332
f(i::Number) = (el(i) for el in pow_iter)

# ╔═╡ 506484cf-6972-4f1c-9d75-a25becdaf818
(f(2) for f in pow_iter) |> Set

# ╔═╡ 0691c52a-4820-48d4-ba0c-c3b2d308a4f3
md"""
### Zipping iterators

- Look up `zip` in the live docs. 
- Zipping runs multiple iterators at the same time. 
- Make sure you understand the example below. It uses a `Dict` (i.e. dictionary). This is an unordered collection of pairs. 
"""

# ╔═╡ f6fb4bc5-9956-4e17-ae3b-b9c76e427c12
alphabet = "abcdefghijklmnopqrstuvwxyz"

# ╔═╡ 6af7a884-8752-4f08-9919-3489122b9d79
opposite_pair = Dict(letter => reversal for (letter, reversal) in zip(alphabet, alphabet |> reverse))

# ╔═╡ fb93bade-b3e8-48c8-9eb7-75dc9d5ad919
opposite_pair['a'] 

# ╔═╡ e3038d4e-b0bc-4fe7-b229-6bca2330ece6
tip(md"""
Look at [iteration utilities]() in the julia docs to see all sorts of other useful iterator gymnastics you can do. EG reversing iterators, cycling iterators indefinitely, etc. Mastering the elegant use of iterators is **very useful** when programming, and more importantly for this module helps with your 'maths mindset'. 
""")

# ╔═╡ d1d658b6-96fc-4108-ad8a-ad85984ca5f5
md"""
## Ordered Collections

- Collections are sets of *things*. Ordered collections are sets of things which can be referred to by **indices** (singular is index). Each element of a collection has a position, the index (e.g. the first or fourth element), and can be referred to as such. **Unlike** sets, which are unordered.

- For **any** ordered collection in Julia (or python), one access a numbered element through **square brackets**. EG `x[5]` will return the 5th element of the ordered collection `x`.

### 1. Ranges
- Look like this:`1:10` or `-2:0.2:20` or `range(start, stop, length)`
- They correspond to evenly spaced numbers. The (optional) middle number provides the spacing, and defaults to `1`. But you can should be using the live docs to look things like this up for yourself by now!
- Ranges are **lazy** iterators written as `a:b:c`. This means that defining a range doesn't allocate memory... if you write `1:100000`, the computer doesn't actually store each of the intermediate numbers. Sometimes this is useful: `1:1000000` takes up the same memory as `1:10`!
"""

# ╔═╡ 06a39215-155e-45e7-9939-04c02eed2c61
some_odd_numbers = 1:2:40

# ╔═╡ 6d5065bd-bc9a-4f42-bc5a-66cbe11410d8
?range

# ╔═╡ 0d77bee5-d847-436f-a739-191f647754eb
md"""
- The $n^{th}$ element of an ordered collection can be accessed by appending `[n]` to the ordered collection:

"""

# ╔═╡ fe28c6e1-5216-4d07-9160-5a6bb32e3d15
tip(md"""Square brackets denote **indices of ordered collections**. Round brackets denote **inputs to functions**. Same as Python. Don't mix them up!""")

# ╔═╡ 2042582e-a4fe-492e-bf7c-e7dab458257c
some_odd_numbers[5]

# ╔═╡ db0ec1b7-9a07-414a-94ff-5a5a0c293e73
some_odd_numbers[end-1]

# ╔═╡ 2421944a-5f18-469d-8e79-553cbf5e177e
some_odd_numbers_as_function() = 1:2:40

# ╔═╡ 71341d89-9cb1-44ad-b22d-97d751b6116f
some_odd_numbers_as_function

# ╔═╡ 2af6163e-d8e7-4d46-a460-7fc1dbde7b13
some_odd_numbers_as_function()[7]

# ╔═╡ 3e257b92-45ac-4ac3-a627-057ffc173957
sum(some_odd_numbers)

# ╔═╡ cd85a010-9cdc-4db6-b85d-819a47c3fcc3
md"""
### 2. Arrays
- Arrays are the **general purpose** tool for storing ordered collections of (any) julia objects. You encapsulate the objects in square brackets, and separate them by commas.

"""

# ╔═╡ c65ece43-379b-4c02-bd13-9fd93ae1f1f2
begin 
	simple_array = [1,5,6, "orange"] 
	i_reference_the_same_memory_as_simple_array = simple_array
	i_copied_simple_array = deepcopy(simple_array)
	simple_array[4] = "apple"
	push!(simple_array, "banana")
	popfirst!(simple_array)
	simple_array
end

# ╔═╡ e1e03573-d3d7-45a3-8bb8-582be50fb792
md"""
- Arrays are **mutable**. You can access the nth element of the array, and change it (see above)
- Arrays **pass by reference**. Setting a variable to equal an array (see above) **does not copy the contents of the array** (which might be memory intensive). Instead, think of it as a new hyperlink to the same block of memory on the computer. See above.
"""

# ╔═╡ e3e24453-3c97-4851-9511-071423a0f6b0
tip(md"""As you see above, some julia functions end with a `!`. They are known as in-place functions. Why?
1. Most functions **create a new** julia object representing the output, given an input. 
2. In-place functions **modify their first** input, rather than creating an entirely new output. Less memory usage!
""")

# ╔═╡ 09150459-a958-4778-b54f-cfd3c1c5dd3b
i_reference_the_same_memory_as_simple_array

# ╔═╡ 1d6444ce-a669-42cc-9fc5-2538faebd141
i_copied_simple_array

# ╔═╡ 42fcdaae-464f-4d16-a118-52339a46e14c
simple_array |> typeof

# ╔═╡ 97e92175-a3d2-48d3-908d-998f164cd049
eltype(simple_array)

# ╔═╡ 98230b2d-d200-4e33-9b38-080ce8cc144a
md"""
Here, `{Any}` refers to the type of the elements within the array. It is the `eltype` of the array. In this case, the elements don't share any abstract type (e.g. Number). Otherwise, `{Any}` would be replaced by the most specific abstract type shared by all elements of the array

!!! info "Question"
	1. Make an array whose eltype is `Int64`
	2. Make another array with the same elements whose eltype is `Any`
	3. Compare the performance of summation of each array, using the `@time` macro (see live docs)
	4. Fill in the `in_place_doubling!` function below. It should accept arrays of numbers and modify the array by doubling each number **without creating a new array**
	5. Make a new method for `in_place_doubling!` that accepts arrays of strings, and prepends the string `"double"` to each array element.
"""

# ╔═╡ db73f81c-5011-4d9a-ac40-7d76fcb6f87a
function in_place_doubling!(a::Array{T}) where T<:Number
	missing
end

# ╔═╡ 5a678e22-999b-4245-981f-874f50df0ac9
Array{Any}([1,2])

# ╔═╡ b630f3f3-8dd6-4215-9a2e-1a8dc3aa00e4
md"""
!!! info "Notation"

	- In mathematics, we also use square brackets to denote arrays. For instance:

	$$A = [1,3,  5] \in \mathbb{Z}^3$$
	$$B = [i : \mod(i,3) = 0; i < 100] \in \mathbb{Z}^{100}$$

	- So far we have only considered arrays with a single indexing variable (like $i$ above). These arrays are called **vectors** or (explained subsequently) **1-tensors**.



	- We can also construct arrays by defining their elementwise values, and the number of elements:
	
	$$B \in \mathbb{Z}^{100}: B[i] = 3i$$
"""

# ╔═╡ 338e90ad-7b67-4662-a739-630a24a2077e
md"""
!!! info "Question"
	Build $B$ in Julia twice, reflecting the different, equivalent ways we defined $B$ mathematically. 
"""

# ╔═╡ 80f4d507-ca73-4f0e-9db7-e8c9482b0c0b
collect(iter) # collect all elements of iterator in array

# ╔═╡ 3bc63945-f3a1-4135-850f-920a1367fe25
tip(md"""Programming with arrays that have a concrete type (e.g. `Int64`) as opposed to an abstract type (e.g. `Any`), is much more computationally efficient. And fast code is always a good thing.""")

# ╔═╡ 424315c3-2d2c-4a23-8ca2-3c113deab435
md"""
### 3. Tuples

- Tuples are **immutable**, ordered collections of objects. Once built, they cannot be changed.
- You won't use tuples much in this module, but it's useful to recognise them in code (Python as well!)
- You define a tuple with round brackets (as opposed to square brackets in arrays) **and a trailing comma** (see below)

!!! info "Question"
	Through experimentation, write a paragraph explaining the difference between the eltypes of arrays and tuples containing multiple elements. EG `[1, "hi" false]` vs `(1, "hi" false)` Your answer should contain the phrase **"least common denominator"** (google if necessary)
"""

# ╔═╡ fc77e8d1-a04c-4daa-bd45-9f187f1b4a5e
(1,) |> typeof

# ╔═╡ 00d2f2fe-875d-46fd-8204-05f3369cdcbe
(1,3,) |> sum

# ╔═╡ f2593a21-b670-4d63-b386-1e6c6c11d76e
(1) |> typeof

# ╔═╡ 7894978a-1d38-4940-bef5-00abbbb87860
md"""
### Splatting

- Splatting (using the `...` operator is a useful trick that **unpacks** elements of an ordered collection. Rather than verbal explanation, see the example below and use the live docs:
"""

# ╔═╡ 317d94b6-cd83-44ea-ba59-82116e0899b7
f(x,y) = x + y

# ╔═╡ fc3707b8-7514-4242-8fcd-ee885c8810e2
Set(f(4))

# ╔═╡ 5b5c9a16-607d-4d04-91bb-86d4d7557ac3
packed_inputs = (5,2)

# ╔═╡ 58c9e10a-cbde-480e-ac75-6ef2e81ba617
f(packed_inputs) # errors! why? explain!

# ╔═╡ 6d05f82c-a5c7-4c2a-8077-021918ebba93
f(packed_inputs...)

# ╔═╡ c40902b6-a49f-4283-8a77-448276066010
md"""
!!! info "Notation: iteration over ordered collections"
	... is best shown by example

	In the code below, `ordered_iter` lazily represents the natural numbers from `1` to `100`. Here is how we would 
	- sum them mathematically:
	$$\sum_{i=1}^{100} i$$
	- put them in a set:
	$$\{i\}_{i=1}^{100}$$
	- add conditions
	$$\sum_{i=1; \ 2i > 5}^{100} i$$

!!! info "Question"
	- Is the following true? (Verify, but don't compute, using code)
	$$\sum_{i=1}^{33} B[i] = \sum_{i=1}^{100} i$$

	- Write the vector containing the first $100$ elements of the following sequence using mathematical notation:
	$$[1, 2, 4, 7, 11, 16, \dots]$$
	- Use the previous answer to build an iterator running over this sequence in one short line of code
"""

# ╔═╡ 55626b90-0a21-4f7a-8030-c7a97ff48d4b
md"""
!!! info "Question: The FizzBuzz game"

	This is a classic coding interview question. Write some code that takes in any iterator on the numbers (e.g. the range `1:100`), and outputs an iterator of the same length.
	- If the number is divisible by `3`, then the iterator should return "Fizz"
	- If the number is divisible by `5`, then the iterator should return "Buzz" 
	- If the number is divisible by `15`, then the iterator should return "FizzBuzz"
	- Otherwise, the iterator should output the same number as the input iterator

	**Challenge**: write the code without any `if ... end` statements
"""

# ╔═╡ d6da8780-1993-436f-b3b7-486c957432e5
md"""
## Tensors and Cartesian Indices

- So far, we have considered ordered collections with a **single** indexing variable. E.G. the indexing variable $i$ in the vector $[i]_{i=1}^{100}$

- However, it's often convenient to use **multiple** indexing variables. How do we refer to an element in a table? By it's row **and** column. The row/column number are separate indexing variables.

$$A =
\begin{bmatrix}
A_{11} & A_{12} \\
A_{21} & A_{22}
\end{bmatrix}$$

Thus in code, the bottom left entry of $A$ would be `A[2,1]`. IE 2nd row, 1st column. 


!!! info "Important"
	From now on, we will refer to an ordered collection with $n$ indexing variables as an $n$-tensor, or an $n$-dimensional tensor

So the table above is a two-tensor: to reference its elements we need two indexing variables (row and column number). 

We will sometimes have to deal with objects that have **more than two indexing variables!:**

![](https://codecraft.tv/courses/tensorflowjs/tensors/what-are-tensors/img/designed/3d-tensor.jpg)

!!! info "Important"
	What about an element without indexing variables, like the number 5? This is a **zero-tensor**. We require $0$ indexing variables to access the element. 

"""

# ╔═╡ 6209a439-18f6-4bb4-bd57-49a996f509e1
[i+j for (i,j) in zip(1:10, 2:11)]

# ╔═╡ 4cde198b-42a4-4093-ae44-47905f0e630d
tip(md"""

#### Explicitly writing multidimensional arrays
- Separate the $n^{th}$ dimension by $n$ semicolons

""")

# ╔═╡ 35f22988-ae2e-4ffb-9e91-7ba4e097334c
A = [3;4;;5;6]

# ╔═╡ 358ddd95-0893-40d8-b47b-693a7a67cce8
2A

# ╔═╡ ce9caee0-55a0-41e3-bd56-e2b2374a32e8
sum(A; dims=(1,2))

# ╔═╡ 4f567af7-b2ee-4f73-aa29-20e7024e5cdd
sum(A; dims=(1,)) #what type is the input to dims?

# ╔═╡ d836c138-f683-4554-975b-431fdf99cd7c
md"""
!!! info "Notation"
	Commonly used terms for different tensors:
	
	**1-tensor** $\leftrightarrow$ **Vector**

	**2-tensor** $\leftrightarrow$ **Matrix**


	The 1st/2nd indices of a matrix are called its rows and columns. The 3rd index of a 3-tensor is often referred to as a **layer**. 

	Learn these!!!
"""

# ╔═╡ 64786a5e-aff1-4266-8bb9-f8b477660ed5
md"""
## Reductions

We've previously summed vectors (1-tensors). We ended up with a zero tensor. Summation is a form of **reduction**. We take 
"""

# ╔═╡ 01802d58-6f3a-4858-a97d-820dbad8ce83
reduce(+, 1:10)

# ╔═╡ 62aeabc8-bf74-45d8-8323-8c2efcaeef7a
question_box(md"""
1. Make your own version of the `sum` function. Your function should use `reduce`, but obviously you're not allowed to put `sum` in the code!

2. Make your own function that takes a matrix, and returns two vectors. One holds the mean of its rows. The other holds the mean of its columns.

3. Make your own function that takes a 3d tensor, and returns a matrix which is the sum of its layers.

4. Make a function 
""")

# ╔═╡ 2296fa01-c0e0-4548-9822-7a8a2783e3c4
my_sum(x) = missing

# ╔═╡ 3627e07d-1c43-49b8-97b8-945b8675735b
row_and_col_mean(x) = missing 

# ╔═╡ 368bfc2c-644a-46c9-84a4-b5261e68d5bd
layer_sum(x) = missing

# ╔═╡ 577dfb12-650a-40e9-b19e-79aa67328d4b
total_tensor_sum(x) = missing

# ╔═╡ 4093e894-ff91-4948-a9c0-b10e07867b79
md"""
## Induction
"""

# ╔═╡ 0222fb0b-af4f-4cec-9f79-327994612712
blockquote(md"""Mathematical induction proves that we can climb as high as we like on a ladder, by proving that we can climb onto the bottom rung (the basis) and that from each rung we can climb up to the next one (the step). 

*[Concrete Mathematics](https://en.wikipedia.org/wiki/Concrete_Mathematics), by Knuth, Graham & Patashnik* (a great, freely available book if you're serious about computational maths!)""" )

# ╔═╡ b8b42307-3dcd-4e43-846f-61b435c5117a
md"""
Recall our previous definition of $\mathbb{N}$ as the set of *counting* numbers (i.e. $1$, $2$, $3$, and so on). This is an imprecise definition that we can't express mathematically. Here is an **inductive** definition of $\mathbb{N}$:

$$\begin{align}
& 1 \in \mathbb{N}  \\
& x \in \mathbb{N} \Rightarrow x+1 \in \mathbb{N}
\end{align}$$


There are two components to an inductive definition:
- A base case ($1 \in \mathbb{N}$)
- An inductive step ($x \in \mathbb{N} \Rightarrow x+1 \in \mathbb{N}$)

... and now we've covered all the natural numbers $\mathbb{N}$!

But it gets better. Instead of using induction just to define the natural numbers, we can use it to define **things that are true for all the natural numbers**. You just need to prove the base case, and then the inductive case. And you're going to do it right now!

!!! info "Question"
	Prove that the following equation holds, for all $n \in \mathbb{N}$
	$$\sum_{i=1}^n (2i-1) = n^2$$ 


"""


# ╔═╡ 61b0744c-08a1-4993-a2b2-d32c065600cd
md"""
## Recurrence relations

 $(Resource("https://upload.wikimedia.org/wikipedia/commons/7/71/Serpiente_alquimica.jpg", :width=>300))

*The ourobouros is a mythical dragon that eats its own tail. See the connection?*





!!! info "Question"
	1. Is the following definition correct? Explain your answer, yes or no.
	
	$$\mathbb{N} = \{x : (x = 1) \text{ or } (x-1 \in \mathbb{N}) \}$$

	2. Use your answer to fill in the missing `check_natural` function below. I've put in one line to help you! Only two more lines are required.







"""

# ╔═╡ c831fc0f-d6ba-4720-a4ce-0a4d308f8d76
function check_natural(x)
	(x==1) && return true
	(x < 1) && return false # keep this line in the questions
	return check_natural(x-1)
end

# ╔═╡ 287f80f5-db7d-48a0-96ad-2d67cbd99225
check_natural(35)

# ╔═╡ 273ca57c-7905-49e7-9d58-d2dfe6b0f636
md"""

!!! info "Question"
	Write a `_cumsum` function that takes an integer $n$, and sums all the integers between $[0,n]$ inclusive.
"""

# ╔═╡ 22407a5e-4331-4ca7-b290-c533e408bb06
function _cumsum(n)
	missing
end

# ╔═╡ 01967b04-7d17-4b5b-ba40-dad88a169aa4
_cumsum(10)

# ╔═╡ a8bce8bd-c505-44a5-9d3c-30333e625b36
question_box(md"""
recursive bubble sort.
1. build a function that takes a vector of real numbers, and permutes it so the biggest number is at the end. 
2. use this to build a recursive sorting algorithm 
""")

# ╔═╡ 35b796d2-4e8a-4ec5-b726-5c54304dbb07
function bubble_sort(v)
	missing
end

# ╔═╡ d612f859-67d7-407f-aa2a-a294f68680e6
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]));

# ╔═╡ 0cc0446e-2544-436f-a5cc-5f9b375fd7a1
hint(md"""You need only one line of code, and the `sum` function!""")

# ╔═╡ 67af109a-f38b-4525-b919-dfaadcb6bc51
hint(md""" 
You might need to use two indexing variables, and have a summation **inside** your iteration!
""")

# ╔═╡ 536e4b98-85a6-4b3c-aef0-d73d8562a278
md"""
!!! info "Question"

	### **The Fibonacci sequence**
	1. **Defining the sequence**
	Let $x_i$ denote the $i^{th}$ term of the Fibonacci sequence. The starting elements of the sequence are $x_1 = 0$ and $x_2 = 1$. We define the sequence through the **recursive equation**
	
	$$x_i := x_{i-1} + x_{i-2}$$.
	(Here, the $:=$ operator means *is defined as*)

	2. **Coding the sequence** 

	- Complete the function below so that `fibonacci(n)` returns the $n^{th}$ value of the fibonacci sequence. 

	- You may know `for...end` syntax from your general knowledge. **You are not allowed to use it!**. 
	- You are allowed two `if-end` statements. Or instead (ideally), two uses of the and operator `&&`.

	3. **Extending the sequence** (Optional)

	- make a function `new_fib(x₀, x₁)` that returns a function analogous to `fibonaccci`, but with the first two elements being x₀ and x₁. So `new_fib(0,1)(n) = fibonacci(n)`.

	
"""

# ╔═╡ bb445347-f77a-49c0-a637-5f6609fffb92
function fibonacci(n)
	missing
end

# ╔═╡ dac15fe7-d5b8-436e-a1d4-e4dca460e88d
function new_fib(x₀, x₁)
	missing
end

# ╔═╡ 356c4c0d-3689-4b97-8eea-506942ded0f0
md"""
### **Binary Search**	

Searching over the values of an array generally requires you to check each element sequentially.  However, when we know that the array is sorted, there is a handy trick we can use to search more effectively: **binary search**.  You can think of it as a game of hot and cold.

The secret to binary search is that we keep track of a `low` and a `high` index.  We compare the values of the array at these indices with the value at the midpoint, and then replace the low/high index with the midpoint, if we undershoot/overshoot our target value.  You can find an illustration of this process below (the target is 37).

![alt text](https://blog.penjee.com/wp-content/uploads/2015/04/binary-and-linear-search-animations.gif)

!!! info "Question"
	1. What happens when you search for a value that is not in the array?  What happens to the low/high indices?  How can you catch that case?

	2. Fill in the `binary_search` function below, returning the index of the array that is closest to the value *without going over*.  Use recursion!

	3. When functions are non-decreasing or non-increasing, we can use binary search to find their zeroes.  Use the `binary_search` function to find an $x$ such that $x^2 \approx \mathrm{exp}(x)$.

	
"""

# ╔═╡ 656f4065-94dc-4d1e-8d29-601cdf28b8da
function binary_search(arr, target, low, high)
	missing
end

# ╔═╡ df9c881e-587d-4371-a158-db6b97aa4808
hint(md""" 
Create an array for the interval $[-2, 2]$, and search for an element where $\mathrm{exp}(x) - x^2 \approx 0$.  The more elements in the array, the better the approximation.
""")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoTeachingTools = "~0.2.11"
PlutoUI = "~0.7.51"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.0"
manifest_format = "2.0"
project_hash = "525dcfd80d74b547385aa255d2a38f1acddad3f3"

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
# ╠═4b9383af-8968-4af2-9298-c9ce114bb675
# ╟─ebc737da-ea35-48d9-94c6-ad21350d6e37
# ╟─f20a64ce-139a-11ee-275b-913605c7dd62
# ╟─262ef047-9366-46ea-b769-0a3257e0ac77
# ╠═387e3e5f-cccf-4bc7-b10a-e6c7e78ab217
# ╠═55f9c84e-0d2b-455e-8b19-61f14c83593e
# ╟─f3dda0bd-c32f-4931-a40f-da7dd45e7f05
# ╠═cfb60357-d978-461d-bcf1-7dbcb15e0679
# ╠═f014889d-08bb-439c-90ba-3e1a22c2cf4c
# ╠═9f9de79a-3772-46ba-ac1a-77f0d1380838
# ╟─de3aa4d3-49eb-48a5-9ecd-c432ee44254f
# ╟─0cc0446e-2544-436f-a5cc-5f9b375fd7a1
# ╠═ee8c5841-0250-486b-82c7-84087a47f3af
# ╟─fad53069-5ffd-47c0-a3ac-ad0c4b18db7d
# ╟─9da1c569-8432-46f0-bc88-af52c0bd556d
# ╠═4610f922-745f-4a7e-806a-3a5409fcda8e
# ╠═c1b05bfc-c5d2-43ad-90d2-398bbeee5468
# ╟─8b6ba0a5-75fd-4ab0-bef8-78428f346d99
# ╠═37d0c4a8-7e0b-49cc-8c03-a3df6ebd8249
# ╟─e0e8f616-62d7-4249-92ab-d3d81f1e6f20
# ╠═181ae32a-b6cf-42e0-b67b-6a5aefae165d
# ╟─19928fb4-8dc3-4dce-8063-f54bbab889e7
# ╠═0985a299-7d51-45cb-bbae-999fd60c81eb
# ╟─ea845072-e904-4688-9889-495671023f17
# ╠═01d9ca23-0b60-4f2b-b513-19696ac4c332
# ╠═fc3707b8-7514-4242-8fcd-ee885c8810e2
# ╠═506484cf-6972-4f1c-9d75-a25becdaf818
# ╟─0691c52a-4820-48d4-ba0c-c3b2d308a4f3
# ╠═f6fb4bc5-9956-4e17-ae3b-b9c76e427c12
# ╠═6af7a884-8752-4f08-9919-3489122b9d79
# ╠═fb93bade-b3e8-48c8-9eb7-75dc9d5ad919
# ╟─e3038d4e-b0bc-4fe7-b229-6bca2330ece6
# ╟─d1d658b6-96fc-4108-ad8a-ad85984ca5f5
# ╠═06a39215-155e-45e7-9939-04c02eed2c61
# ╠═6d5065bd-bc9a-4f42-bc5a-66cbe11410d8
# ╟─0d77bee5-d847-436f-a739-191f647754eb
# ╟─fe28c6e1-5216-4d07-9160-5a6bb32e3d15
# ╠═2042582e-a4fe-492e-bf7c-e7dab458257c
# ╠═db0ec1b7-9a07-414a-94ff-5a5a0c293e73
# ╠═2421944a-5f18-469d-8e79-553cbf5e177e
# ╠═71341d89-9cb1-44ad-b22d-97d751b6116f
# ╠═2af6163e-d8e7-4d46-a460-7fc1dbde7b13
# ╠═3e257b92-45ac-4ac3-a627-057ffc173957
# ╟─cd85a010-9cdc-4db6-b85d-819a47c3fcc3
# ╠═c65ece43-379b-4c02-bd13-9fd93ae1f1f2
# ╟─e1e03573-d3d7-45a3-8bb8-582be50fb792
# ╟─e3e24453-3c97-4851-9511-071423a0f6b0
# ╠═09150459-a958-4778-b54f-cfd3c1c5dd3b
# ╠═1d6444ce-a669-42cc-9fc5-2538faebd141
# ╠═42fcdaae-464f-4d16-a118-52339a46e14c
# ╠═97e92175-a3d2-48d3-908d-998f164cd049
# ╟─98230b2d-d200-4e33-9b38-080ce8cc144a
# ╠═db73f81c-5011-4d9a-ac40-7d76fcb6f87a
# ╠═5a678e22-999b-4245-981f-874f50df0ac9
# ╟─b630f3f3-8dd6-4215-9a2e-1a8dc3aa00e4
# ╟─338e90ad-7b67-4662-a739-630a24a2077e
# ╠═80f4d507-ca73-4f0e-9db7-e8c9482b0c0b
# ╟─3bc63945-f3a1-4135-850f-920a1367fe25
# ╟─424315c3-2d2c-4a23-8ca2-3c113deab435
# ╠═fc77e8d1-a04c-4daa-bd45-9f187f1b4a5e
# ╠═00d2f2fe-875d-46fd-8204-05f3369cdcbe
# ╠═f2593a21-b670-4d63-b386-1e6c6c11d76e
# ╟─7894978a-1d38-4940-bef5-00abbbb87860
# ╠═317d94b6-cd83-44ea-ba59-82116e0899b7
# ╠═5b5c9a16-607d-4d04-91bb-86d4d7557ac3
# ╠═58c9e10a-cbde-480e-ac75-6ef2e81ba617
# ╠═6d05f82c-a5c7-4c2a-8077-021918ebba93
# ╟─c40902b6-a49f-4283-8a77-448276066010
# ╟─67af109a-f38b-4525-b919-dfaadcb6bc51
# ╟─55626b90-0a21-4f7a-8030-c7a97ff48d4b
# ╟─d6da8780-1993-436f-b3b7-486c957432e5
# ╠═6209a439-18f6-4bb4-bd57-49a996f509e1
# ╟─4cde198b-42a4-4093-ae44-47905f0e630d
# ╠═35f22988-ae2e-4ffb-9e91-7ba4e097334c
# ╠═358ddd95-0893-40d8-b47b-693a7a67cce8
# ╠═ce9caee0-55a0-41e3-bd56-e2b2374a32e8
# ╠═4f567af7-b2ee-4f73-aa29-20e7024e5cdd
# ╟─d836c138-f683-4554-975b-431fdf99cd7c
# ╟─64786a5e-aff1-4266-8bb9-f8b477660ed5
# ╠═01802d58-6f3a-4858-a97d-820dbad8ce83
# ╟─62aeabc8-bf74-45d8-8323-8c2efcaeef7a
# ╠═2296fa01-c0e0-4548-9822-7a8a2783e3c4
# ╠═3627e07d-1c43-49b8-97b8-945b8675735b
# ╠═368bfc2c-644a-46c9-84a4-b5261e68d5bd
# ╠═577dfb12-650a-40e9-b19e-79aa67328d4b
# ╟─4093e894-ff91-4948-a9c0-b10e07867b79
# ╟─0222fb0b-af4f-4cec-9f79-327994612712
# ╟─b8b42307-3dcd-4e43-846f-61b435c5117a
# ╟─61b0744c-08a1-4993-a2b2-d32c065600cd
# ╠═c831fc0f-d6ba-4720-a4ce-0a4d308f8d76
# ╠═287f80f5-db7d-48a0-96ad-2d67cbd99225
# ╟─273ca57c-7905-49e7-9d58-d2dfe6b0f636
# ╠═22407a5e-4331-4ca7-b290-c533e408bb06
# ╠═01967b04-7d17-4b5b-ba40-dad88a169aa4
# ╟─a8bce8bd-c505-44a5-9d3c-30333e625b36
# ╠═35b796d2-4e8a-4ec5-b726-5c54304dbb07
# ╟─d612f859-67d7-407f-aa2a-a294f68680e6
# ╟─536e4b98-85a6-4b3c-aef0-d73d8562a278
# ╠═bb445347-f77a-49c0-a637-5f6609fffb92
# ╠═dac15fe7-d5b8-436e-a1d4-e4dca460e88d
# ╟─356c4c0d-3689-4b97-8eea-506942ded0f0
# ╠═656f4065-94dc-4d1e-8d29-601cdf28b8da
# ╟─df9c881e-587d-4371-a158-db6b97aa4808
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
