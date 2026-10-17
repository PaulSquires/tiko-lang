// n-body: integrate the orbits of the Jovian planets.
package main

import (
	"fmt"
	"math"
	"os"
	"strconv"
)

const nBodies = 5

// Typed variables, not untyped constants: Go would otherwise evaluate
// 4 * pi * pi and the initial velocities exactly and round once, where the
// other languages round after every operation.
var (
	pi          float64 = 3.141592653589793
	solarMass           = 4 * pi * pi
	daysPerYear float64 = 365.24
)

type Body struct {
	x, y, z, vx, vy, vz, mass float64
}

var bodies = [nBodies]Body{
	{0, 0, 0, 0, 0, 0, solarMass},
	{4.84143144246472090e+00, -1.16032004402742839e+00, -1.03622044471123109e-01,
		1.66007664274403694e-03 * daysPerYear, 7.69901118419740425e-03 * daysPerYear,
		-6.90460016972063023e-05 * daysPerYear, 9.54791938424326609e-04 * solarMass},
	{8.34336671824457987e+00, 4.12479856412430479e+00, -4.03523417114321381e-01,
		-2.76742510726862411e-03 * daysPerYear, 4.99852801234917238e-03 * daysPerYear,
		2.30417297573763929e-05 * daysPerYear, 2.85885980666130812e-04 * solarMass},
	{1.28943695621391310e+01, -1.51111514016986312e+01, -2.23307578892655734e-01,
		2.96460137564761618e-03 * daysPerYear, 2.37847173959480950e-03 * daysPerYear,
		-2.96589568540237556e-05 * daysPerYear, 4.36624404335156298e-05 * solarMass},
	{1.53796971148509165e+01, -2.59193146099879641e+01, 1.79258772950371181e-01,
		2.68067772490389322e-03 * daysPerYear, 1.62824170038242295e-03 * daysPerYear,
		-9.51592254519715870e-05 * daysPerYear, 5.15138902046611451e-05 * solarMass},
}

func advance(dt float64) {
	for i := 0; i < nBodies; i++ {
		b := &bodies[i]
		for j := i + 1; j < nBodies; j++ {
			c := &bodies[j]
			dx, dy, dz := b.x-c.x, b.y-c.y, b.z-c.z
			d2 := dx*dx + dy*dy + dz*dz
			mag := dt / (d2 * math.Sqrt(d2))
			bm, cm := b.mass*mag, c.mass*mag
			b.vx -= dx * cm
			b.vy -= dy * cm
			b.vz -= dz * cm
			c.vx += dx * bm
			c.vy += dy * bm
			c.vz += dz * bm
		}
	}
	for i := range bodies {
		b := &bodies[i]
		b.x += dt * b.vx
		b.y += dt * b.vy
		b.z += dt * b.vz
	}
}

func energy() float64 {
	e := 0.0
	for i := 0; i < nBodies; i++ {
		b := &bodies[i]
		e += 0.5 * b.mass * (b.vx*b.vx + b.vy*b.vy + b.vz*b.vz)
		for j := i + 1; j < nBodies; j++ {
			c := &bodies[j]
			dx, dy, dz := b.x-c.x, b.y-c.y, b.z-c.z
			e -= (b.mass * c.mass) / math.Sqrt(dx*dx+dy*dy+dz*dz)
		}
	}
	return e
}

func offsetMomentum() {
	var px, py, pz float64
	for _, b := range bodies {
		px += b.vx * b.mass
		py += b.vy * b.mass
		pz += b.vz * b.mass
	}
	bodies[0].vx = -px / solarMass
	bodies[0].vy = -py / solarMass
	bodies[0].vz = -pz / solarMass
}

func main() {
	n := 1000
	if len(os.Args) > 1 {
		n, _ = strconv.Atoi(os.Args[1])
	}
	offsetMomentum()
	fmt.Printf("%.9f\n", energy())
	for i := 0; i < n; i++ {
		advance(0.01)
	}
	fmt.Printf("%.9f\n", energy())
}
