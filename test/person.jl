
struct Person
    name::String
    age::Int
    country::String
end

getName(p::Person) = p.name

getAge(p::Person) = p.age

getCountry(p::Person) = p.country
