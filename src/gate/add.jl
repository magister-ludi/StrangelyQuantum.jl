
struct Add <: AbstractBlockGate
    block::Block
    idx::Int
    inverse::Bool
    #Add(x0, x1, y0, y1) = new(createBlock(Add, x0, x1, y0, y1), x0, false)
    function Add(x0, x1, y0, y1)
        block = createBlock(Add, x0, x1, y0, y1)
        return new(block, x0, false)
    end
end

function createBlock(::Type{Add}, x0, x1, y0, y1)
    #warn("This needs checking, the arithmetic is wrong")
    answer = Block("Add", y1 - x0 + 1)
    m = x1 - x0 + 1
    n = y1 - y0 + 1
    #dbg("Block for Add, m = ", m, ", n = " ,n)
    addStep(answer, Step(Fourier(m, 1)))
    for i = 1:m
        for j = 1:(1 + m - i)
            cr0 = 2 * m - j - i + 1
            #dbg("cr0 = ", cr0, " ->", (cr0 >= m + n ? " no" : ""), " step")
            if cr0 < m + n
                dbg("Adding Cr(", i, ", ", cr0 + 1, ", ", 2, ", ", j, ")")
                s = Step(Cr(i, cr0 + 1, 2, j))
                addStep(answer, s)
            end
        end
    end
    addStep(answer, Step(InvFourier(m, 1)))
    return answer
end

getCaption(::Add) = "A\nD\nD"
