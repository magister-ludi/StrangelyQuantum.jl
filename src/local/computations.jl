
function calculateStepMatrix(gates, nQubits)
    a = [ComplexF64(1);;]
    idx = nQubits
    while idx > 0
        cnt = idx
        gateidx = findfirst(gate -> getHighestAffectedQubitIndex(gate) == cnt, gates)
        myGate = gateidx === nothing ? Identity(idx) : gates[gateidx]
        dbg("stepmatrix, cnt = ", cnt, ", idx = ", idx, ", myGate = ", myGate)
        if myGate isa AbstractBlockGate
            dbg("calculateStepMatrix for blockgate ", myGate, " of class ", typeof(myGate))
            a = kron(a, getMatrix(myGate))
            dbg("calculateStepMatrix for blockgate calculated ", myGate)
            idx -= getSize(myGate) - 1
        elseif myGate isa AbstractSingleQubitGate
            a = kron(a, getMatrix(myGate))
        elseif myGate isa AbstractTwoQubitGate
            a = kron(a, getMatrix(myGate))
            idx -= 1
        elseif myGate isa AbstractThreeQubitGate
            a = kron(a, getMatrix(myGate))
            idx -= 2
        elseif myGate isa PermutationGate
            error("No perm allowed!")
        elseif myGate isa Oracle
            a = getMatrix(myGate)
            idx = 0
        end
        idx -= 1
    end
    return a
end

"""
Decompose a Step into steps that can be processed without permutations
"""
function decomposeStep(s::Step, nqubit)
    answer = Step[]
    push!(answer, s)
    if getType(s) == PseudoStep
        setComplexStep(s, getIndex(s))
        return answer
    end

    gates = getGates(s)
    if isempty(gates)
        return answer
    end

    simple = all(g -> g isa AbstractSingleQubitGate, gates)
    if simple
        return answer
    end
    # if only 1 gate, which is an oracle, return as well
    if length(gates) == 1 && gates[1] isa Oracle
        return answer
    end

    # at least one non-singlequbitgate
    firstGates = Gate[]
    for gate in gates
        if getHighestAffectedQubitIndex(gate) > nqubit
            error(
                string(
                    "Only ",
                    nqubit,
                    " qubits available while gate \"",
                    gate,
                    "\" requires ",
                    getHighestAffectedQubitIndex(gate),
                    " qubits.",
                ),
            )
        end
        if gate isa ProbabilitiesGate
            setInformalStep(s, true)
            return answer
        elseif gate isa AbstractBlockGate
            if gate isa AbstractControlledBlockGate
                processBlockGate(gate, answer)
            end
            push!(firstGates, gate)
        elseif gate isa AbstractSingleQubitGate
            push!(firstGates, gate)
        elseif gate isa AbstractTwoQubitGate
            first = getMainQubitIndex(gate)
            second = getSecondQubitIndex(gate)
            if first > nqubit || second > nqubit
                error("Step $s uses a gate with invalid index $first or $second")
            end
            if first == second + 1
                push!(firstGates, gate)
            else
                if first == second
                    error("Wrong gate, first == second for $gate")
                end
                if first > second
                    pg = PermutationGate(first - 1, second, nqubit)
                    prePermutation = Step(pg)
                    postPermutation = Step(pg)
                    pushfirst!(answer, prePermutation)
                    push!(answer, postPermutation)
                    setComplexStep(postPermutation, getIndex(s))
                    setComplexStep(s, -1)
                else
                    pg = PermutationGate(first, second, nqubit)
                    prePermutation = Step(pg)
                    prePermutationInv = Step(pg)
                    realStep = getIndex(s)
                    setComplexStep(s, -1)
                    pushfirst!(answer, prePermutation)
                    push!(answer, prePermutationInv)
                    postPermutation = Step()
                    postPermutationInv = Step()
                    if first != second - 1
                        pg2 = PermutationGate(second - 1, first, nqubit)
                        addGate(postPermutation, pg2)
                        addGate(postPermutationInv, pg2)
                        insert!(answer, 2, postPermutation)
                        insert!(answer, 4, postPermutationInv)
                    end
                    setComplexStep(prePermutationInv, realStep)
                end
            end
        elseif gate isa AbstractThreeQubitGate
            first = getMainQubit(gate)
            second = getSecondQubit(gate)
            third = getThirdQubit(gate)
            sFirst = first
            sSecond = second
            sThird = third
            if first == second + 1 && second == third + 1
                push!(firstGates, gate)
            else
                p0idx = 1
                maxs = max(second, third)
                if first < maxs
                    pg = PermutationGate(first, maxs, nqubit)
                    prePermutation = Step(pg)
                    postPermutation = Step(pg)
                    insert!(answer, p0idx, prePermutation)
                    insert!(answer, length(answer) - p0idx + 2, postPermutation)
                    p0idx += 1
                    setComplexStep(postPermutation, getIndex(s))
                    setComplexStep(s, -1)
                    sFirst = maxs
                    if second > third
                        sSecond = first
                    else
                        sThird = first
                    end
                end
                if sSecond != sFirst - 1
                    pg = PermutationGate(sFirst - 1, sSecond, nqubit)
                    prePermutation = Step(pg)
                    postPermutation = Step(pg)
                    insert!(answer, p0idx, prePermutation)
                    insert!(answer, length(answer) - p0idx + 2, postPermutation)
                    p0idx += 1
                    setComplexStep(postPermutation, getIndex(s))
                    setComplexStep(s, -1)
                    sSecond = sFirst - 1
                end
                if sThird != sFirst - 2
                    pg = PermutationGate(sFirst - 2, sThird, nqubit)
                    prePermutation = Step(pg)
                    postPermutation = Step(pg)
                    insert!(answer, p0idx, prePermutation)
                    insert!(answer, length(answer) - p0idx + 2, postPermutation)
                    p0idx += 1
                    setComplexStep(postPermutation, getIndex(s))
                    setComplexStep(s, -1)
                    sThird = sFirst - 2
                end
            end
        else
            error("Gate must be SingleQubit, TwoQubit or ThreeQubit")
        end
    end
    return answer
