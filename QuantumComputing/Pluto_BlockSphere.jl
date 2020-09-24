### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ c8c3cde8-fe40-11ea-209b-c9c59b8051ee
begin
	import Pkg
	Pkg.activate(mktempdir())
end

# ╔═╡ bb54ace0-fe40-11ea-2630-8572bc332f4b
begin
	Pkg.add(["Luxor","Thebes", "PlutoUI"])
	using Luxor, Thebes, PlutoUI
end

# ╔═╡ f0b1fbb6-fe4c-11ea-18ae-7b76ea8207f8
begin
	θslider = @bind θ Slider(0:π/8:2π)
	ϕslider = @bind ϕ Slider(0:π/8:2π)
	view_angle_slider = @bind view_angle Slider(0:π/32:2π)

	md"""# The Bloch Sphere
	
	The Bloch sphere is a visual representation of a single qubit. It can be parameterised in many ways but here we use the Euler angles θ and ϕ. The |0> state is located at the north pole of the sphere and the |1> state is at the south pole. The global phase of the qubit is absent. Play with the values and see what it looks like.
	
	θ: $(θslider)
	ϕ: $(ϕslider)
	
	Camera angle: $(view_angle_slider)
	"""
end

# ╔═╡ 9e18ade8-fe4a-11ea-37ce-2dfd852b75f2
function drawPoly(points)
	pin(points, gfunction = (p3, p2) -> poly(p2, close=true, :fill))
end

# ╔═╡ 2c007f54-fe4c-11ea-0d76-333a1649ecbf
function drawArrow(p2)
    pin(Point3D(0, 0, 0), p2, 
		gfunction = (p3p, p2p) -> arrow(first(p2p), last(p2p), linewidth = 3.0))
end

# ╔═╡ 42fe9c3a-fe57-11ea-01cc-67cb6c1c9818
function drawBlochSphere(θ, ϕ; r = 100)
	Drawing(250,250)
	origin()
	state = Point3D(r*sin(θ)cos(ϕ), r*sin(θ)sin(ϕ), r*cos(θ))

	eyepoint(rotateZ(Point3D(200, 50, 60), view_angle))
	perspective(0)
	
	setcolor(0,0,0, 0.05)
	setline(0.5)
	drawPoly([Point3D(r*cos(θi), r*sin(θi), 0) for θi in 0:π/50:2π])
	for ϕi in 0:π/2:2π
		drawPoly([Point3D(r*sin(θi)cos(ϕi), r*sin(θi)sin(ϕi), r*cos(θi)) for θi in 0:π/50:2π])
	end	

	setcolor("grey90")
    axes3D()
	
	sethue("black")
	setline(4)
	drawArrow(state)
	
	setcolor("white")
	setline(2)
    pin(state, gfunction = (p3p, p2p) -> circle(p2p, 3, :stroke))
end

# ╔═╡ c3a0263e-fe42-11ea-0540-b3b149be6b6f
@draw drawBlochSphere(θ, ϕ)

# ╔═╡ Cell order:
# ╟─c8c3cde8-fe40-11ea-209b-c9c59b8051ee
# ╟─bb54ace0-fe40-11ea-2630-8572bc332f4b
# ╟─f0b1fbb6-fe4c-11ea-18ae-7b76ea8207f8
# ╠═c3a0263e-fe42-11ea-0540-b3b149be6b6f
# ╟─42fe9c3a-fe57-11ea-01cc-67cb6c1c9818
# ╟─9e18ade8-fe4a-11ea-37ce-2dfd852b75f2
# ╟─2c007f54-fe4c-11ea-0d76-333a1649ecbf
