import numpy as np
from fractions import Fraction


# Calculations to get fractional frequencies based on
# reference freq of 115e6 MHz
def calc_num_den(f_ref, freq):
    lo_ratio = Fraction(str(f_ref)).limit_denominator(10e9)
    ref2out_ratio = float(freq)/float(lo_ratio)
    ref2out = Fraction(str(ref2out_ratio)).limit_denominator(1000000000)
    num = ref2out.numerator
    den = ref2out.denominator
    return num, den


# calculate registers by given fractional frequency
def calc_dds(num_dds, den_dds, dwh=32, dwl=12):
    m, modulo = divmod((1 << dwl), den_dds)
    r = (1 << dwh) * num_dds
    phase_step_h = int(r/den_dds)
    phase_step_l = int(r % den_dds * m)
    return phase_step_h, phase_step_l, modulo


def reg2freq(ph, pl, modulo, fclk, dwh=32, dwl=12):
    resol = fclk / (2**dwh) / (2**dwl - modulo)
    maj_resol = resol*(2**dwl-modulo)
    # print(f'major resolution:  {maj_resol:.3f} Hz')
    # print(f'minor resolution:  {resol:.3f} Hz')
    # print(f'modulo resolution: {resol/2**dwl * pl:.3f} Hz')
    freq = (ph * (2**dwl-modulo) + pl) * resol
    return freq


def save_data(freq_start, freq_stop, steps):
    f = np.arange(freq_start, freq_stop, steps)
    N = len(f)
    num = np.zeros(N)
    den = np.zeros(N)
    step_h = np.zeros(N)
    step_l = np.zeros(N)
    modulo = np.zeros(N)
    for i, j in enumerate(f):
        num[i], den[i] = calc_num_den(115e6, j)
        step_h[i], step_l[i], modulo[i] = calc_dds(num[i], den[i])
    np.savetxt('ntw_analyzer.txt', np.column_stack((j, step_h, step_l,
               modulo)), fmt="%i")


if __name__ == "__main__":

    from argparse import ArgumentParser

    parser = ArgumentParser(description="Ntw analyzer: Frequency to register setting calculation")

    args = parser.parse_args()
    save_data(100e3, 200e3, 100e3)