end

function getInverseModulus(a, b)
    r0 = a
    r1 = b
    r2 = 0
    s0 = 1
    s1 = 0
    s2 = 0
    while r1 != 1
        q, r2 = divrem(r0, r1)
        s2 = s0 - q * s1
        r0 = r1
        r1 = r2
        s0 = s1
        s1 = s2
    end
    return s1 > 0 ? s1 : s1 + b
end

function fraction(p::Integer, max::Integer)
    length = ceil(Int, log2(max))
    offset = length
    dim = 1 << offset
    r = p / dim + 0.000001
    period = fraction(r, max)
    return period
end

function fraction(d::AbstractFloat, max::Integer)
    EPS = 1e-15
    h = 0
    k = -1
    a = (int)d
    r = d - a
    h_2 = 0
    h_1 = 1
    k_2 = 1
    k_1 = 0
    while k < max && r > EPS
        h = a * h_1 + h_2
        k = a * k_1 + k_2
        h_2 = h_1
        h_1 = h
        k_2 = k_1
        k_1 = k
        rec = 1 / r
        a = trunc(Int, rec)
        r = rec - a
    end
    return k_2
end

function permutateVector(vector::AbstractVector{T}, a::Integer, b::Integer) where {T}
    amask = 1 << (a - 1)
    bmask = 1 << (b - 1)
    dim = length(vector)
    if amask > dim || bmask > dim
        error("Can not permutate elements $a and $b of vector sized $dim")
    end

    answer = similar(vector)
    for i = 01:dim
        j = i
        x = (amask & (i - 1)) / amask
        y = (bmask & (i - 1)) / bmask
        if x != y
            j = (j - 1) ⊻ amask + 1
            j = (j - 1) ⊻ bmask + 1
        end
        answer[i] = vector[j]
    end
    return answer
end

const nested = Ref(0)  # allows us to e.g. show only 2 nested steps

function calculateNewState(gates, vector, length)
    nested[] += 1
    answer = getNextProbability(getAllGates(gates, length), vector)
    nested[] -= 1
    return answer
end

