import gleam_community/maths

pub type Fraction {
  Fraction(num: Int, den: Int)
}

pub fn simplify(frac: Fraction) -> Fraction {
  let gcd = maths.gcd(frac.num, frac.den)
  Fraction(frac.num / gcd, frac.den / gcd)
}

pub fn multiply(frac1: Fraction, frac2: Fraction) -> Fraction {
  Fraction(frac1.num * frac2.num, frac1.den * frac2.den) |> simplify
}

pub fn is_equal(frac1, frac2) {
  simplify(frac1) == simplify(frac2)
}
