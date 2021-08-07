push!(LOAD_PATH, "src")
using Plots
using TernaryPlots
using CSV
using DataFrames

#Downloading Global whole-rock geochemical database compilation from https://zenodo.org/record/3359791/files/major.csv?download=1
path = "https://zenodo.org/record/3359791/files/major.csv?download=1"
df = CSV.read(download(path), DataFrame)
df = coalesce.(df,0)
filter!(row -> row[:sio2] >= 0, df)
filter!(row -> row[:al2o3] >= 0, df)
filter!(row -> row[:mgo] >= 0, df)
filter!(row -> (row[:sio2] .+ row[:al2o3] .+ row[:mgo]) >= 0.9, df)
filter!(row -> (row[:sio2] .+ row[:al2o3] .+ row[:mgo]) <= 1.1, df)
compos = [df.sio2 df.al2o3 df.mgo]
a = [zeros(eltype(compos), size(compos, 1)) zeros(eltype(compos), size(compos, 1))]

for i in 1:size(compos,1)
    a[i,:] = collect(tern2cart(compos[i,:]))'
end

ternary_axes(
    title="Rocks",
    xguide="SiO2",
    yguide="Al2O3",
    zguide="MgO",
    gridalpha=0.5,
    xgridlinewidth=1,
    ygridlinewidth=1,
    zgridlinewidth=1,
    xgridstyle=:dash,
    ygridstyle=:dash,
    zgridstyle=:dash,
)

p = scatter!(a[:,1],a[:,2], legend=false)