function getNextProbability(gates, v)
    gate = gates[1]
    nqubits = getSize(gate)
    gatedim = 1 << nqubits
    size = length(v)
    dbg("GETNEXTPROBABILITY asked for size = ", size, " and gates = ", gates)
    if length(gates) > 1
        partdim = size ÷ gatedim
        answer = Vector{ComplexF64}(undef, size)
        nextGates = @view gates[2:end]
        id = all(g -> g isa Identity, nextGates)
        if id
            dbg("ONLY IDENTITY!! partdim = ", partdim)
            oldv = Vector{ComplexF64}(undef, gatedim)
            newv = zeros(ComplexF64, gatedim)
            for j = 1:partdim
                dbg("do part ", j, " of ", partdim)
                for i = 0:(gatedim - 1)
                    oldv[i + 1] = v[i * partdim + j]
                end
                fill!(newv, 0)
                if hasOptimization(gate)
                    dbg("OPTPART!")
                    newv .= applyOptimize(gate, oldv)
                else
                    dbg("GET MATRIX for  ", gate)
                    matrix = getMatrix(gate)
                    newv += matrix * oldv
                    #for (int i = 0  i < gatedim  i++)
                    #    for (int k = 0  k < gatedim  k++)
                    #        newv[i] = newv[i].add(matrix[i][k].mul(oldv[k]))
                    #    end
                    #end
                end
                for i = 0:(gatedim - 1)
                    answer[i * partdim + j] = newv[i + 1]
                end
                dbg("done part")
            end
            return answer
        end

        vsub = Matrix{ComplexF64}(undef, gatedim, partdim)
        vorig = Vector{ComplexF64}(undef, partdim)
        for i = 0:(gatedim - 1)
            for j = 1:partdim
                vorig[j] = v[j + i * partdim]
            end
            vsub[i + 1, :] .= getNextProbability(nextGates, vorig)
        end
        matrix = getMatrix(gate)
        for i = 0:(gatedim - 1)
            for j = 1:partdim
                answer[j + i * partdim] = 0
                for k = 1:gatedim
                    answer[j + i * partdim] += matrix[1 + i, k] * vsub[k, j]
                end
            end
        end
        return answer
    else
        if gatedim != size
            println(stderr, "problem with matrix for gate ", gate)
            error("wrong matrix size $gatedim vs vector size $size")
        end
        if hasOptimization(gate)
            return applyOptimize(gate, v)
        else
            matrix = getMatrix(gate)
            return matrix * v
        end
    end
end

"""
    validateGates(gates, nQubits)
Check if the gates operate on qubits that are part of this Program.
e.g. if a 3-sized gate is applied to qubit 2 in a 3-qubit circuit, this
will throw an IllegalArgumentException.
"""
function validateGates(gates, nQubits)
    for gate in gates
        if getHighestAffectedQubitIndex(gate) > nQubits
            error(
                string(
                    "Gate ",
                    gate,
                    " operates on qubit ",
                    getHighestAffectedQubitIndex(gate),
                    " but we have only ",
                    nQubits,
                    " qubits.",
                ),
            )
        end
    end
end

function getAllGates(gates, nQubits)
    validateGates(gates, nQubits)
    dbg("getAllGates, orig = ", gates)
    answer = Gate[]
    idx = nQubits
    while idx > 0
        cnt = idx
        gate_pos = findfirst(gate -> getHighestAffectedQubitIndex(gate) == cnt, gates)
        myGate = gate_pos === nothing ? Identity(idx) : gates[gate_pos]
        dbg("stepmatrix, cnt = ", cnt, ", idx = ", idx, ", myGate = ", myGate)
        push!(answer, myGate)
        if myGate isa AbstractBlockGate
            idx -= getSize(myGate) - 1
            dbg("processed blockgate, size = ", getSize(myGate), ", idx = ", idx)
        elseif myGate isa AbstractTwoQubitGate
            idx -= 1
        elseif myGate isa AbstractThreeQubitGate
            idx -= 2
        elseif myGate isa PermutationGate
            error("No perm allowed ")
        elseif myGate isa Oracle
            idx = 0
        end
        idx -= 1
    end
    return answer
end

function processBlockGate(gate::AbstractControlledBlockGate, answer)
    master = answer[end]
    calculateHighLow(gate)
    low = getLow(gate)
    control = getControlQubit(gate)
    idx = getMainQubitIndex(gate)
    high = control
    gate_size = getSize(gate)
    gap = control - idx
    perm = PermutationGate[]
    block = getBlock(gate)
    bs = getNQubits(block)
    if control > idx
        if gap < bs
            error("Can't have control at $control for gate with size $bs starting at $idx")
        end

        low = idx
        if gap > bs
            high = control
            gate_size = high - low + 1
            pg = PermutationGate(control, control - gap + bs, low + gate_size)
            push!(perm, pg)
        end
    else
        low = control
        high = idx + bs - 1
        gate_size = high - low + 1
        # gate.correctHigh(low+bs)
        for i = low:(low + gate_size - 2)
            pg = PermutationGate(i, i + 1, low + gate_size)
            pushfirst!(perm, pg)
        end
    end
    for i = 1:length(perm)
        pg = perm[i]
        lpg = Step(pg)
        if i < length(perm)
            setComplexStep(lpg, -1)
        else
            # the complex step should be the last part of the step
            setComplexStep(lpg, getComplexStep(master))
            setComplexStep(master, -1)
        end
        push!(answer, lpg)
        pushfirst!(answer, Step(pg))
    end
end
#=
function calculateQubitStates(vectorresult::AbstractVector{<:Complex})
    nq = round(Int, log2(length(vectorresult)))
    answer = zeros(nq)
    ressize = 1 << nq
    for i = 1:nq
        pw = (i - 1)
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
=#
