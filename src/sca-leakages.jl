# This file is part of Jlsca, license is GPLv3, see https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Author: Cees-Bart Breunesse


export Leakage,Bit,HW,leak
export basisModelSingleBits

abstract type Leakage end

# some leakages for CPA

type Bit <: Leakage
  idx::Int
end


leak(this::Bit, intermediate::Union{UInt8,UInt16,UInt32}) = UInt8((intermediate >> this.idx) & 1)

type HW <: Leakage
end

leak(this::HW, intermediate::Union{UInt8,UInt16,UInt32}) = hw(intermediate)

const hw_table = [0x00,0x01,0x01,0x02,0x01,0x02,0x02,0x03,0x01,0x02,0x02,0x03,0x02,0x03,0x03,0x04,0x01,0x02,0x02,0x03,0x02,0x03,0x03,0x04,0x02,0x03,0x03,0x04,0x03,0x04,0x04,0x05,0x01,0x02,0x02,0x03,0x02,0x03,0x03,0x04,0x02,0x03,0x03,0x04,0x03,0x04,0x04,0x05,0x02,0x03,0x03,0x04,0x03,0x04,0x04,0x05,0x03,0x04,0x04,0x05,0x04,0x05,0x05,0x06,0x01,0x02,0x02,0x03,0x02,0x03,0x03,0x04,0x02,0x03,0x03,0x04,0x03,0x04,0x04,0x05,0x02,0x03,0x03,0x04,0x03,0x04,0x04,0x05,0x03,0x04,0x04,0x05,0x04,0x05,0x05,0x06,0x02,0x03,0x03,0x04,0x03,0x04,0x04,0x05,0x03,0x04,0x04,0x05,0x04,0x05,0x05,0x06,0x03,0x04,0x04,0x05,0x04,0x05,0x05,0x06,0x04,0x05,0x05,0x06,0x05,0x06,0x06,0x07,0x01,0x02,0x02,0x03,0x02,0x03,0x03,0x04,0x02,0x03,0x03,0x04,0x03,0x04,0x04,0x05,0x02,0x03,0x03,0x04,0x03,0x04,0x04,0x05,0x03,0x04,0x04,0x05,0x04,0x05,0x05,0x06,0x02,0x03,0x03,0x04,0x03,0x04,0x04,0x05,0x03,0x04,0x04,0x05,0x04,0x05,0x05,0x06,0x03,0x04,0x04,0x05,0x04,0x05,0x05,0x06,0x04,0x05,0x05,0x06,0x05,0x06,0x06,0x07,0x02,0x03,0x03,0x04,0x03,0x04,0x04,0x05,0x03,0x04,0x04,0x05,0x04,0x05,0x05,0x06,0x03,0x04,0x04,0x05,0x04,0x05,0x05,0x06,0x04,0x05,0x05,0x06,0x05,0x06,0x06,0x07,0x03,0x04,0x04,0x05,0x04,0x05,0x05,0x06,0x04,0x05,0x05,0x06,0x05,0x06,0x06,0x07,0x04,0x05,0x05,0x06,0x05,0x06,0x06,0x07,0x05,0x06,0x06,0x07,0x06,0x07,0x07,0x08]

function hw(x::UInt8)
  return hw_table[x + 1]
end

function hw(x::UInt16)
  return hw(UInt8(x>>8)) + hw(UInt8(x & 0xff))
end

function hw(x::UInt32)
  ret::UInt8 = 0
  for i in 0:3
    ret += hw(UInt8((x >> (i*8)) & 0xff))
  end
  return ret
end


# some models for LRA

function basisModelSingleBits(x::Integer, bitWidth=8)
  g = zeros(Float64, bitWidth+1)
  for i in 1:bitWidth
      g[i] = (x >> (i-1)) & 1
  end
  g[length(g)] = 1

  return g
end

# TODO: understand why bitWidth=32 results in non-invertable matrices.
# function basisModelSingleBits(x::UInt32, bits=collect(1:31))
#   g = zeros(Float64, length(bits)+1)
#   for i in bits
#       g[i] = (x >> (i-1)) & 1
#   end
#   g[length(g)] = 1

#   return g
# end
