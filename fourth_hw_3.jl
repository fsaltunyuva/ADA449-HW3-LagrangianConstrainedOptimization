using Statistics
using BSON
using Random
using LinearAlgebra
using Zygote
using ProgressBars


#### ----- ###
cd(@__DIR__)
#### Before getting started you should write your student_number in integer format
const student_number::Int64 = 0  ## <---replace 0 by your student_number 
### ---- ###
## In this homework we will do little constrained optimization to approximate local minima of some function
## Thorught, we will be assuming that you are dealing with inequality constraints
## To do this you will use lagrange method.
## You should keep in mind that penalization parameter λ and μ is to be chosen by you.
## See the slides for further information
## Here is your optimization problem
## 
## Minimize f(x,y) = (x^2 + y -11)^2 + (x+ y^2 - 7)^2
## subject to norm([x,y]) <= 3.70
## and x+y = 0



### write your objective function, mind the args please!!!
function objective(x::Vector{T}) where T<:AbstractFloat
    return (x[1]^2 + x[2] - 11)^2 + (x[1] + x[2]^2 - 7)^2
end
## write your constraints, mind the args please!!!
function constraints(x::Vector{T}) where T<:AbstractFloat
    ## You will use some penalty functions here, 
    ## Make sure that you pick up the right constraint functions
    ## This function will return two tuples
    ## one is the function of the constraint norm(x) ≤ 3.6
    ## the otherone is x+y = 0
    ## you should see something as follows ([1.0, 2.0]) = (0, 3)
    ## the numbers on the right may change depending on your penalty function

    # ?
    constraint1 = norm(x) - 3.7  # norm([x,y]) <= 3.7 as we did in the lagrangian_method_inequality.jl on LMS
    constraint1 = norm(x) - 3.6 # norm(x) ≤ 3.6 <= 3.6 as we did in the lagrangian_method_inequality.jl on LMS
    
    constraint2 = x[1] + x[2]  # x+y=0
    return constraint1, constraint2
end


function unit_test_1()::Bool
    @assert student_number != 0 "Checkout your student number!!!"
    #
    @assert objective([0.0, 0.0])[1] == 170.0 "Check the objective function"
    @assert objective([0.0, 1.0])[1] == 136.0 "Check the objective function"
    @assert objective([1.0, 1.0])[1] == 106.0 "Check the objective function"
    #
    @assert constraints([1.0, 4.0])[1] > 0.0 "Check the constraint function"
    @assert constraints([0.0, 3.0])[1] == 0.0 "Check the constraint function"
    ## Do something here!!!
    @assert constraints([1.0, 4.0])[2] == 5.0 "Check the constraint function"
    @assert constraints([3.0, 2.0])[2] == 5.0 "Check the constraint function"
    
    ##
    @info "Things are fine comrade!!!"
    return 1
end

### See what you got for us!!!
unit_test_1( )
## ---------------------------------------------------------------- ###
## Let's write the minimize function
## It should return ---- just --- updated x_init
## No println statements !!!!!! just return what you are asked for!!!!
function minimize(objective::Function, 
    constraints::Function, 
    x_init::AbstractVector;
    max_iter::Int64 = 100, 
    lr::Float64 = 0.001,
    stopping_criterion::Float64 = 1e-4,
    lr_λ::Float64 = 0.001,
    lr_μ::Float64 = 0.001)
    
    λ, μ = 0.0, 0.0 ## Do not change this!
    # Follow lagrangian method to approximate the local minima of the function
    return nothing ## you should return the updated x_init, λ and μ.
end

## Let's give a try!!!
minimize(x->objective(x),x->constraints(x), randn(2); lr = 0.001, max_iter = 1000)


function unit_test_2()
    @info "Let's get started!!!!"
    for i in ProgressBar(1:10000)
        Random.seed!(i)
        x_init = minimize(x->objective(x),x->constraints(x), randn(2); lr = 0.00008, max_iter = 1000)
        const_1, const_2 = norm(x_init), sum(x_init)
        if norm([3,2])-1e-3 < const_1 < norm([3,2]) && isapprox(const_2, 5.0; atol = .01)
            @info "Ok buddy, you are doing goooooood!!! the point is $(x_init)"
            return 1
        end
    end
    @info "I am sorry pal! something is wrong with your implementations"
    return 0
end


## See what got for us!!!
unit_test_2()
### 



## No need to run below!!!
if abspath(PROGRAM_FILE) == @__FILE__
    G::Int64 = unit_test_1()+unit_test_2()
    dict_ = Dict("std_ID"=>student_number, "G"=>G)
    try
        BSON.@save "$(student_number).res" dict_ 
        catch Exception 
            println("something went wrong with", Exception)
    end

end