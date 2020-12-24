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

const mdim_array = (length: number, dim_count: number, fill: any): any =>
  Array.from(
    { length },
    () => dim_count > 1 ? mdim_array(length, dim_count - 1, fill) : fill
  )

type Coords4D = Record<'h' | 'x' | 'y' | 'z', number>

const count_neighbs = (cube: string[][][][], { h, x, y, z }: Coords4D) => {
  let filled_count = 0
  for (const dz of [-1, 0, 1])
    for (const dy of [-1, 0, 1])
      for (const dx of [-1, 0, 1])
        for (const dh of [-1, 0, 1]) {
          if (dh || dx || dy || dz)
            filled_count += Number(cube[h + dh][z + dz][y + dy][x + dx] === `#`)
        }

  return filled_count
}

const simulate = (times: number, initial: string[][]) => {
  const l = initial.length + times * 2 + 2
  const cube = mdim_array(l, 4, `.`) as string[][][][]
  const mid = l >> 1
  const mid_left = mid - (initial.length >> 1)
  const mid_right = mid + (initial.length >> 1)

  for (let i = mid_left; i <= mid_right; ++i) {
    for (let j = mid_left; j <= mid_right; ++j) {
      cube[mid][mid][i][j] = initial[i - mid_left][j - mid_left]
    }
  }

  for (let t = times, dzh = 1, dxy = (initial.length >> 1) + 1; t > 0; --t, ++dzh, ++dxy) {
    let updates: Array<() => void> = []
    for (let idx = -dxy; idx <= dxy; ++idx) {
      for (let idy = -dxy; idy <= dxy; ++idy) {
        for (let idz = -dzh; idz <= dzh; ++idz) {
          for (let idh = -dzh; idh <= dzh; ++idh) {
            const x = mid + idx
            const y = mid + idy
            const z = mid + idz
            const h = mid + idh
            const is_active = cube[h][z][y][x] === `#`
            const count = count_neighbs(cube, { h, x, y, z })
            const filler = (
              (is_active && [2, 3].includes(count)) || (!is_active && count === 3)
            ) ? `#` : `.`
            updates.push(() => cube[h][z][y][x] = filler)
          }
        }
      }
    }

    // update after all calculations are done
    // because neighbour counting will be wrong if updates are done asap
    updates.forEach(u => u())
    updates = []
  }
  console.log(cube.flat(Infinity).reduce((sum = 0, c = ``) => sum + Number(c === `#`), 0))
  return 0
}

simulate(6, input.split(`\n`).map(line => line.split(``)))
