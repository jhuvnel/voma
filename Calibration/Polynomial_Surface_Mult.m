function Deg = Polynomial_Surface_Mult(Coeffs, HPixelVal, VPixelVal)
    Deg = Coeffs(1) + Coeffs(2) * HPixelVal + Coeffs(3) * VPixelVal + Coeffs(4) * (HPixelVal^2) + Coeffs(5) * HPixelVal * VPixelVal + Coeffs(6) * (VPixelVal^2);
end
