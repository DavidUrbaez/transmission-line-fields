# Fields Around a Transmission Line — 3D Explorer

Interactive 3D visualization of the electric (E) and magnetic (B) fields in the space
around a 3-phase overhead transmission line with configurable conductor bundles.

![screenshot](docs/screenshot.png)

## Running it

Open `index.html` in any modern browser — no build step, no install.
(Three.js loads from a CDN, so an internet connection is required.)

Or serve it locally:

```
npx http-server . -p 8080
```

## What it shows

- **3D scene** — three phase conductors (flat horizontal configuration) with 1–4
  subconductors per bundle, stretching along the line axis over a ground plane.
- **Cross-section field plane** — a GPU shader computes the *instantaneous* field
  magnitude at every pixel, animated at a slowed-down 60 Hz so you can watch the
  field pattern rotate and breathe through the AC cycle. Log-scale color map.
- **Direction arrows** — a quiver grid showing instantaneous field direction, with
  length/brightness scaled by magnitude.
- **Ground-level profile** — RMS field at 1 m above ground vs. lateral distance,
  the quantity used in ROW / EMF exposure discussions. Peak values are shown in
  the readout panel.

## The physics (all computed live, no canned data)

**E field** — each subconductor carries an unknown line charge. The charges are
found by solving the Maxwell potential coefficient system `V = P·q` with the
method of images for the ground plane:

```
P_ij = ln(D'_ij / D_ij) / (2π ε₀)      D'_ij = distance to image of j
P_ii = ln(2h_i / r) / (2π ε₀)          r = subconductor radius (15 mm)
```

Phase voltages are balanced phasors (0°, −120°, +120°) at the peak
phase-to-ground value. Since `P` is real, the real and imaginary parts of the
charge phasors solve independently. The field is then the superposition of every
line charge and its negative image.

**B field** — each subconductor carries `I/n` of the phase current (balanced,
unity displacement assumed): `B = μ₀ I / (2π r)` in the azimuthal direction.
Earth-return currents are neglected (fine at these distances at 60 Hz).

Both the fragment shader (heatmap) and the JavaScript (arrows, ground profile)
evaluate the same equations.

## Things to try

- Switch between **E** and **B**: E depends on voltage and vanishes near ground
  differently than B, which depends only on current — set current to 0 and watch
  B disappear while E is unchanged.
- Increase **subconductors per bundle** from 1 → 4 and watch the surface field
  intensity at the conductors drop — this is *why* EHV lines use bundles
  (corona control).
- Raise the **conductor height** and watch the ground-level profile flatten.
- Slow the **animation** to see the field null rotate around the center phase as
  the phasors advance.

## Simplifications (MVP)

- 2D electrostatic / magnetostatic cross-section (valid: line length ≫ height,
  60 Hz quasi-static), extruded visually along the line.
- Flat horizontal phase configuration, no sag, no shield wires.
- Perfectly conducting flat earth for E; earth ignored for B.
- Unity power factor (current in phase with voltage).
