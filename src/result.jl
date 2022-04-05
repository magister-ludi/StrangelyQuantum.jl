
"""
    Result(nqubits::Integer, steps::Integer)
A `Result` object contains the probability vector for a system,
and a list of `Qubit`s, each with a `measuredValue`.
Every invocation of `measureSystem(::Result)` method
may result in different values for `measuredValue` for the qubits.
"""
mutable struct Result
    nqubits::Int
    nsteps::Int
    qubits::Union{Nothing, Vector{Qubit}}
    intermediateProps::Vector{Vector{ComplexF64}}
    intermediateQubits::Dict{Int, Vector{Qubit}}
    measuredProbability::Int
    probability::Vector{ComplexF64}

    function Result(nqubits::Integer, steps::Integer)
        @assert steps >= 0
        isteps = steps > 0 ? steps : 1
        return new(nqubits, steps, nothing, [ComplexF64[] for _ = 1:isteps], Dict(), -1)
    end

    function Result(q::AbstractVector{Qubit}, p::AbstractVector{<:Complex})
        res = new()
        res.qubits = q
        res.probability = p
        return res
    end
end

function getQubits(res::Result)
    if res.qubits === nothing
        res.qubits = calculateQubits(res)
    end
    return res.qubits
end

getIntermediateQubits(res::Result) = res.intermediateQubits

function calculateQubits(res::Result)
    answer = Vector{Qubit}(undef, res.nqubits)
    res.nqubits == 0 && return answer

    lastidx = res.nsteps
    while isempty(res.intermediateProps[lastidx])
        lastidx -= 1
    end
    d = calculateQubitStates(res, res.intermediateProps[lastidx])
    for i = 1:length(answer)
        answer[i] = Qubit()
        setProbability(answer[i], d[i])
    end
    return answer
end

function calculateQubits(res::Result, probs::AbstractVector{<:Complex})
    answer = Vector{Qubit}(undef, res.nqubits)
    if res.nqubits == 0
        return answer
    end
    d = calculateQubitStates(res, probs)
    for i = 1:length(answer)
        answer[i] = Qubit()
        setProbability(answer[i], d[i])
    end
    return answer
end

getProbability(res::Result) = res.probability

function setIntermediateProbability(res::Result, step, p)
    res.intermediateProps[step] = p
    res.intermediateQubits[step] = calculateQubits(res, p)
    res.probability = p
end

function getIntermediateProbability(res::Result, step)
    ret = step
    while ret > 1 && !haskey(res.intermediateProps, ret)
        ret -= 1
    end
    return res.intermediateProps[ret]
end

function calculateQubitStates(res::Result, vectorresult)
    nq = round(Int, log2(length(vectorresult)))
    answer = zeros(nq)
    ressize = 1 << nq
    for i = 1:nq
        pw = (i - 1)     # nq - i - 1
        div = 1 << pw
        for j = 1:ressize
            p1 = (j - 1) ÷ div
            if isodd(p1)
                answer[i] += abs2(vectorresult[j])
            end
        end
    end
    return answer
end

"""
    measureSystem(res::Result)
Measure all qubits.
When this method is called, the `measuredValue` value of every qubit
contains a possible measurement value. The values are consistent for the entire system.
(e.g. when an entangled pair is measured, its values are equal)
However, different invocations of this method may result in different values.
"""
function measureSystem(res::Result)
    if res.qubits === nothing
        res.qubits = getQubits(res)
    end

    random = rand()
    #=
    ressize = 1 << res.nqubits
    probamp = Vector{Float64}(undef, ressize)
    probtot = 0.0
    # we don't need all probabilities, but we might use this later
    for i = 1:ressize
        probamp[i] = abs2(res.probability[i])
    end
    sel = 0
    probtot = probamp[1]
    while probtot < random
        sel += 1
        probtot += probamp[sel + 1]
    end
    =#
    probamp = cumsum(abs2.(res.probability))
    sel = findfirst(>(random), probamp) - 1
    res.measuredProbability = sel
    for i = 1:(res.nqubits)
        setMeasuredValue(res.qubits[i], isodd(sel))
        sel ÷= 2
    end
end

"""
Return a measurement based on the probability vector
"""
getMeasuredProbability(res::Result) = res.measuredProbability

printInfo(res::Result) = printInfo(stdout, res)

function printInfo(io::IO, res::Result)
    println(io, "Info about Quantum Result")
    println(io, "==========================")
    println(io, "Number of qubits = ", res.nqubits, ", number of steps = ", res.nsteps)
    for i = 1:length(res.probability)
        println(io, "Probability on ", i, ":", abs2(res.probability[i]))
    end
    println(io, "==========================")
end
