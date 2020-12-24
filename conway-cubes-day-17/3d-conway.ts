const input_demo = `.#.
..#
###`

const input = `
.#######
#######.
###.###.
#....###
.#..##..
#.#.###.
###..###
.#.#.##.`

const mdim_array = (length = 1, dim_count = 1, fill = `.`) =>
  Array.from(
    { length },
    () => dim_count > 1 ? mdim_array(length, dim_count - 1, fill) : fill
  )

const debug_layer = (layer = [[``]]) => layer.map((row, i) => `${`0${i}`.slice(-2)} ${row.join(``)}`).join(`\n`)

const debug_cube = (cube = [[[``]]]) =>
  console.log(
    `length: ${cube.length}\n\n`,
    cube.map((layer, z) => `z-index=${z}\n${debug_layer(layer)}`).join(`\n\n`)
  )

const count_neighbs = (cube = [[[``]]], { x, y, z } = { x: 0, y: 0, z: 0 }) => {
  let filled_count = 0
  for (const dz of [-1, 0, 1])
    for (const dy of [-1, 0, 1])
      for (const dx of [-1, 0, 1]) {
        if (dx || dy || dz)
          filled_count += Number(cube[z + dz][y + dy][x + dx] === `#`)
      }

  return filled_count
}

const print_cycles = (cycles = [[[[``]]]]) => {
  const [cube] = cycles
  let output = ``
  for (let z = 0; z < cube.length; ++z) {
    const dim_headers = Array.from({ length: cycles.length }, (_, i) => i + 1).join(` `.repeat(cube.length + 2))
    output += `z-index=${z}\n       ${dim_headers}\n`
    for (let y = 0; y < cube.length; ++y) {
      output += `${y <= 9 ? `0` : ``}${y} `
      for (let i = 0; i < cycles.length; ++i) {
        output += `${cycles[i][z][y].join(``)}  `
      }
      output += `\n`
    }

    output += `\n\n`
  }

  console.log(output)
}

const simulate = (times = 6, initial = input_demo.split(`\n`).map(line => line.split(``))) => {
  const l = initial.length + times * 2 + 2
  const cube = mdim_array(l, 3, `.`)
  const mid = l >> 1
  const mid_left = mid - (initial.length >> 1)
  const mid_right = mid + (initial.length >> 1)

  for (let i = mid_left; i <= mid_right; ++i) {
    for (let j = mid_left; j <= mid_right; ++j) {
      cube[mid][i][j] = initial[i - mid_left][j - mid_left]
    }
  }

  //const debug_cs = [JSON.parse(JSON.stringify(cube))];
  for (let t = times, dz = 1, dxy = (initial.length >> 1) + 1; t > 0; --t, ++dz, ++dxy) {
    let updates = []
    for (let idx = -dxy; idx <= dxy; ++idx) {
      for (let idy = -dxy; idy <= dxy; ++idy) {
        for (let idz = -dz; idz <= dz; ++idz) {
          const x = mid + idx
          const y = mid + idy
          const z = mid + idz
          const is_active = cube[z][y][x] === `#`
          const count = count_neighbs(cube, { x, y, z })
          const filler = (
            (is_active && [2, 3].includes(count)) || (!is_active && count === 3)
          ) ? `#` : `.`
          updates.push({ x, y, z, filler })
        }
      }
    }

    // update after all calculations are done
    // because neighbour counting will be wrong if updates are done asap
    for (const { x, y, z, filler } of updates) {
      cube[z][y][x] = filler
    }
    updates = []

    // debug_cs.push(
    //   JSON.parse(JSON.stringify(cube))
    // )
  }
  console.log(cube.flat(Infinity).reduce((sum = 0, c = ``) => sum + Number(c === `#`), 0))
  return 0
}

simulate()
